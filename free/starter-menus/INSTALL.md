# Starter Menus (Free Edition) — Installation Guide

Total time: about 10 minutes. No paid plugins are involved.

## 1. Install the base plugins

You need **Paper (or a fork) 26.x** with these free plugins. Paper 26.x runs on **Java 25 or newer only** (check with `java -version`). An outdated Java is the most common reason a menu appears to "not work" at all — the server refuses to start before any plugin loads.


1. **DeluxeMenus** 1.14.x or newer — get it from the official HelpChat
   repository or Hangar. Put the jar in `plugins/`.
2. **PlaceholderAPI** — free on SpigotMC. Put the jar in `plugins/`.
3. Start the server once so both plugins create their folders.

Then download the small PlaceholderAPI expansions we use for balance and
player count:

```
/papi ecloud download Player
/papi ecloud download Server
/papi ecloud download Vault
/papi reload
```

## 2. Copy the menus

Copy all three files from this package:

```
menus/hub.yml
menus/help.yml
menus/warps.yml
```

into:

```
plugins/DeluxeMenus/gui_menus/
```

(Create the `gui_menus` folder if it does not exist — newer DeluxeMenus
versions create it on first start.)

## 3. Register the menus in config.yml — do not skip this step

DeluxeMenus only loads menus that are listed in
`plugins/DeluxeMenus/config.yml` under the `gui_menus:` section. A file
sitting in the `gui_menus/` folder without registration is never loaded.

Open `config.yml`, find the `gui_menus:` section (or create it), and add:

```yaml
gui_menus:
  hub:
    file: hub.yml
  help:
    file: help.yml
  warps:
    file: warps.yml
```

The key (`hub`, `help`, `warps`) is the menu's **name**. That name is what
`/dm open help` and the `[openguimenu] help` links inside the menus use —
keep each key equal to its file name to avoid confusion. Then run:

```
/dm reload
```
You may see a `DeluxeMenus: Could not setup a NMS hook` warning in the console — it is harmless: none of these menus use NMS item options.


## 4. Reload and test

Type `/hub` in chat. All three commands:

| Command | Menu |
|---------|------|
| `/hub` | Hub menu |
| `/helpmenu` | Help menu |
| `/warps` | Warp menu |

Nothing shows up? Run `/dm list` — all three menu names (`hub`, `help`,
`warps`) must appear there. If one is missing, check that its `gui_menus:`
entry in `config.yml` exists, then check the console for a YAML error
naming the file.

## 5. Make it yours (cheat sheet)

Every editable spot is marked with an inline `# EDIT:` comment in the files.

| You want to change | Look for |
|--------------------|----------|
| Menu title | `menu_title:` |
| Items and icons | `material:` / `display_name:` / `lore:` |
| What a click does | `left_click_commands:` |
| Warp destinations | `[player] warp <name>` — replace with your warp names |
| Discord / store links | `[message]` lines in `help.yml` |

Useful click-command types (DeluxeMenus):

- `[player] <command>` — runs a command as the clicking player
- `[console] <command>` — runs a command from the console
- `[message] <text>` — sends the player a chat message
- `[openguimenu] <menu_name>` — opens another menu. The name is the
  registered menu name from `config.yml` (equal to the file name in this
  pack), **not** the `/command` that opens it.
- `[close]` — closes the menu

## 6. Warp menu without a warp plugin?

The warp menu calls `/warp <name>` (EssentialsX syntax). If you use another
warp plugin, change each `[player] warp spawn` line to that plugin's command,
e.g. `[console] cmi warp %player% spawn`.

## Requirements recap

- DeluxeMenus 1.14.x+ (MIT licensed, free)
- PlaceholderAPI (free)
- Optional: EssentialsX (free) for the `/warp` command

If anything else on your server blocks the menus (a permission plugin denying
command access, for example), check `/papi parse me %player_name%` first —
broken placeholders are the #1 cause of "menu shows but lore is raw text".

## Need help?

Open a ticket on our support Discord. We answer within 24 hours.
