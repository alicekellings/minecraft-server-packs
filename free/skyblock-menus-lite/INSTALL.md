# Installation Guide — SkyBlock Menus Lite

Two double-clicks. The installer downloads Paper and all 5 plugins, checks every file
against a pinned SHA-256, and puts each one where it belongs. There is nothing to copy,
nothing to move, and nothing to rename.

If you would rather fetch the jars yourself, Step 5 lists every file and its
destination — but you do not have to.

---

## Step 1 - Java: nothing to install

Paper **26.x** needs **Java 25**. You do not have to install it. If your machine
already has Java 25, the installer uses it. If not, the installer downloads a
portable copy into `runtime\` (about 50 MB, once) and `start.bat` / `start.sh`
use that one. Nothing is added to your system.

Want to check what you have? `java -version`. If it prints 25 or higher you are
already done. Prefer the official installer?
[Adoptium Temurin 25](https://adoptium.net/temurin/releases/?version=25) - tick
**Set JAVA_HOME** and **Add to PATH**.

---

## Step 2 — Run the installer

**Windows** — double-click `install.bat`.
**Linux / macOS** — `bash install.sh`.

It prints one line per file and ends with `INSTALL COMPLETE`. Expect roughly 75 MB
of download on the first run.

Every file is verified against a SHA-256 pinned inside `installer/plugins.list`. A
truncated download is deleted and retried; it is never used half-written.

If your network blocks one of the download hosts, the installer prints the exact URL
and the exact path to save it to. Put the file there, run the installer again, and it
continues from where it stopped. Files that already verify are skipped, so running it
twice is harmless.

> **Already running a SkyBlock server?** This is the common case for Lite. Point the
> installer at your existing server instead of using this folder as a new one:
>
> ```
> install.bat "D:\servers\my-server"
> ```
>
> It adds the menus and any plugin you are missing, and copies anything it is about to
> replace into `plugins\.setup-backup-<time>\` first. Your worlds and your own
> DeluxeMenus configs are never deleted.

---

## Step 3 - Accept the EULA (one prompt)

The first time you run `start.bat` / `start.sh` it asks once, in the same window:

    Type YES to accept, or press Enter to quit

`YES` accepts https://aka.ms/MinecraftEULA and writes `eula.txt` for you. It never
asks again. Pressing Enter instead starts nothing and changes nothing.

---

## Step 4 — Start the server

Double-click `start.bat` (Windows) or run `bash start.sh` (Linux / macOS).

Wait for:

```
[Server thread/INFO]: Done (42.117s)! For help, type "help"
```

Then, in that same window:

```
op YourMinecraftName
```

Join the server and run `/sbmenu`.

---

## Step 5 — What the installer put where

| File | Version | Destination |
|---|---|---|
| `paper-26.2-134.jar` | Paper 26.2 build 134 | `server.jar` (this folder) |
| `BentoBox-3.23.3.jar` | 3.23.3 | `plugins/` |
| `BSkyBlock-1.20.0.jar` | 1.20.0 | `plugins/BentoBox/addons/` |
| `Level-2.29.0.jar` | 2.29.0 | `plugins/BentoBox/addons/` |
| `DeluxeMenus-1.14.1-Release.jar` | 1.14.1 | `plugins/` |
| `PlaceholderAPI-2.12.3.jar` | 2.12.3 | `plugins/` |

> ⚠️ **BSkyBlock and Level must stay in `plugins/BentoBox/addons/`.** BentoBox only
> ever scans that folder. If they end up in `plugins/` the console prints
> `[BentoBox] Loaded 0 addons`, **no island world is generated at all**, and `/island`
> does nothing. The installer puts them in the right place — this note is only here so
> you do not move them later.

The menus are already at `plugins/DeluxeMenus/`. There is no copy step and no path
table to follow.

**If you installed into an existing server:** back up the `plugins/DeluxeMenus/` folder
before you do it. The installer keeps a copy of anything it replaces, but it does
replace `config.yml`, and that file is the menu registry — any menu not listed in it
will stop loading.

You can delete the sample menus DeluxeMenus generates in `plugins/DeluxeMenus/gui_menus/`
(`basics_menu.yml` and friends) — they are not used by this pack.

---

## Step 6 — Verify

The console should show:

- `[BentoBox] Loaded 2 addons.` near the top.
- No red stack traces.
- `/sbmenu` opens a 27-slot menu with MY ISLAND, ISLAND HOMES, SETTINGS and INFO.

If the menu opens but the lore shows raw `%level_bskyblock_island_level%`, the Level
addon is not loaded. Run `/papi list` — `BentoBox` and `level` must both appear. If
`level` is missing, check `plugins/BentoBox/addons/` actually contains the Level jar.

There is **nothing to download from `papi ecloud`** for these placeholders. BentoBox
registers its own PlaceholderAPI expansion at runtime and the Level addon registers
`level` on top of it.

---

## Menu commands

| Command | Opens |
|---|---|
| `/sbmenu` or `/skyblock` | Main menu |
| `/sbisland` | Island menu |
| `/sbinfo` | Info menu |

The confirm menu has no command on purpose — it is only reachable from the island menu,
so nobody can land on a reset confirmation by accident.

The island itself is driven by BSkyBlock's own `/island` command.

---

## Tuning

`server.properties`, `spigot.yml` and `bukkit.yml` are included and tuned for a small
island server (40 player slots). `start.bat` / `start.sh` default to a 4 GB heap; lower
`MAX_RAM` at the top of the script if your host has less free, or the JVM will refuse
to start with `could not reserve enough space for object heap`.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `install.bat` window flashes and closes | PowerShell was blocked | Run `powershell -ExecutionPolicy Bypass -File installer\install.ps1` from a terminal to see the real error |
| Installer reports `hash mismatch` | Download was truncated or a proxy rewrote it | Run it again — it retries 4 times. If it keeps failing, save that URL by hand to the path it prints |
| `java is not recognized` | Java not on PATH | Reinstall Java 25 with "Add to PATH" ticked, then reopen the window |
| Server exits immediately | EULA not accepted | Run `start.bat` again and type `YES` at the prompt |
| `could not reserve enough space for object heap` | `MAX_RAM` is above the host's real RAM | Lower it at the top of `start.bat` / `start.sh` |
| `/sbmenu` unknown command | DeluxeMenus did not load the menu | Console: the file must be listed under `gui_menus:` in `plugins/DeluxeMenus/config.yml` |
| `/island` unknown command | BSkyBlock is not in `plugins/BentoBox/addons/` | Look for `[BentoBox] Loaded 2 addons.` |
| Menu opens but lore is raw `%level_...%` | PlaceholderAPI or the Level addon is missing | `/papi list` — `BentoBox` and `level` must both appear |
| Menu opens but items are missing | An item slot is outside the menu `size` | Slots start at 0, so `size: 27` accepts slots 0-26 |
| `[open]` does nothing | The target menu is not registered in `config.yml`, or the name does not match the `gui_menus:` key exactly | Check both spellings |
| `[Essentials] You are running an unsupported server version!` | EssentialsX 2.22.0 predates Paper 26.2 and says so on startup | Harmless — `/sell`, `/worth` and the economy all work. Do not downgrade Paper to silence a log line |
| `[Multiverse-Core] Safe spawn NOT found!!!` | The lobby is a flat world, so the default spawn point sits in the air | Harmless until you build a lobby. Stand where players should land and run `/setworldspawn` |
| `Couldn't load advancements: [minecraft:story/...]` | A Paper 26.2 startup quirk, present on a stock server too | Harmless. Nothing in this pack depends on vanilla advancements |

---

## Updating

1. Stop the server.
2. Back up `plugins/` and your world folders.
3. Unzip the new version somewhere else and read its `CHANGELOG.md`.
4. Copy only the files that changelog lists.
5. Start and check the console.

---

## Uninstalling

Delete this folder. The pack writes nothing outside it.
