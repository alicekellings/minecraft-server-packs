# Premium Packs

Paid products. **Source is not in this repository** — this is a catalog so you know what
each pack contains before you buy.

Two product lines:

- **Server setups** — a complete configuration for a whole server type: gameplay, menus,
  permissions, economy wiring, and performance tuning.
- **Menu packs** — standalone DeluxeMenus sets you drop into a server you already run.

All of them target **Paper 26.x on Java 25**, and all of them ship **configuration only** —
you download the plugin jars yourself, so you stay on the newest security builds.

---

## Server setups

### SkyBlock Setup

**Paper 26.x · Island Levels · Teams · 9 Custom GUI Menus**

A SkyBlock server from an empty Paper install to something playable.

- Classic SkyBlock start — one tree, one chest, infinite void (BSkyBlock)
- **Island levels** from blocks and entities, surfaced inside the menus (Level addon)
- **Island teams** — invite friends, co-op islands, shared progress
- **Island protection** and named island homes
- **Sell shop** wired to the EssentialsX economy, with `/worth` price checks
- **9 hand-written GUI menus**: hub, island, levels, shop, team, leaderboard, settings,
  info, reset-confirm. Custom icons, lore and layouts throughout; every button runs a real
  command.
- **Leaderboards** for top islands, top levels and top team sizes, reading live
  PlaceholderAPI values
- **5 permission groups** — `default`, `vip`, `mvp`, `mod`, `admin` — shipped as a
  ready-to-run LuckPerms command list
- **Server tuning** for island load: per-world spawn limits cut from 70 to 8, slower
  autosave, tighter entity activation range, earlier drop merging

Commands are namespaced `sb` (`/sbmenu`, `/sbshop`, `/sbtop`) so they never collide with
EssentialsX or the island plugin.

Verified on Paper **26.2** (build 134) / Java **25** — all 9 menus load clean.

**Status:** in review — listing opens on BuiltByBit when review completes.

---

### OneBlock Setup

**Paper 26.x · OneBlock Phases · Island Levels · 5 Custom GUI Menus**

- **OneBlock progression** — mine a single regenerating block; it changes as you pass
  phase thresholds (AOneBlock's phase system)
- **Phase list** — browse every phase and see which one you're on (`/ob phases`, plus a
  dedicated Phases menu)
- **Island levels** tracked by the Level addon and shown in the menus
- **5 hand-written GUI menus**, every button wired to a real command
- Same performance tuning as SkyBlock Setup, adjusted for OneBlock's world layout

**Status:** in review.

---

### Lifesteal SMP Setup

**Paper 26.x · Steal-Heart Combat · Revive Beacons · 5 Custom GUI Menus**

- **Steal-heart PvP** — kill a player, take one of their hearts; lose all of them and
  you're eliminated until someone revives you (LifeStealZ)
- **Revive beacons** — craftable items that bring an eliminated player back, via a custom
  recipe
- **Heart withdrawal** — turn one of your own hearts into a tradeable item
- **5 hand-written GUI menus** covering the menus players actually need in a Lifesteal
  server

**Status:** in progress.

---

## Menu packs

Standalone DeluxeMenus sets. Drop them into a server you already run.

All three are **bilingual** — every line of text is written **English | 中文** side by
side, so one purchase serves both your English and Chinese players.

They're designed to work together: the free [Starter Menus](../free/starter-menus/) gives
you the hub, and these add the rest.

### Starter Menus Pro

Four menus on top of the free edition:

| Menu | Command | Purpose |
|---|---|---|
| Shop | `/shop` | Category navigation: blocks, farming, tools, ores, redstone, misc |
| Ranks | `/ranks` | Rank showcase with the player's current rank and store links |
| Rewards | `/rewards` | 7-day daily reward claim grid |
| Utilities | `/utils` | Quick actions: fly, craft, ender chest, trash, heal |

**Status:** in progress.

### Economy Menus Pack

| Menu | Command | Purpose |
|---|---|---|
| Store | `/store` | 6 shop categories, live balance, sell shortcut |
| Sell | `/sellmenu` | Quick-sell panel: hand / inventory / blocks |
| Economy | `/economy` | Dashboard: balance card, ways to earn, store and sell links |

**Status:** in progress.

### Leaderboards & Stats Pack

| Menu | Command | Data source |
|---|---|---|
| My Stats | `/mystats` | Vanilla statistics via the official PAPI Statistics expansion |
| Server Stats | `/serverstats` | Official PAPI Server expansion |
| Island Top 10 | `/islandtop` | BentoBox + Level addon |

**$0 in paid plugins** — every placeholder was verified against the source of the data
plugins, not copied from an outdated wiki.

**Status:** in progress.

---

## Licensing

Premium packs come with a commercial license on purchase: use them on servers you run or
on servers you build for clients. They are not covered by the repository
[LICENSE](../LICENSE), which applies only to the free packs.

Third-party plugins remain under their own licenses. No pack in this repository
redistributes plugin jars.
