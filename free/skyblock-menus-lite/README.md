# SkyBlock Menus Lite

Four hand-built DeluxeMenus GUIs for a BentoBox SkyBlock server. Free edition.

This is a **configuration pack**, not a plugin and not a pre-built world. You supply the
plugin jars; this pack supplies the menus.

Every file was written for this pack. No default configs were copied and resold.

---

## What is inside

```
SkyBlockSetup-Lite-v1/
├── README.md                    this file
├── INSTALL.md                   step-by-step install
├── LICENSE-THIRD-PARTY.md       license text for every dependency
├── SOURCE-OFFER.txt             source links for the GPL-licensed dependencies
└── plugins/configs/deluxemenus/
    ├── config.yml               registers the 4 menus
    └── gui_menus/
        ├── main_menu.yml        hub: island, homes, settings, info, close
        ├── island_menu.yml      go, island info, homes, spawn, reset, back
        ├── info_menu.yml        how it works, commands, rules, back
        └── confirm_menu.yml     reset guard: confirm / cancel
```

Four menus, ten files, no loose ends. Nothing in Lite opens a menu that does not exist.

## Commands

| Command | Opens |
|---|---|
| `/sbmenu` or `/skyblock` | main menu |
| `/sbisland` | island menu |
| `/sbinfo` | info menu |

The confirm menu has no command on purpose — it is only reachable from the island menu,
so nobody can land on a reset confirmation by accident.

## Requirements

- Paper 26.x — built and tested on **Paper 26.2**
- **Java 25** — 26.2 and later require Java 25, not 21
- BentoBox, BSkyBlock and Level
- DeluxeMenus
- PlaceholderAPI (the island level placeholders come from the BentoBox expansion)

Download links are on the resource page under Dependencies.

## What the paid version adds

Lite is the four menus you need to run an island. The full pack adds:

- 6 more GUIs: levels, shop, team, leaderboard, settings, and a separate close/confirm set
- Island level curve — a tuned cost and reward progression instead of the flat default
- 5 LuckPerms groups, scoped to exactly the commands the menus use
- Server tuning — `server.properties`, `bukkit.yml`, `spigot.yml` adjusted for island chunk loading
- A full install guide with screenshots

## Support

Post in the discussion tab or send a direct message here on BuiltByBit.
I answer in English, usually within a day.

## Licensing

The configuration files in this pack are my original work. You may use and edit them on
your own servers. You may not resell or redistribute the pack itself, modified or not.

This pack contains **no third-party jars**. Every dependency is downloaded by you directly
from its author, so no third-party redistribution applies.
