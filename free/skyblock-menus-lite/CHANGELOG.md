# Changelog — SkyBlock Menus Lite

All notable changes to this pack are documented here.
Versions follow `MAJOR.MINOR.PATCH`.

## v1.0.7 — 2026-10-28

Support section corrected

- The README told buyers to send a direct message on BuiltByBit. That is wrong for
  copies downloaded from Spigot or Voxel, and it named a different marketplace inside
  the pack. It now points to the discussion tab of the page you downloaded from and
  to the GitHub issue tracker.
- Removed the "what the paid version adds" block from the shipped README. Marketplace
  rules treat promotion inside the resource itself as an advertisement; the full
  setups are described on the resource page instead. No menu, config or installer
  behaviour changed.

## v1.0.6 — 2026-10-25

README file-count claim corrected

## v1.0.5 — 2026-10-25

### Changed
- **No more editing `eula.txt` by hand.** The first `start.bat` / `start.sh` run asks
  once in the same window: type `YES` to accept the Minecraft EULA and the server
  starts immediately. The old guard refused to run until `eula.txt` existed, and
  only Paper can create it - a fresh install could never start.
- **Start scripts no longer assume a big machine.** Default heap is now `-Xms1G / -Xmx4G`
  (it was 8G on SkyBlock and 6G on Lifesteal, which cannot even start on a 4G host).
  Raise `MAX_RAM` if your machine has more memory.
- **Java 25 is fetched automatically.** When the machine has no Java 25, `install.bat` /
  `install.sh` downloads a portable Temurin JRE into `runtime\` (about 50 MB, once) and
  `start.bat` / `start.sh` use it. There is no manual Java install any more; the manual
  link stays in `INSTALL.md` as a fallback.
- `start.bat` / `start.sh` now say "run install.bat again" when Java is missing, instead
  of letting `java` fail with "not recognized".

### Fixed
- `START-HERE.txt` said "Paper and 10 plugins" when the pack installs 9 plugins plus
  Paper. The count now comes from `pack.json`, so it cannot drift again.

## v1.0.4 — 2026-10-25

Lite is now a complete server, not just a folder of menus.

### Added
- **One-click install.** `install.bat` (Windows) and `install.sh` (Linux / macOS)
  download Paper and every plugin this pack needs, then place each file in its real
  server folder. Every download is checked against a SHA-256 pinned in
  `installer/plugins.list`; a truncated or swapped file is deleted and retried rather
  than used. Re-running is safe — files that already verify are skipped, so a jar you
  upgraded on purpose is never overwritten.
- `START-HERE.txt` — the three steps, on one screen.
- `installer/` — the download manifest and the Windows engine.
- `install.bat "D://servers//my-server"` installs into an existing server and copies
  anything it replaces into `plugins\.setup-backup-<time>\` first.

### Changed
- **The pack is now the real server layout.** `plugins/DeluxeMenus/`,
  `plugins/BentoBox/addons/Level/`. The old `plugins/configs/` mapping layer is
  gone, so there is no path table to read and no chance of putting a file one folder
  off. `luckperms-setup.txt` moved to the pack root.
- `start.bat` / `start.sh` now check for `server.jar` and for `eula=true` before
  starting, and print what to do instead of closing. The old scripts restarted forever
  on a server that exited immediately, which is exactly what a first run does.

### Changed
- `INSTALL.md` used to open with "you need a working Paper server with BentoBox and
  BSkyBlock already running". That is no longer true — the installer builds one.

### Fixed
- `LICENSE-THIRD-PARTY.md` and `SOURCE-OFFER.txt` linked
  `https://github.com/EssentialsX/EssentialsX`, which returns 404. The real repository
  is `EssentialsX/Essentials`. This file is the GPL source offer, so a dead link in it
  is a licensing defect, not just a typo.
- `INSTALL.md` told you to run `/papi ecloud download BentoBox` to make
  `%level_bskyblock_island_level%` work. There is no such expansion: BentoBox registers
  its own PlaceholderAPI expansion at runtime and the Level addon registers `level` on
  top of it. The instruction sent people to download something that does not exist
  while the real cause — a missing Level addon — went unchecked.


### Documented
- Three console lines that a first start always prints are now in the
  troubleshooting table, so they do not read as "the pack is broken":
  `[Essentials] You are running an unsupported server version!` (EssentialsX
  2.22.0 predates Paper 26.2 — everything this pack uses still works),
  `Couldn't load advancements` (a Paper 26.2 startup quirk, present on a stock
  server too), and `[Multiverse-Core] Safe spawn NOT found!!!` (the lobby is a
  flat world, so set your spawn after you build one).

---

## v1.0.3 — 2026-10-23

Documentation fix only. The README described the archive as "nine files" while
the archive has shipped ten since v1.0.2 added `SOURCE-OFFER.txt`. Anyone who
counted the extracted files saw the mismatch.

No configuration, menu or feature changed in this version.

## v1.0.2 — 2026-10-20

Housekeeping — added this changelog and a build script, so the archive is
reproducible instead of hand-zipped.

No configuration, menu or feature changed in this version.

## v1.0.1 — 2026-10-20

Fixed every navigation button in the pack.

### Fixed
- All inter-menu links used the `[open]` action tag, which DeluxeMenus 1.14.1
  does not recognise. Unknown tags are silently ignored at click time — no
  console error, the button simply does nothing. The real tags are
  `[openguimenu]` / `[openmenu]`; every link now uses `[openguimenu]`.

## v1.0.0 — 2026-10-18

First release. Four GUIs: main menu, island menu, info menu, confirm menu.
