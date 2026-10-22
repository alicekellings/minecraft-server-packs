# Changelog — SkyBlock Menus Lite

All notable changes to this pack are documented here.
Versions follow `MAJOR.MINOR.PATCH`.

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
