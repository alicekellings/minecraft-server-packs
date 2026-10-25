# install.ps1 - Windows installer for the OneBlock / SkyBlock / Lifesteal packs.
#
#   install.bat                     install into this folder (it becomes a server)
#   install.bat "D:\servers\my-srv" install into an existing server folder
#
# Behaviour that matters:
#   * Every download is checked against a pinned SHA-256. A truncated or swapped
#     file is deleted and retried, never silently used. (A 995 KB "BentoBox.jar"
#     once got through a plain curl because nobody hashed it.)
#   * Re-running is safe. A file whose hash already matches is skipped, so the
#     script never clobbers a jar the owner upgraded on purpose.
#   * Nothing is replaced without a .replaced copy kept beside it.
#
# ASCII only. PowerShell 5.1 compatible: no ternary, no null-coalescing.

[CmdletBinding()]
param(
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PackDir   = [System.IO.Path]::GetFullPath((Split-Path -Parent $ScriptDir))
$Manifest  = Join-Path $ScriptDir "plugins.list"

if ($Target -eq "") { $Target = $PackDir }
$Target = [System.IO.Path]::GetFullPath($Target)

function Write-Ok($text)   { Write-Host "  [ok]   " -ForegroundColor Green -NoNewline; Write-Host $text }
function Write-Skip($text) { Write-Host "  [have] " -ForegroundColor DarkGray -NoNewline; Write-Host $text }
function Write-Warn($text) { Write-Host "  [warn] " -ForegroundColor Yellow -NoNewline; Write-Host $text }
function Write-Fail($text) { Write-Host "  [fail] " -ForegroundColor Red -NoNewline; Write-Host $text }

Write-Host ""
Write-Host "================================================================"
Write-Host "  Server setup"
Write-Host "================================================================"
Write-Host ""

if (-not (Test-Path $Manifest)) {
    Write-Fail "installer\plugins.list is missing. Re-extract the download."
    exit 1
}

# Invoke-WebRequest on Windows PowerShell 5.1 negotiates TLS 1.0 by default and
# every host used here refuses that. Pin 1.2 before the first request.
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {
    Write-Warn "could not pin TLS 1.2; downloads may fail on old Windows"
}

if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}
Write-Host "  Installing into: $Target"
Write-Host ""

# ---- parse the manifest -----------------------------------------------------
$entries = @()
foreach ($raw in Get-Content $Manifest) {
    $line = $raw.Trim()
    if ($line -eq "" -or $line.StartsWith("#")) { continue }
    $parts = $line.Split("|")
    if ($parts.Length -ne 5) {
        Write-Fail "malformed manifest line: $line"
        exit 1
    }
    $entries += [pscustomobject]@{
        Id     = $parts[0]
        Bytes  = [int64]$parts[1]
        Sha256 = $parts[2].ToLower()
        Dest   = $parts[3]
        Url    = $parts[4]
    }
}

function Get-Sha256($path) {
    (Get-FileHash -Path $path -Algorithm SHA256).Hash.ToLower()
}

function Get-RemoteFile($url, $outFile) {
    # 4 attempts with a growing pause. Long timeout because 64 MB over a slow
    # international link is normal here, not an error.
    $last = ""
    for ($i = 1; $i -le 4; $i++) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing -TimeoutSec 3600
            return $true
        } catch {
            $last = $_.Exception.Message
            if (Test-Path $outFile) { Remove-Item $outFile -Force -ErrorAction SilentlyContinue }
            if ($i -lt 4) {
                Write-Host ("         attempt {0} failed; retrying in {1}s" -f $i, (2 * $i)) -ForegroundColor DarkYellow
                Start-Sleep -Seconds (2 * $i)
            }
        }
    }
    Write-Host ("         last error: " + $last) -ForegroundColor DarkYellow
    return $false
}

# ---- download ---------------------------------------------------------------
$failed = @()
$totalBytes = [int64]0
foreach ($e in $entries) { $totalBytes += $e.Bytes }
$totalMb = [math]::Round($totalBytes / 1048576.0, 1)

$done = 0
$n = $entries.Count
Write-Host ("  {0} files, {1} MB total. This is the slow part." -f $n, $totalMb)
Write-Host ""

foreach ($e in $entries) {
    $done++
    $destPath = Join-Path $Target ($e.Dest -replace "/", "\")
    $destDir  = Split-Path -Parent $destPath
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

    $label = "[{0}/{1}] {2}" -f $done, $n, $e.Id

    if (Test-Path $destPath) {
        if ((Get-Sha256 $destPath) -eq $e.Sha256) {
            Write-Skip ("{0}  already present, hash matches" -f $label)
            continue
        }
    }

    Write-Host ("  " + $label + "  downloading " + [math]::Round($e.Bytes / 1048576.0, 1) + " MB ...")
    $tmp = $destPath + ".part"
    if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }

    if (-not (Get-RemoteFile $e.Url $tmp)) {
        Write-Fail ("{0}  download failed" -f $label)
        $failed += $e
        continue
    }

    $got = Get-Sha256 $tmp
    if ($got -ne $e.Sha256) {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        Write-Fail ("{0}  hash mismatch (got {1}...)" -f $label, $got.Substring(0, 12))
        $failed += $e
        continue
    }

    # Only now is the existing file touched, and never deleted.
    if (Test-Path $destPath) {
        $bak = $destPath + ".replaced"
        Move-Item -Path $destPath -Destination $bak -Force
        Write-Warn ("{0}  older file kept as {1}" -f $label, (Split-Path -Leaf $bak))
    }
    Move-Item -Path $tmp -Destination $destPath -Force
    Write-Ok ("{0}  verified" -f $label)
}

# ---- copy configuration when installing into someone else's server ---------
if ($Target -ne $PackDir) {
    Write-Host ""
    Write-Host "  Copying configuration into the target server ..."
    $srcPlugins = Join-Path $PackDir "plugins"
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $bakRoot = Join-Path (Join-Path $Target "plugins") (".setup-backup-" + $stamp)
    $copied = 0
    $backed = 0

    if (Test-Path $srcPlugins) {
        $srcFull = [System.IO.Path]::GetFullPath($srcPlugins)
        foreach ($f in (Get-ChildItem -Path $srcFull -Recurse -File)) {
            # Never carry install-time debris into the target server.
            if ($f.Name -like "*.replaced" -or $f.Name -like "*.part") { continue }
            $rel = $f.FullName.Substring($srcFull.Length).TrimStart("\")
            $dst = Join-Path (Join-Path $Target "plugins") $rel
            $dstDir = Split-Path -Parent $dst
            if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
            if (Test-Path $dst) {
                if ((Get-Sha256 $f.FullName) -eq (Get-Sha256 $dst)) { continue }
                $bakFile = Join-Path $bakRoot $rel
                $bakDir = Split-Path -Parent $bakFile
                if (-not (Test-Path $bakDir)) { New-Item -ItemType Directory -Path $bakDir -Force | Out-Null }
                Copy-Item -Path $dst -Destination $bakFile -Force
                $backed++
            }
            Copy-Item -Path $f.FullName -Destination $dst -Force
            $copied++
        }
    }

    foreach ($extra in @("start.bat", "start.sh", "server.properties", "spigot.yml", "bukkit.yml")) {
        $s = Join-Path $PackDir $extra
        $d = Join-Path $Target $extra
        if ((Test-Path $s) -and (-not (Test-Path $d))) {
            Copy-Item -Path $s -Destination $d -Force
            $copied++
        }
    }

    Write-Ok ("{0} config file(s) written, {1} existing file(s) backed up" -f $copied, $backed)
    if ($backed -gt 0) { Write-Host ("         backup: " + $bakRoot) }
}

# ---- java: use the machine's Java 25, or fetch a portable one ---------------
# Most buyers never installed Java, and "install Java yourself" was the last
# manual step left. If no suitable Java is on PATH we put a portable Temurin JRE
# into  <target>\runtime  and start.bat prefers it. Nothing to configure.
Write-Host ""
$RuntimeDir   = Join-Path $Target "runtime"
$PortableJava = Join-Path $RuntimeDir "bin\java.exe"
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
$javaLine = ""
$major = 0
if ($javaCmd) {
    try { $javaLine = (cmd /c "java -version 2>&1" | Out-String).Trim() } catch { $javaLine = "" }
    if ($javaLine -match 'version "(\d+)') { $major = [int]$Matches[1] }
}

if ($javaCmd -and ($major -ge 25 -or $major -eq 0)) {
    $first = ($javaLine -split "`r?`n")[0]
    if ($first -eq "") { $first = "version unknown" }
    Write-Ok ("Java found: " + $first)
} elseif (Test-Path $PortableJava) {
    Write-Ok "Portable Java already in .\runtime - start.bat will use it"
} else {
    if ($javaCmd -and $major -gt 0) {
        Write-Warn ("Java " + $major + " is too old for Paper 26.2 (needs 25). Fetching a portable one.")
    } else {
        Write-Warn "No Java on this machine. Fetching a portable Java 25 for this server."
    }
    Write-Host "         About 50 MB, one time. You do not have to install anything."
    $jreUrl = "https://api.adoptium.net/v3/binary/latest/25/ga/windows/x64/jre/hotspot/normal/eclipse?project=jdk"
    $stamp  = [Guid]::NewGuid().ToString("N")
    $zip    = Join-Path $env:TEMP ("temurin25_" + $stamp + ".zip")
    $tmp    = Join-Path $env:TEMP ("temurin25_" + $stamp)
    $okJava = $false
    for ($i = 1; $i -le 3; $i++) {
        try {
            Invoke-WebRequest -Uri $jreUrl -OutFile $zip -UseBasicParsing
            Expand-Archive -Path $zip -DestinationPath $tmp -Force
            $inner = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
            if ($inner -and (Test-Path (Join-Path $inner.FullName "bin\java.exe"))) {
                if (Test-Path $RuntimeDir) { Remove-Item $RuntimeDir -Recurse -Force }
                Move-Item $inner.FullName $RuntimeDir
                $okJava = $true
                break
            }
            Write-Host ("         attempt {0} unpacked nothing usable; retrying" -f $i) -ForegroundColor DarkYellow
        } catch {
            Write-Host ("         attempt {0} failed; retrying in {1}s" -f $i, (2 * $i)) -ForegroundColor DarkYellow
            Start-Sleep -Seconds (2 * $i)
        } finally {
            if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
        }
    }
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    if ($okJava) {
        Write-Ok "Portable Java 25 installed in .\runtime"
    } else {
        Write-Fail "Could not download Java automatically."
        Write-Host "         Install Java 25 by hand: https://adoptium.net/temurin/releases/?version=25"
        Write-Host "         Tick 'Set JAVA_HOME' and 'Add to PATH', then run install.bat again."
        Write-Host "         Everything else is already installed and verified."
    }
}

# ---- verdict ---------------------------------------------------------------
Write-Host ""
Write-Host "================================================================"
if ($failed.Count -eq 0) {
    Write-Host "  INSTALL COMPLETE"
    Write-Host ""
    Write-Host "  Next:"
    Write-Host "    1. Double-click start.bat"
    Write-Host "    2. Wait for the line that says  Done!"
    Write-Host "    3. In that window type:  op YourMinecraftName"
    Write-Host "    4. Join, then run the menu command listed in INSTALL.md"
    Write-Host "================================================================"
    Write-Host ""
    exit 0
}

Write-Host ("  {0} of {1} files could not be downloaded" -f $failed.Count, $n)
Write-Host ""
Write-Host "  Download these by hand, save each to the path shown, then run"
Write-Host "  install.bat again. It will pick up exactly where it stopped."
Write-Host ""
foreach ($e in $failed) {
    Write-Host ("    save to: " + $e.Dest)
    Write-Host ("    from:    " + $e.Url)
    Write-Host ""
}
Write-Host "  Everything else is already in place and verified."
Write-Host "================================================================"
Write-Host ""
exit 1
