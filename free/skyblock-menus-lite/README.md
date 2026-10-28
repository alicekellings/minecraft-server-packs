# SkyBlock Menus Lite

Four hand-built DeluxeMenus GUIs for a BentoBox SkyBlock server. Free edition.

Works two ways: drop it on a server you already run, or use it as a complete starter
server — `install.bat` fetches Paper and the five plugins it needs, verifies every file
against a pinned SHA-256, and puts each one in the right folder. See `START-HERE.txt`.

Every file was written for this pack. No default configs were copied and resold.

---

## What is inside

```
SkyBlockSetup-Lite-v1/
├── START-HERE.txt               three steps, read this first
├── README.md                    this file
├── INSTALL.md                   full guide
├── CHANGELOG.md                 version history
├── LICENSE-THIRD-PARTY.md       license text for every dependency
├── SOURCE-OFFER.txt             source links for the GPL-licensed dependencies
├── install.bat / install.sh     downloads Paper + 5 plugins, checksum-verified
├── installer/                   the download manifest and the Windows engine
├── start.bat / start.sh         Aikar's JVM flags, EULA check, server.jar check
├── server.properties            tuned for a small island server
├── spigot.yml / bukkit.yml      per-world spawn limits cut for island worlds
└── plugins/
    └── DeluxeMenus/
        ├── config.yml           registers the 4 menus
        └── gui_menus/
            ├── main_menu.yml    hub: island, homes, settings, info, close
            ├── island_menu.yml  go, island info, homes, spawn, reset, back
            ├── info_menu.yml    how it works, commands, rules, back
            └── confirm_menu.yml reset guard: confirm / cancel
```

Four menus, one installer, no loose ends. Nothing in Lite opens a menu that does not exist.

The plugin configs are already in their real server folders. There is no copy map, no
rename step, and no "put this here, that there" table to get wrong.

## Commands

| Command | Opens |
|---|---|
| `/sbmenu` or `/skyblock` | main menu |
| `/sbisland` | island menu |
| `/sbinfo` | info menu |

The confirm menu has no command on purpose — it is only reachable from the island menu,
so nobody can land on a reset confirmation by accident.

## Requirements

- **Java 25** — the only thing you install yourself
  (https://adoptium.net/temurin/releases/?version=25, tick "Add to PATH")
- Windows 10/11, or Linux / macOS with bash and curl
- 2 GB RAM minimum; 4 GB comfortable
- About 75 MB of download on first run

Paper 26.2, BentoBox, BSkyBlock, Level, DeluxeMenus and PlaceholderAPI are all fetched
by the installer at pinned versions. You do not pick any of them.

## Quick start

1. Double-click **`install.bat`** — or `bash install.sh`. Wait for `INSTALL COMPLETE`.
   No Java install: if your machine has none, the installer fetches a portable
   Java 25 into `runtime\` and `start.bat` uses it.
2. Double-click **`start.bat`** — or `bash start.sh`. Accept the EULA on the first run,
   type `YES` at the EULA prompt, wait for `Done!`.
3. In the console: `op YourMinecraftName`.
4. Join and run `/sbmenu`.

**Already running a SkyBlock server?** Point the installer at it instead of using this
folder as a new server:

```
install.bat "D:\servers\my-server"
```

It adds the menus and any plugin you are missing, and backs up anything it replaces.

## Support

Post in the discussion tab on the page where you downloaded this pack, or open an
issue at https://github.com/alicekellings/minecraft-server-packs/issues
I answer in English, usually within a day.

## Licensing

The configuration files in this pack are my original work. You may use and edit them on
your own servers. You may not resell or redistribute the pack itself, modified or not.

This pack **redistributes no third-party jar**. The installer downloads each dependency
from its author's own release page and verifies it against a pinned SHA-256, so every
plugin stays under its own license.

## Version

**v1.0.7** — see `CHANGELOG.md`.
