# Why your SkyBlock server lags: `bukkit.yml` spawn limits are per world

Your SkyBlock server runs at a solid 20 TPS with three players online. You hit forty
players and it falls apart — TPS drops to single digits, mob AI stops responding, and
`/spark` shows most of the tick going into entity ticking.

You check `bukkit.yml`, see `monsters: 70`, and think: *70 mobs, that's nothing.*

That number is not 70 mobs. On a SkyBlock server it is 70 mobs **per world** — and a
SkyBlock server has one world per island.

---

## The mistake

`spawn-limits` in `bukkit.yml` is a **per-world** cap, not a server-wide cap. Bukkit
applies it inside each world's spawner independently.

On a normal survival server this distinction doesn't matter, because you have three
worlds: `world`, `world_nether`, `world_the_end`. Seventy mobs times three is 210. Fine.

BentoBox builds SkyBlock islands as **separate worlds**. One island, one world. That is
what makes per-island protection and per-island level tracking clean — and it is also
what turns a harmless-looking default into a time bomb.

## The arithmetic

```
default monsters per world .......  70
islands (worlds) on your server .. 100
------------------------------------------
theoretical hostile mob cap ......  7,000
```

At 200 islands it's 14,000. At 500 it's 35,000.

Most of those worlds are empty most of the time. It doesn't matter — the cap is a cap,
and the spawner will happily work to fill it in every world a player is near. That is
thousands of mobs' worth of AI, pathfinding, and collision checks competing for the same
tick.

The same multiplication applies to `animals` (default 10) and `water-ambient` (default 20).

---

## The fix

Lower the per-world limits. These are the values we ship in our SkyBlock packs:

```yaml
# bukkit.yml
spawn-limits:
  monsters: 8
  animals: 5
  water-animals: 5
  water-ambient: 5
  water-underground-creature: 3
  axolotls: 3
  ambient: 3

ticks-per:
  animal-spawns: 800
  monster-spawns: 20
  water-spawns: 20
  water-ambient-spawns: 20
  autosave: 12000
```

Two changes, two effects:

- **`spawn-limits` 70 → 8** cuts the worst-case total by roughly 9×. On a 100-island
  server that's 7,000 down to 800.
- **`ticks-per`** is how often the spawner runs. `monster-spawns: 1` means "try every
  tick". Raising it to 20 means one attempt per second instead of twenty. Spawn attempts
  are cheap individually and expensive in aggregate.

Do not set these to 0 or 1. Islands still need mobs to be playable — hostile mobs are how
players get gunpowder, string, and bones. Eight per island is enough for a normal session
and it is the difference between a server that holds 40 players and one that doesn't.

## Then tighten entity activation

`spigot.yml` controls how far away an entity keeps ticking. The defaults are generous
because they assume a normal overworld:

```yaml
# spigot.yml
entity-activation-range:
  animals: 16
  monsters: 24
  raiders: 32
  misc: 8
  water: 8
  villagers: 16
  flying-monsters: 24

merge-radius:
  item: 4.0
  exp: 4.0
```

Shorter ranges mean distant mobs go dormant instead of pathfinding at nothing. A wider
merge radius means a farm dropping 200 items creates 20 stacks instead of 200 entities.

---

## How to check whether this is actually your problem

Don't guess — measure.

1. **`/spark profiler start`**, let it run 30 seconds with players online, then
   `/spark profiler stop`. Look at the entity-tick share. If it's over ~30%, this is your
   problem.
2. **Count worlds.** `/mv list` if you run Multiverse, or just count the folders in the
   server root. That number is your multiplier.
3. **Count entities per world** with `/spark entities` or a command block running
   `/execute in <world> run kill @e[type=!player]` on a test island — if you're anywhere
   near the cap on an island nobody is building on, the cap is too high.

If your TPS is fine until player count rises, and it degrades smoothly rather than
falling off a cliff, per-world caps are the first thing to check.

---

## What this doesn't fix

Per-world spawn limits are the most common cause, but not the only one. If TPS stays bad
after these changes, look at:

- **Hoppers.** A hopper pointing into a full container still ticks. `spigot.yml` has
  `hopper-transfer` and `hopper-check` intervals for exactly this.
- **Spawner mobs.** `nerf-spawner-mobs: true` in `spigot.yml` stops mobs from spawners
  pathfinding at all. Big win on grinders.
- **Chunk loading.** Islands that stay loaded with no player nearby are pure cost. Check
  your island plugin's unload behaviour before anything else.
- **View distance.** `view-distance` in `server.properties` multiplies everything above.
  Six is plenty for SkyBlock.

---

*These are the values we ship in the SkyBlock and OneBlock packs in this repository. If
you want the whole configuration — menus, permissions, economy wiring — rather than just
the performance section, see [premium/](../premium/).*
