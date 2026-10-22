# Minecraft Server Config Packs

Hand-written configuration packs for **Paper 26.x** servers — SkyBlock, OneBlock,
Lifesteal, and DeluxeMenus GUI sets.

These are **config packs, not plugin bundles**. You download the plugins yourself (which
keeps you on the newest security builds and keeps licensing clean); these packs supply the
configuration that makes them feel finished instead of default.

Every file in every pack was written for that pack. Nothing here is a repackaged plugin
default or a resold copy of someone else's config.

---

## Free packs — full source, no strings

| Pack | What it is |
|---|---|
| **[SkyBlock Menus Lite](free/skyblock-menus-lite/)** | 4 DeluxeMenus GUIs for a BentoBox SkyBlock server. Hub, island, info, and a reset-confirm guard. |
| **[Starter Menus](free/starter-menus/)** | Hub / Help / Warps menus that work on survival, skyblock or lifesteal. Three files, ten-minute install. |

Both are complete and usable as-is. Not demos, not crippled trials — the same files we
run on test servers. Copy them into `plugins/DeluxeMenus/gui_menus/` and go.

---

## Premium packs

Full server setups and larger menu sets. **Source is not published in this repo** — these
are paid products. This table is a catalog, not a download.

| Pack | What it is | Status |
|---|---|---|
| **SkyBlock Setup** | Island levels, teams, protection, homes, sell shop, 9 hand-written GUIs, 5 permission groups, tuned `bukkit.yml` | [Available](https://builtbybit.com/resources/skyblock-menus-island-level-configs.133190/) |
| **OneBlock Setup** | AOneBlock phase progression, island levels, 5 hand-written GUIs | In review |
| **Lifesteal SMP Setup** | Steal-heart PvP, revive beacons, heart withdrawal, 5 hand-written GUIs | In progress |
| **Starter Menus Pro** | 4 more menus on top of the free set: shop, ranks, daily rewards, utilities | In progress |
| **Economy Menus Pack** | Store front with live balance, quick-sell panel, economy dashboard | In progress |
| **Leaderboards & Stats Pack** | Personal stats, server stats, live island top-10 | In progress |

See **[premium/](premium/)** for what each one contains in detail.

The menu packs are bilingual — every line of text is written English | 中文 side by side,
so one purchase serves both your English and Chinese players.

---

## Technical notes

Write-ups on problems that bit us, usually with a config snippet that fixes them.

- **[Why your SkyBlock server lags: `bukkit.yml` spawn limits are per world](docs/bukkit-spawn-limits.md)** —
  the single most common cause of a SkyBlock server that runs fine empty and dies at
  fifty players.

---

## Requirements

Everything in this repo targets **Paper 26.x on Java 25**.

The free packs need only free plugins:

- **DeluxeMenus** (MIT) — the menu engine
- **PlaceholderAPI** (GPL) — for live values in lore
- **BentoBox + BSkyBlock** (free) — SkyBlock Menus Lite only

Exact versions we build against are listed in each pack's `LICENSE-THIRD-PARTY.md`.

---

## License

**Free packs** — use them on any server you run, edit them however you like, and share the
link with anyone. You may not sell them, bundle them into a paid product, or redistribute
them as your own work. Full text in [LICENSE](LICENSE).

**Premium packs** — commercial license is granted with purchase. Not covered by the
license above.

Third-party plugins remain under their own licenses; nothing here redistributes them.
