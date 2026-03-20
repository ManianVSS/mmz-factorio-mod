# mmz-factorio-mod
Factorio Mods by MMZ

## Overview
`MMZAccelerationMod` is a Factorio mod focused on accelerated progression and quality-of-life improvements. It enables key early game recipes, increases movement and production speeds, expands inventory and reach, and adds new custom `-mmz` entities for high-performance gameplay.

## Build
- Windows: `package.bat` (requires `tar` in PATH)
- Linux/macOS: `package.sh`

## Installation
Copy the released mod `.zip` into Factorio mods folder:
- Windows: `%APPDATA%\Factorio\mods`
- Linux: `~/.factorio/mods`

## What this mod changes
- Character:
  - max_health: `1000`
  - healing_per_tick: `1`
  - collision_box: zero-size
  - build/reach/resource reach: up to `5000`
  - run speed: `0.6` multiplier (already fast by default) or additional bonuses, mining_speed `10000`, crafting_speed `1000`
  - inventory_size: `500`
  - ticks_to_stay_in_combat: `100`
- Crafting
  - all item stack_sizes >1 are multiplied by `100`
  - recipes unlocked:
    - `loader`, `fast-loader`, `express-loader`
    - `steam-engine`, `electric-mining-drill`, `steel-plate`, `steel-chest`, `steel-furnace`, `iron-stick`, `rail`, `engine-unit`, `locomotive`, `cargo-wagon`, `rail-signal`, `rail-chain-signal`, `train-stop`, `medium-electric-pole`, `big-electric-pole`, `assembling-machine-1`, `assembling-machine-2`, `solar-panel`
- Labs
  - energy usage reduced and researching_speed increased by `10x`
- Mining drills
  - burner-mining-drill: mining_speed `*15`, energy_usage `*15`, pollution removed
  - created new entities: `electric-mining-drill-mmz`, `burner-mining-drill-mmz`, `pumpjack-mmz` (15x mining and energy + recipes)
- Furnaces
  - stone/steel/electric furnaces: new `-mmz` variants with higher crafting speed and energy usage
  - `electric-furnace` recipe changed to require `steel-furnace`, `electronic-circuit`, `copper-plate`
- Assembling machines
  - New `-mmz` variants with increased speed and energy use, plus pollution changes (based on script logic)
- Solar panels / Accumulators
  - new `solar-panel-mmz`, `accumulator-mmz` with higher production/storage and crafted recipes
- Trains
  - locomotive, cargo-wagon, fluid-wagon, artillery-wagon: max_speed and braking_force `*3`
- Weapons
  - `submachine-gun-mmz`: cooldown `/100`, range `*100`

## New/Modified items and entities
- Items:
  - `electric-mining-drill-mmz`, `burner-mining-drill-mmz`, `pumpjack-mmz`
  - `stone-furnace-mmz`, `steel-furnace-mmz`, `electric-furnace-mmz`
  - `solar-panel-mmz`, `accumulator-mmz`
  - `submachine-gun-mmz`
  - plus their recipes and placeable entities (if data extension succeeds)
- Recipes:
  - All base recipes above are set enabled and/or unlocked, plus the `-mmz` variants are enabled automatically by script

## Added in-game commands
Registered with `commands.add_command` in `control.lua`:
- `teleport` — teleport player
- `reviveGhosts` — rebuild ghost entities (requires item supply unless cheat_mode)
- `deconstruct` — clear nearby entities
- `refillEntities` — refill refuelable entities from nearby player/chest inventory
- `depositIntoChests` — move player inventory into nearby chests
- `removeDecoratives` — clear decorative tiles around player
- `waterRing` — place water ring around player
- `protectionRing` — generate defensive ring around player
- `landFill` — fill area with land
- `waterFill` — fill area with water
- `deleteResources` — delete resource entities within area
- `generateResources` — create resource entities within area
- `blackDeath` — kill nearby enemies
- `marcoPolo` — explore map area
- `aegis` — auto-armor / defenses (admin use)
- `enableAllTech` — research all technologies for player force
- `changeDiplomacy` — modify enemy relationships
- `enableAllRecipes` — unlock all recipes for player force
- `equipPlayer` — give power armor+equipment and combat loadout
- `pandorasBox` — give rocket launcher + atomic bombs
- `toggleCheat` — toggle cheat crafting mode

## Notes
- Some operations in the Lua code may be incomplete or are intentionally commented out for example behavior (e.g., mining drills pollution changes, full entity scaling) — but you can still use the commands and revised recipes from this mod.

## Changes 2.0.3
- Fixed equip player command if player already has armor
- Added teleporting to a location by specifying position
- Added new command repairEntities
- Added new command ranrandomizeSpawn.

## Changes 2.0.4
- Fixed bug on Oil refininery recipes reported by [Gerhardl](https://mods.factorio.com/mod/MMZAccelerationMod/discussion/69bd198624c340ede4a929ac)

## Changes 2.0.5
- Fixed regression issue assembling machine-mmz entities and pollution removal.