#!/usr/bin/env bash
# install.sh - Linux / macOS installer for the OneBlock / SkyBlock / Lifesteal packs.
#
#   bash install.sh                       install into this folder
#   bash install.sh /srv/minecraft        install into an existing server folder
#
# Every download is checked against a pinned SHA-256, so a truncated file is
# never used. Re-running is safe: files that already match are skipped and
# nothing is deleted without leaving a .replaced copy.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$SCRIPT_DIR"
MANIFEST="$SCRIPT_DIR/installer/plugins.list"

if [ "$#" -ge 1 ]; then
  TARGET="$1"
else
  TARGET="$PACK_DIR"
fi
mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

ok()   { printf '  \033[32m[ok]\033[0m   %s\n' "$*"; }
skip() { printf '  \033[90m[have]\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m[warn]\033[0m %s\n' "$*"; }
fail() { printf '  \033[31m[fail]\033[0m %s\n' "$*"; }

echo
echo "================================================================"
echo "  Server setup"
echo "================================================================"
echo

if [ ! -f "$MANIFEST" ]; then
  fail "installer/plugins.list is missing. Re-extract the download."
  exit 1
fi

# ---- sha256 without assuming which tool exists -----------------------------
if command -v sha256sum >/dev/null 2>&1; then
  sha_of() { sha256sum "$1" | cut -d' ' -f1 | tr 'A-Z' 'a-z'; }
elif command -v shasum >/dev/null 2>&1; then
  sha_of() { shasum -a 256 "$1" | cut -d' ' -f1 | tr 'A-Z' 'a-z'; }
elif command -v openssl >/dev/null 2>&1; then
  sha_of() { openssl dgst -sha256 "$1" | awk '{print $NF}' | tr 'A-Z' 'a-z'; }
else
  fail "no sha256 tool found (need sha256sum, shasum or openssl)"
  exit 1
fi

fetch() {
  # $1 url  $2 outfile
  local url="$1" out="$2" i
  for i in 1 2 3 4; do
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL --retry 2 --retry-delay 2 --connect-timeout 30 -o "$out" "$url" && return 0
    elif command -v wget >/dev/null 2>&1; then
      wget -q --tries=2 --timeout=60 -O "$out" "$url" && return 0
    else
      fail "neither curl nor wget is available"
      return 1
    fi
    rm -f "$out"
    if [ "$i" -lt 4 ]; then
      echo "         attempt $i failed; retrying in $((i * 2))s"
      sleep $((i * 2))
    fi
  done
  return 1
}

echo "  Installing into: $TARGET"
echo

n=$(grep -c '^[^#]' "$MANIFEST" | tr -d ' ')
total_bytes=$(awk -F'|' '!/^#/ && NF==5 {s+=$2} END {printf "%d", s}' "$MANIFEST")
printf '  %s files, %.1f MB total. This is the slow part.\n\n' "$n" "$(awk -v b="$total_bytes" 'BEGIN{print b/1048576}')"

failed=0
done_n=0
failed_list=""

while IFS='|' read -r id bytes sha dest url; do
  case "$id" in ''|'#'*) continue ;; esac
  done_n=$((done_n + 1))
  label="[$done_n/$n] $id"
  dest_path="$TARGET/$dest"
  mkdir -p "$(dirname "$dest_path")"

  if [ -f "$dest_path" ] && [ "$(sha_of "$dest_path")" = "$sha" ]; then
    skip "$label  already present, hash matches"
    continue
  fi

  mb=$(awk -v b="$bytes" 'BEGIN{printf "%.1f", b/1048576}')
  echo "  $label  downloading $mb MB ..."
  tmp="$dest_path.part"
  rm -f "$tmp"

  if ! fetch "$url" "$tmp"; then
    fail "$label  download failed"
    failed=$((failed + 1))
    failed_list="$failed_list
    save to: $dest
    from:    $url"
    continue
  fi

  got="$(sha_of "$tmp")"
  if [ "$got" != "$sha" ]; then
    rm -f "$tmp"
    fail "$label  hash mismatch (got ${got:0:12}...)"
    failed=$((failed + 1))
    failed_list="$failed_list
    save to: $dest
    from:    $url"
    continue
  fi

  if [ -f "$dest_path" ]; then
    mv -f "$dest_path" "$dest_path.replaced"
    warn "$label  older file kept as $(basename "$dest_path").replaced"
  fi
  mv -f "$tmp" "$dest_path"
  ok "$label  verified"
done < "$MANIFEST"

# ---- copy configuration when installing into someone else's server ---------
if [ "$TARGET" != "$PACK_DIR" ]; then
  echo
  echo "  Copying configuration into the target server ..."
  stamp="$(date +%Y%m%d-%H%M%S)"
  bak_root="$TARGET/plugins/.setup-backup-$stamp"
  copied=0
  backed=0
  if [ -d "$PACK_DIR/plugins" ]; then
    while IFS= read -r -d '' f; do
      case "$f" in *.replaced|*.part) continue ;; esac
      rel="${f#$PACK_DIR/plugins/}"
      dst="$TARGET/plugins/$rel"
      mkdir -p "$(dirname "$dst")"
      if [ -f "$dst" ]; then
        if [ "$(sha_of "$f")" = "$(sha_of "$dst")" ]; then continue; fi
        mkdir -p "$(dirname "$bak_root/$rel")"
        cp -f "$dst" "$bak_root/$rel"
        backed=$((backed + 1))
      fi
      cp -f "$f" "$dst"
      copied=$((copied + 1))
    done < <(find "$PACK_DIR/plugins" -type f -print0)
  fi
  for extra in start.sh start.bat server.properties spigot.yml bukkit.yml; do
    if [ -f "$PACK_DIR/$extra" ] && [ ! -f "$TARGET/$extra" ]; then
      cp -f "$PACK_DIR/$extra" "$TARGET/$extra"
      copied=$((copied + 1))
    fi
  done
  ok "$copied config file(s) written, $backed existing file(s) backed up"
  if [ "$backed" -gt 0 ]; then echo "         backup: $bak_root"; fi
fi

# ---- java: use the machine's Java 25, or fetch a portable one ---------------
# Same rule as the Windows installer: no manual Java install for the buyer.
echo
java_major=0
if command -v java >/dev/null 2>&1; then
  ver="$(java -version 2>&1 | head -1)"
  case "$ver" in
    *'"25'*|*'"26'*|*'"27'*|*'"28'*|*'"29'*|*'"3'*) java_major=25 ;;
  esac
fi

if [ "$java_major" -ge 25 ]; then
  ok "Java found: $(java -version 2>&1 | head -1)"
elif [ -x "$TARGET/runtime/bin/java" ]; then
  ok "Portable Java already in ./runtime - start.sh will use it"
else
  if command -v java >/dev/null 2>&1; then
    warn "Java is older than 25. Fetching a portable Java 25 for this server."
  else
    warn "No Java on this machine. Fetching a portable Java 25 for this server."
  fi
  echo "         About 50 MB, one time. You do not have to install anything."

  os_seg="linux"
  case "$(uname -s)" in
    Darwin) os_seg="mac" ;;
  esac
  arch_seg="x64"
  case "$(uname -m)" in
    aarch64|arm64) arch_seg="aarch64" ;;
  esac
  jre_url="https://api.adoptium.net/v3/binary/latest/25/ga/${os_seg}/${arch_seg}/jre/hotspot/normal/eclipse?project=jdk"

  tmp_dir="$(mktemp -d)"
  ok_java=0
  i=1
  while [ "$i" -le 3 ]; do
    if curl -fL --retry 2 -o "$tmp_dir/jre.tar.gz" "$jre_url" 2>/dev/null \
       || wget -q -O "$tmp_dir/jre.tar.gz" "$jre_url" 2>/dev/null; then
      mkdir -p "$tmp_dir/x"
      tar -xzf "$tmp_dir/jre.tar.gz" -C "$tmp_dir/x" 2>/dev/null || true
      inner="$(find "$tmp_dir/x" -mindepth 1 -maxdepth 1 -type d | head -1)"
      if [ -n "$inner" ] && [ -x "$inner/bin/java" ]; then
        rm -rf "$TARGET/runtime"
        mv "$inner" "$TARGET/runtime"
        ok_java=1
        break
      fi
    fi
    echo "         attempt $i failed; retrying in $((i * 2))s"
    sleep $((i * 2))
    i=$((i + 1))
  done
  rm -rf "$tmp_dir"

  if [ "$ok_java" -eq 1 ]; then
    ok "Portable Java 25 installed in ./runtime"
  else
    fail "Could not download Java automatically."
    echo "         Install Java 25 by hand: https://adoptium.net/temurin/releases/?version=25"
    echo "         Then run install.sh again. Everything else is already installed."
  fi
fi

# ---- verdict ---------------------------------------------------------------
echo
echo "================================================================"
if [ "$failed" -eq 0 ]; then
  echo "  INSTALL COMPLETE"
  echo
  echo "  Next:"
  echo "    1. bash start.sh"
  echo "    2. Wait for the line that says  Done!"
  echo "    3. In that console type:  op YourMinecraftName"
  echo "    4. Join, then run the menu command listed in INSTALL.md"
  echo "================================================================"
  echo
  exit 0
fi

echo "  $failed of $n files could not be downloaded"
echo
echo "  Download these by hand, save each to the path shown, then run"
echo "  install.sh again. It will pick up exactly where it stopped."
echo "$failed_list"
echo
echo "  Everything else is already in place and verified."
echo "================================================================"
echo
exit 1
