# Starter Menus — Free Edition

Three ready-to-use menus for DeluxeMenus, built for survival, skyblock and
lifesteal servers. Drop them in, change a few lines, done.

**This is the free edition of [Starter Menus Pro].** It contains 3 menus.
The Pro edition adds 4 more menus (shop, ranks, rewards, settings) plus
bilingual English/Chinese text.

## What's inside

| Menu | Open command | Purpose |
|------|--------------|---------|
| Hub | `/hub` | Main server menu: play, warps, shop, help |
| Help | `/helpmenu` | Discord, vote links, rules, store |
| Warps | `/warps` | 6 warp slots (spawn, pvp, market, mine, farm, end) |

## Requirements

| Plugin | Version | License | Where to get it |
|--------|---------|---------|-----------------|
| DeluxeMenus | 1.14.x+ | MIT | Official HelpChat repository / Hangar |
| PlaceholderAPI | latest | GPL | SpigotMC (free) |
| eCloud-Player / eCloud-Server / eCloud-Vault expansions | latest | — | `/papi ecloud download Player Server Vault` |

**$0 in paid plugins.** Every menu works on a clean Paper 26.x server with
only the two free plugins above. No dependencies are required to purchase.

## What you get

- 3 original menu files (not derived from any default or shared config)
- Every placeholder and every click command labeled with an inline comment
- A 10-minute install guide with a customization cheat-sheet
- Clean, consistent color scheme in vanilla-friendly tones

## Quick install

1. Install DeluxeMenus + PlaceholderAPI.
2. Copy the three `.yml` files from `menus/` into
   `plugins/DeluxeMenus/gui_menus/`.
3. **Register the menus** in `plugins/DeluxeMenus/config.yml` under
   `gui_menus:` (`hub: file: hub.yml`, `help: file: help.yml`,
   `warps: file: warps.yml`) — DeluxeMenus only loads registered menus.
4. Run `/dm reload`. Type `/hub` — done.

Full details in `INSTALL.md`.

## Terms

You may use and modify these menus on any number of servers that you own or
administer. You may not resell, repackage or redistribute the files, with or
without changes. See `LICENSE-THIRD-PARTY.md` for the full text.

## Support

Questions or issues? Open a ticket on our support Discord — we answer within
24 hours. If something does not work on your server version, tell us the
version and the error and we will fix it.
