# Install — SkyBlock Menus Lite

About 5 minutes. You need a working Paper server with BentoBox and BSkyBlock already
running before the menus will show anything.

---

## 1. Check your versions first

| Requirement | Minimum |
|---|---|
| Paper | 26.x (tested on 26.2) |
| Java | **25** — 26.2 and later will not start on Java 21 |
| BentoBox + BSkyBlock | current release |
| DeluxeMenus | 1.14.x |
| PlaceholderAPI | current release |

If your server is on an older Minecraft version, the menu materials and the placeholder
names may differ. Update the server first.

## 2. Install the plugins

Drop these jars into `plugins/` and start the server once so they generate their folders:

- BentoBox
- BSkyBlock (BentoBox addon)
- Level (BentoBox addon)
- DeluxeMenus
- PlaceholderAPI

Then install the BentoBox placeholder expansion. In the console:

```
papi ecloud download BentoBox
papi reload
```

Without that expansion `%level_bskyblock_island_level%` stays as raw text and the menu
lore looks broken.

## 3. Stop the server

The menus are read on startup. Copy the files while the server is stopped.

## 4. Copy the configs

Copy the contents of `plugins/configs/` over your server's `plugins/` folder, keeping the
folder names:

```
plugins/configs/deluxemenus/config.yml              ->  plugins/DeluxeMenus/config.yml
plugins/configs/deluxemenus/gui_menus/*.yml         ->  plugins/DeluxeMenus/gui_menus/
```

If you already have menus in `plugins/DeluxeMenus/gui_menus/`, back them up first.
Replacing `config.yml` replaces the menu registry, so any menu that is not listed in it
will stop loading.

## 5. Start the server and check

```
/sbmenu
```

You should see a 27-slot menu with MY ISLAND, ISLAND HOMES, SETTINGS and INFO.

If it opens but the lore shows `%level_bskyblock_island_level%`, go back to step 2 — the
PlaceholderAPI expansion is missing.

If the command does nothing, check `plugins/DeluxeMenus/config.yml` has
`register_command: true` under each menu. Without it the command is never registered.

## 6. Rename things

Everything you would want to change is a plain string in the YAML:

| What | Where |
|---|---|
| Menu titles | `menu_title` at the top of each file |
| Colours and text | `display_name` and `lore` on each item |
| Item icons | `material` on each item |
| Command aliases | `open_command` on each menu |

DeluxeMenus uses `&` colour codes. `&8` is dark grey, `&l` is bold.

## Troubleshooting

**Menu opens but items are missing**
An item slot is outside the menu `size`. Slots start at 0, so a `size: 27` menu accepts
slots 0–26.

**`[open]` does nothing**
The target menu is not registered in `config.yml`, or the name does not match the key in
`gui_menus:` exactly.

**Nothing happens on click**
Check the console. DeluxeMenus prints the failing command and the menu file it came from.
