-- -- Data extention try does not work in soft mods
-- player.force.recipes
-- data:extend(
-- {
--   {
--     type = "recipe",
--     name = "mmz-loader",
--     category = "MasterManiaZ",
--     energy_required = 2,
--     ingredients =
--     {
--       {type = "item", name = "transport-belt", amount = 10},
--       {type = "item", name = "inserter", amount = 2},
--     },
--     results =
--     {
--       {type = "item", name = "loader", amount = 1},
--     },        
--     icon = "base/graphics/icons/loader.png",      
--   },
--   {
--     type = "recipe",
--     name = "mmz-fast-loader",
--     category = "MasterManiaZ",
--     energy_required = 2,
--     ingredients =
--     {
--       {type = "item", name = "fast-transport-belt", amount = 10},
--       {type = "item", name = "fast-inserter", amount = 2},
--     },
--     results =
--     {
--       {type = "item", name = "fast-loader", amount = 1},
--     },        
--     icon = "base/graphics/icons/fast-loader.png",      
--   },
--   {
--     type = "recipe",
--     name = "mmz-express-loader",
--     category = "MasterManiaZ",
--     energy_required = 2,
--     ingredients =
--     {
--       {type = "item", name = "express-transport-belt", amount = 10},
--       {type = "item", name = "express-inserter", amount = 2},
--     },
--     results =
--     {
--       {type = "item", name = "express-loader", amount = 1},
--     },        
--     icon = "base/graphics/icons/express-loader.png",      
--   },
-- })
-- -- Receipes Unlock
-- player.force.recipes["loader"].enabled = true
-- player.force.recipes["fast-loader"].enabled = true
-- player.force.recipes["express-loader"].enabled = true
-- player.force.recipes["railgun"].enabled = true
-- player.force.recipes["railgun-dart"].enabled = true
-- player.force.recipes["loader"].hidden = false
-- player.force.recipes["fast-loader"].hidden = false
-- player.force.recipes["express-loader"].hidden = false
-- player.force.technologies["automation"].researched = true
-- player.force.recipes["assembling-machine-1"].enabled = true
-- player.force.recipes["assembling-machine-2"].enabled = true
-- player.force.recipes["splitter"].enabled = true
-- player.force.recipes["fast-splitter"].enabled = true
-- player.force.recipes["underground-belt"].enabled = true
-- player.force.recipes["fast-transport-belt"].enabled = true
-- player.force.recipes["fast-underground-belt"].enabled = true
-- player.force.recipes["long-handed-inserter"].enabled = true
-- player.force.recipes["fast-inserter"].enabled = true
-- player.force.recipes["steel-plate"].enabled = true
-- player.force.recipes["steel-furnace"].enabled = true
-- player.force.recipes["engine-unit"].enabled = true
-- player.force.recipes["stack-inserter"].enabled = true
-- player.force.recipes["rail"].enabled = true
-- player.force.recipes["rail-chain-signal"].enabled = true
-- player.force.recipes["rail-signal"].enabled = true
-- player.force.recipes["train-stop"].enabled = true
-- player.force.recipes["locomotive"].enabled = true
-- player.force.recipes["cargo-wagon"].enabled = true
-- player.force.recipes["fluid-wagon"].enabled = true
-- player.force.recipes["radar"].enabled = true
-- player.force.recipes["pump"].enabled = true
-- player.force.recipes["storage-tank"].enabled = true
-- player.force.recipes["big-electric-pole"].enabled = true
-- player.force.recipes["medium-electric-pole"].enabled = true
-- -- player.force.recipes["player-port"].enabled=true
-- player.force.recipes["green-wire"].enabled = true
-- player.force.recipes["red-wire"].enabled = true
-- player.force.recipes["oil-refinery"].enabled = true
-- player.force.recipes["pumpjack"].enabled = true
-- player.force.recipes["chemical-plant"].enabled = true
-- player.force.recipes["basic-oil-processing"].enabled = true
-- player.force.recipes["solid-fuel-from-heavy-oil"].enabled = true
-- player.force.recipes["solid-fuel-from-light-oil"].enabled = true
-- player.force.recipes["solid-fuel-from-petroleum-gas"].enabled = true
-- player.force.recipes["advanced-oil-processing"].enabled = true
-- player.force.recipes["light-oil-cracking"].enabled = true
-- player.force.recipes["heavy-oil-cracking"].enabled = true
-- player.force.recipes["plastic-bar"].enabled = true
-- player.force.recipes["advanced-circuit"].enabled = true
-- player.force.recipes["substation"].enabled = true
-- player.force.recipes["electric-furnace"].enabled = true
-- -- player.force.recipes["lubricant"].enabled = true
-- -- player.force.recipes["express-splitter"].enabled = true
-- -- player.force.recipes["express-transport-belt"].enabled = true
-- -- player.force.recipes["express-underground-belt"].enabled = true
-- player.force.recipes["sulfur"].enabled = true
-- player.force.recipes["sulfuric-acid"].enabled = true
-- player.force.recipes["battery"].enabled = true
-- player.force.recipes["laser-turret"].enabled = true
-- player.force.recipes["accumulator"].enabled = true
-- player.force.recipes["solar-panel"].enabled = true
-- player.force.recipes["small-lamp"].enabled = true
-- player.force.enable_all_recipes()
-- player.force.recipes["electric-energy-interface"].enabled = false
-- -- MMZ print section
-- for i = 1, 11 do
--   panel_positions={}
--   panel_positions[0]={player.position.x + 21, player.position.y - 19 + i * 3}
--   panel_positions[1]={player.position.x + 24, player.position.y - 19 + i * 3}
--   panel_positions[2]={player.position.x + 27, player.position.y - 19 + i * 3}
--   panel_positions[3]={player.position.x + 30, player.position.y - 19 + i * 3}
--   panel_positions[4]={player.position.x + 33, player.position.y - 19 + i * 3}
--   panel_positions[5]={player.position.x + 38, player.position.y - 19 + i * 3}
--   panel_positions[6]={player.position.x + 41, player.position.y - 19 + i * 3}
--   panel_positions[7]={player.position.x + 44, player.position.y - 19 + i * 3}
--   panel_positions[8]={player.position.x + 47, player.position.y - 19 + i * 3}
--   panel_positions[9]={player.position.x + 50, player.position.y - 19 + i * 3}
--   panel_positions[10]={player.position.x - 22, player.position.y - 19 + i * 3}
--   panel_positions[11]={player.position.x - 25, player.position.y - 19 + i * 3}
--   panel_positions[12]={player.position.x - 28, player.position.y - 19 + i * 3}
--   panel_positions[13]={player.position.x - 31, player.position.y - 19 + i * 3}
--   panel_positions[14]={player.position.x - 34, player.position.y - 19 + i * 3}
--   panel_positions[15]={player.position.x - 39, player.position.y - 19 + i * 3}
--   panel_positions[16]={player.position.x - 42, player.position.y - 19 + i * 3}
--   panel_positions[17]={player.position.x - 45, player.position.y - 19 + i * 3}
--   panel_positions[18]={player.position.x - 48, player.position.y - 19 + i * 3}
--   panel_positions[19]={player.position.x - 51, player.position.y - 19 + i * 3}
--   panel_positions[20]={player.position.x - 19 + i * 3, player.position.y - 22}
--   panel_positions[21]={player.position.x - 19 + i * 3, player.position.y - 25}
--   panel_positions[22]={player.position.x - 19 + i * 3, player.position.y - 28}
--   panel_positions[23]={player.position.x - 19 + i * 3, player.position.y - 31}
--   panel_positions[24]={player.position.x - 19 + i * 3, player.position.y - 34}
--   panel_positions[25]={player.position.x - 19 + i * 3, player.position.y - 39}
--   panel_positions[26]={player.position.x - 19 + i * 3, player.position.y - 42}
--   panel_positions[27]={player.position.x - 19 + i * 3, player.position.y - 45}
--   panel_positions[28]={player.position.x - 19 + i * 3, player.position.y - 48}
--   panel_positions[29]={player.position.x - 19 + i * 3, player.position.y - 51}
--   panel_positions[30]={player.position.x - 19 + i * 3, player.position.y + 21}
--   panel_positions[31]={player.position.x - 19 + i * 3, player.position.y + 24}
--   panel_positions[32]={player.position.x - 19 + i * 3, player.position.y + 27}
--   panel_positions[33]={player.position.x - 19 + i * 3, player.position.y + 30}
--   panel_positions[34]={player.position.x - 19 + i * 3, player.position.y + 33}
--   panel_positions[35]={player.position.x - 19 + i * 3, player.position.y + 38}
--   panel_positions[36]={player.position.x - 19 + i * 3, player.position.y + 41}
--   panel_positions[37]={player.position.x - 19 + i * 3, player.position.y + 44}
--   panel_positions[38]={player.position.x - 19 + i * 3, player.position.y + 47}
--   panel_positions[39]={player.position.x - 19 + i * 3, player.position.y + 50}
--   for j =0, 39 do
--       init_spanel = player.surface.create_entity({
--           name = "solar-panel",
--           force = player.force,
--           amount = 1,
--           position = panel_positions[j]
--         })
--       init_spanel.minable = false
--       init_spanel.destructible = false
--   end
-- end
-- -- Make player ghost 
-- local character = player.character
-- player.character = nil
-- if character then
--     character.destroy()
-- end
--  -- Admin can revive without has_items_inside
-- if (player.admin == true) then
--   placed_entity = ghostEntities[i].silent_revive()
--   if placed_entity ~=nil then
--       placed_entity.destructible = false
--   end
--   if ((inventoryContents[ghostName] ~= nil) and (inventoryContents[ghostName] > 0)) then
--     if placed_entity ~=nil then
--       inventoryContents[ghostName] = inventoryContents[ghostName] - 1;
--       playerInventory.remove {
--           name = ghostName,
--           count = 1
--       }
--     end
--   end
-- else
entity_types_list = {
    "character-corpse", "player", "furnace", "transport-belt", "fish", "boiler",
    "container", "electric-pole", "generator", "offshore-pump", "inserter",
    "item-entity", "pipe", "radar", "lamp", "arrow", "pipe-to-ground",
    "assembling-machine", "corpse", "entity-ghost", "tile-ghost",
    "deconstructible-tile-proxy", "item-request-proxy", "cliff", "wall",
    "mining-drill", "projectile", "resource", "turret", "ammo-turret", "unit",
    "unit-spawner", "rail-remnants", "simple-entity", "tree", "tile",
    "optimized-decorative", "underground-belt", "loader", "splitter", "car",
    "solar-panel", "locomotive", "cargo-wagon", "fluid-wagon",
    "artillery-wagon", "gate", "player-port", "straight-rail", "curved-rail",
    "land-mine", "train-stop", "rail-signal", "rail-chain-signal", "lab",
    "logistic-robot", "construction-robot", "logistic-container", "rocket-silo",
    "rocket-silo-rocket", "rocket-silo-rocket-shadow", "roboport",
    "storage-tank", "pump", "market", "accumulator", "beacon", "combat-robot",
    "arithmetic-combinator", "decider-combinator", "constant-combinator",
    "power-switch", "programmable-speaker", "electric-energy-interface",
    "reactor", "heat-pipe", "simple-entity-with-force",
    "simple-entity-with-owner", "infinity-container", "artillery-turret",
    "electric-turret", "fluid-turret"
}

-- furnaceEntities = player.surface.find_entities_filtered {
--     type = "furnace",
--     position = player.position,
--     radius = searchRadius
-- }

-- furnace_item_insert_map = {
--     ["coal"] = {name = "coal", count = 50},
--     ["iron-ore"] = {name = "iron-ore", count = 50},
--     ["copper-ore"] = {name = "copper-ore", count = 50},
--     ["stone"] = {name = "stone", count = 50},
--     ["iron-plate"] = {name = "iron-plate", count = 50}
-- }

-- furnace_recipe_to_item_map = {
--     ["iron-plate"] = "iron-ore",
--     ["copper-plate"] = "copper-ore",
--     ["stone-brick"] = "stone",
--     ["steel-plate"] = "iron-plate"
-- }

-- for i = 1, #furnaceEntities do
--     local furnaceName = furnaceEntities[i].name
--     for furnace_recipe, furnace_item in pairs(furnace_recipe_to_item_map) do
--         prepared_item_count_in_furnace =
--             furnaceEntities[i].get_item_count(furnace_recipe)
--         if ((prepared_item_count_in_furnace > 0) and player.can_insert({
--             name = furnace_recipe,
--             count = prepared_item_count_in_furnace
--         })) then
--             item_count_inserted = player.insert({
--                 name = furnace_recipe,
--                 count = prepared_item_count_in_furnace
--             })
--             if item_count_inserted > 0 then
--                 furnaceEntities[i].remove_item({
--                     name = furnace_recipe,
--                     count = item_count_inserted
--                 })
--             end
--         end
--         if furnaceEntities[i].previous_recipe and
--             (furnaceEntities[i].previous_recipe.name == furnace_recipe) and
--             furnaceEntities[i]
--                 .can_insert(furnace_item_insert_map[furnace_item]) then
--             container_with_entity = find_container_with_entity(furnace_item,
--                                                                inventories,
--                                                                50)
--             if container_with_entity ~= nil then
--                 item_count_inserted =
--                     furnaceEntities[i].insert(
--                         furnace_item_insert_map[furnace_item])
--                 if item_count_inserted > 0 then
--                     container_with_entity.remove_item({
--                         name = furnace_item,
--                         count = item_count_inserted
--                     })
--                 end
--             end
--         end
--     end
-- end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function string:contains(sub) return self:find(sub, 1, true) ~= nil end

function string:startswith(start) return self:sub(1, #start) == start end

function string:endswith(ending)
    return ending ~= nil or ending == "" or self:sub(-#ending) == ending
end

function string:replace(old, new)
    local s = self
    local search_start_idx = 1

    while true do
        local start_idx, end_idx = s:find(old, search_start_idx, true)
        if (not start_idx) then break end

        local postfix = s:sub(end_idx + 1)
        s = s:sub(1, (start_idx - 1)) .. new .. postfix

        search_start_idx = -1 * postfix:len()
    end

    return s
end

function string:insert(pos, text)
    return self:sub(1, pos - 1) .. text .. self:sub(pos)
end

function fuelEntitiesCommand(command)
    local player = game.players[command.player_index]
    -- if (command.parameter ~= nil) then searchRadius = command.parameter end
    local searchRadius = 200

    -- Get all inventorys from accessible containers
    inventories = get_accessible_containers(player, searchRadius)

    -- Find all fuelable items and put fuel into them
    refuelable_entity_names = {
        "burner-mining-drill", "stone-furnace", "steel-furnace",
        "burner-inserter", "boiler", "locomotive"
    }
    fuel_insert_map = {
        ["coal"] = {name = "coal", count = 50},
        ["solid-fuel"] = {name = "solid-fuel", count = 50},
        ["rocket-fuel"] = {name = "rocket-fuel", count = 50},
        ["nuclear-fuel"] = {name = "nuclear-fuel", count = 50},
        ["wood"] = {name = "wood", count = 50}
    }

    for ri_index, refuelable_entity_name in pairs(refuelable_entity_names) do
        refuable_entities_found = player.surface.find_entities_filtered {
            name = refuelable_entity_name,
            position = player.position,
            radius = searchRadius
        }
        for re_index, refuable_entity in pairs(refuable_entities_found) do
            for fuel, fuel_item_stack in pairs(fuel_insert_map) do
                if refuable_entity.can_insert(fuel_item_stack) then
                    container_with_item =
                        find_container_with_entity(fuel, inventories, 50)
                    if container_with_item ~= nil then
                        item_count_inserted =
                            refuable_entity.insert(fuel_item_stack)
                        if item_count_inserted > 0 then
                            container_with_item.remove_item({
                                name = fuel,
                                count = item_count_inserted
                            })
                        end
                    end
                end
            end
        end
    end
end

commands.remove_command("fuelEntities")
commands.add_command("fuelEntities",
                     "[Admin Command]: Adds fuel from containers to nearby furnaces.",
                     fuelEntitiesCommand)

function mmzPrintExtra(player, tileToFillWith)
    player.teleport {player.position.x - 61, player.position.y - 61}
    waterFillArea(player, 60, 60, 61, 61)
    landFillArea(player, 60, 60, 61, 61, "dirt-7")
    player.teleport {player.position.x + 61, player.position.y + 61}

    -- Substations
    for i = -3, 3 do
        for j = -3, 3 do
            if i ~= 0 or j ~= 0 then
                initial_epole = player.surface.create_entity({
                    name = "substation",
                    force = player.force,
                    amount = 1,
                    position = {
                        player.position.x + i * 18, player.position.y + j * 18
                    }
                })
                initial_epole.minable = false
                initial_epole.destructible = false
            end
        end
    end

    -- Turrets
    for i = 1, 17 do
        turret_positions = {}
        turret_positions[0] = {
            player.position.x + 54, player.position.y - 18 + i * 2
        }
        turret_positions[1] = {
            player.position.x - 54, player.position.y - 18 + i * 2
        }
        turret_positions[2] = {
            player.position.x - 18 + i * 2, player.position.y + 54
        }
        turret_positions[3] = {
            player.position.x - 18 + i * 2, player.position.y - 54
        }

        for j = 0, 3 do
            initial_turret = player.surface.create_entity({
                name = "laser-turret",
                force = player.force,
                amount = 1,
                position = turret_positions[j]
            })
            initial_turret.minable = false
            initial_turret.destructible = false
            initial_turret.damage_dealt = 10000
            -- initial_turret.get_output_inventory().insert {
            --     name = "firearm-magazine",
            --     count = 200
            -- }
        end
    end

    -- Solar Panels
    for i = -8, 7 do
        for j = -8, 7 do
            panel_positions = {}
            panel_positions[0] = {
                player.position.x - 36 + i * 2, player.position.y + j * 2
            }
            panel_positions[1] = {
                player.position.x + 36 + i * 2, player.position.y + j * 2
            }
            panel_positions[2] = {
                player.position.x + i * 2, player.position.y - 36 + j * 2
            }
            panel_positions[3] = {
                player.position.x + i * 2, player.position.y + 36 + j * 2
            }
            for pos = 0, 3 do
                init_spanel = player.surface.create_entity({
                    name = "solar-panel",
                    force = player.force,
                    amount = 1,
                    position = panel_positions[pos]
                })
                init_spanel.minable = false
                init_spanel.destructible = false
            end
        end
    end

    -- Accumulators
    for sx = -1, 1, 2 do
        for sy = -1, 1, 2 do
            for i = -7, 7 do
                for j = -7, 7 do
                    if i ~= 0 or j ~= 0 then
                        init_accum = player.surface.create_entity({
                            name = "accumulator",
                            force = player.force,
                            amount = 1,
                            position = {
                                player.position.x - sx * 36 + i * 2,
                                player.position.y - sy * 36 + j * 2
                            }
                        })
                        init_accum.minable = false
                        init_accum.destructible = false
                    end
                end
            end
        end
    end

    -- Electric furnaces
    for i = 1, 11 do
        ore_positions = {}
        ore_positions[0] = {
            player.position.x + 56, player.position.y - 19 + i * 3
        }
        ore_positions[1] = {
            player.position.x - 57, player.position.y - 19 + i * 3
        }
        ore_positions[2] = {
            player.position.x - 19 + i * 3, player.position.y - 57
        }
        ore_positions[3] = {
            player.position.x - 19 + i * 3, player.position.y + 56
        }

        for j = 0, 3 do
            electric_furnace = player.surface.create_entity({
                name = "electric-furnace",
                force = player.force,
                amount = 1,
                position = ore_positions[j]
            })
            electric_furnace.minable = false
            electric_furnace.destructible = false
        end
    end

    -- Ore Patches
    for i = 1, 11 do
        ore_positions = {}
        furnace_ores = {}
        furnace_ores[0] = "iron-ore"
        furnace_ores[1] = "copper-ore"
        furnace_ores[2] = "stone"
        furnace_ores[3] = "coal"
        ore_positions[0] = {
            player.position.x + 59, player.position.y - 19 + i * 3
        }
        ore_positions[1] = {
            player.position.x - 60, player.position.y - 19 + i * 3
        }
        ore_positions[2] = {
            player.position.x - 19 + i * 3, player.position.y - 60
        }
        ore_positions[3] = {
            player.position.x - 19 + i * 3, player.position.y + 59
        }

        for j = 0, 3 do
            ore_path = player.surface.create_entity({
                name = furnace_ores[j],
                amount = 100000,
                position = ore_positions[j]
            })
        end
    end

    -- assembling-machine-3  
    for i = 0, 10 do
        init_assm = player.surface.create_entity({
            name = "assembling-machine-3",
            force = player.force,
            amount = 1,
            position = {player.position.x - 16 + i * 3, player.position.y + 10}
        })
        init_assm.minable = false
        init_assm.destructible = false
    end
    printBaseLayout(player, tileToFillWith)
end

-- MMZ print
local tiles = {}
local pos = player.position
pos.x = pos.x - 1
pos.y = pos.y - 4

if (tileToFillWith == nil) then tileToFillWith = "out-of-map" end

for y = pos.y - 4, pos.y + 4 do
    table.insert(tiles, {name = tileToFillWith, position = {pos.x - 14, y}})
    table.insert(tiles, {name = tileToFillWith, position = {pos.x - 6, y}})
    table.insert(tiles, {name = tileToFillWith, position = {pos.x - 4, y}})
    table.insert(tiles, {name = tileToFillWith, position = {pos.x + 4, y}})
end

for i = 0, 4 do
    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x - 14 + i, pos.y - 4 + i}
    })
    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x - 13 + i, pos.y - 4 + i}
    })
    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x - 4 + i, pos.y - 4 + i}
    })
    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x - 3 + i, pos.y - 4 + i}
    })

    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x - 10 + i, pos.y - i}
    })
    table.insert(tiles,
                 {name = tileToFillWith, position = {pos.x - 9 + i, pos.y - i}})
    table.insert(tiles,
                 {name = tileToFillWith, position = {pos.x + i, pos.y - i}})
    table.insert(tiles,
                 {name = tileToFillWith, position = {pos.x + 1 + i, pos.y - i}})
end

for i = 0, 9 do
    table.insert(tiles,
                 {name = tileToFillWith, position = {pos.x + 6 + i, pos.y - 4}})
    -- table.insert(tiles, {name=tileToFillWith, position={pos.x+6+i,pos.y-3}})

    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x + 6 + i, pos.y + 4 - i}
    })
    table.insert(tiles, {
        name = tileToFillWith,
        position = {pos.x + 7 + i, pos.y + 4 - i}
    })

    -- table.insert(tiles, {name=tileToFillWith, position={pos.x+6+i,pos.y+3}})
    table.insert(tiles,
                 {name = tileToFillWith, position = {pos.x + 6 + i, pos.y + 4}})
end

player.surface.set_tiles(tiles)

if not global["shared_inventory"] then
    global["shared_inventory"] = game.create_inventory(10240)
end
