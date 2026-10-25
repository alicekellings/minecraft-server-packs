# Third-Party Components & Licenses

**This pack redistributes no third-party software.** It contains only configuration
files and documentation written for this product.

The plugins it configures are downloaded **on your machine, by the installer, from each
project's own release page** — they are never mirrored, repackaged or resold here. Each
one stays under its own license.

---

## Plugins this pack is built against

You install these yourself (see `INSTALL.md` Step 2). They are **not** included in this
package. Check each project for its current license and terms before use.

| Component | What it does | Upstream |
|---|---|---|
| BentoBox | Island framework | https://github.com/BentoBoxWorld/BentoBox |
| BSkyBlock | SkyBlock game mode | https://github.com/BentoBoxWorld/BSkyBlock |
| Level | Island level calculation (feeds the menu placeholders) | https://github.com/BentoBoxWorld/Level |
| DeluxeMenus | Renders the GUI menus | https://github.com/HelpChat/DeluxeMenus |
| PlaceholderAPI | Live placeholders | https://github.com/PlaceholderAPI/PlaceholderAPI |

**Server core** — also fetched by the installer, also not bundled:

| Component | Reason |
|---|---|
| Paper 26.2 build 134 | Downloaded straight from PaperMC's content-addressed CDN, so you get the exact build this pack was tested against — https://papermc.io/downloads/paper |

The paid edition also uses LuckPerms, Vault, EssentialsX and Multiverse-Core. Lite does
not, so they are not listed as requirements here.

---

## What this means for you as the user

- You may **run** this pack on your own server, commercial or not.
- You may **modify the configuration files** freely — they are original work produced for
  this product.
- **Plugin licenses are between you and each plugin's author.** Because this package
  ships no plugin binary — the installer fetches them from upstream on your machine — no
  GPL/LGPL/EPL source-offer obligation attaches to it.
- You may **not** resell this pack as-is as your own product.

---

## Original work in this package

Everything below was written for this product and is the author's work:

- `plugins/DeluxeMenus/config.yml`
- `plugins/DeluxeMenus/gui_menus/main_menu.yml`
- `plugins/DeluxeMenus/gui_menus/island_menu.yml`
- `plugins/DeluxeMenus/gui_menus/info_menu.yml`
- `plugins/DeluxeMenus/gui_menus/confirm_menu.yml`
- `server.properties`, `bukkit.yml`, `spigot.yml`
- `start.sh`, `start.bat`, `install.sh`, `install.bat`, `installer/`
- `README.md`, `INSTALL.md`, `LICENSE-THIRD-PARTY.md`, `SOURCE-OFFER.txt`,
  `CHANGELOG.md`, `START-HERE.txt`

The YAML files follow the configuration format defined by DeluxeMenus; only the content
and layout are ours.
