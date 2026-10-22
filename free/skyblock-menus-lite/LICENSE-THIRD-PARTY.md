# Third-Party Components & Licenses

**This pack redistributes no third-party software.** It contains only configuration
files and documentation written for this product. The plugins it configures are
downloaded by you, from their own upstream projects, under their own licenses.

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

**Not bundled either** (download separately):

| Component | Reason |
|---|---|
| Paper (server core) | Kept out so you always run the latest security build — https://papermc.io/downloads/paper |

The paid edition also uses LuckPerms, Vault, EssentialsX and Multiverse-Core. Lite does
not, so they are not listed as requirements here.

---

## What this means for you as the user

- You may **run** this pack on your own server, commercial or not.
- You may **modify the configuration files** freely — they are original work produced for
  this product.
- **Plugin licenses are between you and each plugin's author.** Because this pack ships
  no plugin binaries, no GPL/LGPL/EPL source-offer obligation attaches to this package.
- You may **not** resell this pack as-is as your own product.

---

## Original work in this package

Everything below was written for this product and is the author's work:

- `plugins/configs/deluxemenus/config.yml`
- `plugins/configs/deluxemenus/gui_menus/main_menu.yml`
- `plugins/configs/deluxemenus/gui_menus/island_menu.yml`
- `plugins/configs/deluxemenus/gui_menus/info_menu.yml`
- `plugins/configs/deluxemenus/gui_menus/confirm_menu.yml`
- `README.md`, `INSTALL.md`, `LICENSE-THIRD-PARTY.md`, `SOURCE-OFFER.txt`

The YAML files follow the configuration format defined by DeluxeMenus; only the content
and layout are ours.
