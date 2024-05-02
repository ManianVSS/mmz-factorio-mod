local util = require("util")
local crash_site = require("crash-site")

local created_items = function()
    return {
        ["iron-plate"] = 500,
        ["copper-plate"] = 250,
        ["coal"] = 250,
        ["submachine-gun"] = 1,
        ["firearm-magazine"] = 200,
        ["burner-mining-drill"] = 10,
        ["stone-furnace"] = 1,
        ["small-electric-pole"] = 50
    }
end

local respawn_items = function()
    return {["submachine-gun"] = 1, ["firearm-magazine"] = 200}
end

local ship_items = function() return {["firearm-magazine"] = 8} end

local debris_items = function() return {["iron-plate"] = 8} end

local ship_parts = function() return crash_site.default_ship_parts() end

local chart_starting_area = function()
    local r = global.chart_distance or 200
    local force = game.forces.player
    local surface = game.surfaces[1]
    local origin = force.get_spawn_position(surface)
    force.chart(surface,
                {{origin.x - r, origin.y - r}, {origin.x + r, origin.y + r}})
end

function soft_mod_setup(player)
    if ((global["_map_initialized"] == nil) or
        (global["_map_initialized"] == false)) then -- player.name == "MasterManiaZ") then				
        global["_map_initialized"] = true
        global["_spawn_position"] = player.position
        global["_map_surface"] = player.surface
        global["_aegis_on"] = false
        player.force.research_queue_enabled = true

        player.force.set_ammo_damage_modifier("bullet", 10)
        player.force.set_gun_speed_modifier("bullet", 10)
        player.force.set_turret_attack_modifier("gun-turret", 10)

        player.force.character_inventory_slots_bonus = player.force
                                                           .character_inventory_slots_bonus +
                                                           150
        player.force.character_running_speed_modifier = 3
        -- player.force.manual_mining_speed_modifier = 100
        player.force.character_build_distance_bonus = 5000
        player.force.character_item_drop_distance_bonus = 5000
        player.force.character_reach_distance_bonus = 5000
        player.force.character_resource_reach_distance_bonus = 5000
        -- player.force.character_item_pickup_distance_bonus = 5000
        -- player.force.character_loot_pickup_distance_bonus = 5000
        player.force.character_health_bonus = 400
        -- player.force.manual_crafting_speed_modifier = 100
        player.force.manual_mining_speed_modifier = player.force
                                                        .manual_mining_speed_modifier +
                                                        10000
        player.force.manual_crafting_speed_modifier = player.force
                                                          .manual_crafting_speed_modifier +
                                                          10000
        player.force.inserter_stack_size_bonus = 10
        player.force.stack_inserter_capacity_bonus = 20
        player.force.laboratory_speed_modifier = 10
        -- player.force.laboratory_productivity_bonus  = 10
        -- player.force.mining_drill_productivity_bonus = 10
        player.force.train_braking_force_bonus = 10

        player.force.worker_robots_speed_modifier = 2
        player.force.worker_robots_battery_modifier = 2
        player.force.worker_robots_storage_bonus = 40

        for i = 1, #game.forces do
            game.forces[i].evolution_factor_by_pollution = 0
            game.forces[i].evolution_factor_by_time = 0
            game.forces[i].evolution_factor_by_killing_spawners = 1
            game.forces[i].friendly_fire = false
        end

        if not global["shared_inventory"] then
            global["shared_inventory"] = game.create_inventory(10240)
        end
        mmzPrint(player)
    end
end

local on_player_created = function(event)
    local player = game.get_player(event.player_index)
    util.insert_safe(player, global.created_items)

    if not global.init_ran then
        -- This is so that other mods and scripts have a chance to do remote calls before we do things like charting the starting area, creating the crash site, etc.
        global.init_ran = true
        chart_starting_area()
    end

    if not global.skip_intro then
        if game.is_multiplayer() then
            player.print(global.custom_intro_message or {"msg-intro"})
        else
            game.show_message_dialog {
                text = global.custom_intro_message or {"msg-intro"}
            }
        end
    end

    soft_mod_setup(player)
end

local on_player_respawned = function(event)
    local player = game.get_player(event.player_index)
    util.insert_safe(player, global.respawn_items)
end

local on_cutscene_waypoint_reached = function(event)
    if not global.crash_site_cutscene_active then return end
    if not crash_site.is_crash_site_cutscene(event) then return end

    local player = game.get_player(event.player_index)

    player.exit_cutscene()

    if not global.skip_intro then
        if game.is_multiplayer() then
            player.print(global.custom_intro_message or {"msg-intro"})
        else
            game.show_message_dialog {
                text = global.custom_intro_message or {"msg-intro"}
            }
        end
    end
end

local skip_crash_site_cutscene = function(event)
    if not global.crash_site_cutscene_active then return end
    if event.player_index ~= 1 then return end
    local player = game.get_player(event.player_index)
    if player.controller_type == defines.controllers.cutscene then
        player.exit_cutscene()
    end
end

local on_cutscene_cancelled = function(event)
    if not global.crash_site_cutscene_active then return end
    if event.player_index ~= 1 then return end
    global.crash_site_cutscene_active = nil
    local player = game.get_player(event.player_index)
    if player.gui.screen.skip_cutscene_label then
        player.gui.screen.skip_cutscene_label.destroy()
    end
    if player.character then player.character.destructible = true end
    player.zoom = 1.5
end

local on_player_display_refresh = function(event)
    crash_site.on_player_display_refresh(event)
end

local freeplay_interface = {
    get_created_items = function() return global.created_items end,
    set_created_items = function(map)
        global.created_items = map or
                                   error(
                                       "Remote call parameter to freeplay set created items can't be nil.")
    end,
    get_respawn_items = function() return global.respawn_items end,
    set_respawn_items = function(map)
        global.respawn_items = map or
                                   error(
                                       "Remote call parameter to freeplay set respawn items can't be nil.")
    end,
    set_skip_intro = function(bool) global.skip_intro = bool end,
    get_skip_intro = function() return global.skip_intro end,
    set_custom_intro_message = function(message)
        global.custom_intro_message = message
    end,
    get_custom_intro_message = function() return global.custom_intro_message end,
    set_chart_distance = function(value)
        global.chart_distance = tonumber(value) or
                                    error(
                                        "Remote call parameter to freeplay set chart distance must be a number")
    end,
    get_disable_crashsite = function() return global.disable_crashsite end,
    set_disable_crashsite = function(bool) global.disable_crashsite = bool end,
    get_init_ran = function() return global.init_ran end,
    get_ship_items = function() return global.crashed_ship_items end,
    set_ship_items = function(map)
        global.crashed_ship_items = map or
                                        error(
                                            "Remote call parameter to freeplay set created items can't be nil.")
    end,
    get_debris_items = function() return global.crashed_debris_items end,
    set_debris_items = function(map)
        global.crashed_debris_items = map or
                                          error(
                                              "Remote call parameter to freeplay set respawn items can't be nil.")
    end,
    get_ship_parts = function() return global.crashed_ship_parts end,
    set_ship_parts = function(parts)
        global.crashed_ship_parts = parts or
                                        error(
                                            "Remote call parameter to freeplay set ship parts can't be nil.")
    end
}

if not remote.interfaces["freeplay"] then
    remote.add_interface("freeplay", freeplay_interface)
end

local is_debug = function()
    local surface = game.surfaces.nauvis
    local map_gen_settings = surface.map_gen_settings
    return map_gen_settings.width == 50 and map_gen_settings.height == 50
end

local freeplay = {}

freeplay.events = {
    [defines.events.on_player_created] = on_player_created,
    [defines.events.on_player_respawned] = on_player_respawned,
    [defines.events.on_cutscene_waypoint_reached] = on_cutscene_waypoint_reached,
    ["crash-site-skip-cutscene"] = skip_crash_site_cutscene,
    [defines.events.on_player_display_resolution_changed] = on_player_display_refresh,
    [defines.events.on_player_display_scale_changed] = on_player_display_refresh,
    [defines.events.on_cutscene_cancelled] = on_cutscene_cancelled
}

freeplay.on_configuration_changed = function()
    global.created_items = global.created_items or created_items()
    global.respawn_items = global.respawn_items or respawn_items()
    global.crashed_ship_items = global.crashed_ship_items or ship_items()
    global.crashed_debris_items = global.crashed_debris_items or debris_items()
    global.crashed_ship_parts = global.crashed_ship_parts or ship_parts()

    if not global.init_ran then
        -- migrating old saves.
        global.init_ran = #game.players > 0
    end
end

freeplay.on_init = function()
    global.created_items = created_items()
    global.respawn_items = respawn_items()
    global.crashed_ship_items = ship_items()
    global.crashed_debris_items = debris_items()
    global.crashed_ship_parts = ship_parts()
    add_Commands()
    if is_debug() then
        global.skip_intro = true
        global.disable_crashsite = true
    end
end

freeplay.on_load = function() add_Commands() end

-- Need to optimize the function instead of too much copy paste
function equipPlayer(player)
    player.insert {name = "power-armor-mk2", count = 1}
    local p_armor = player.get_inventory(5)[1].grid
    for i = 1, 4 do p_armor.put({name = "fusion-reactor-equipment"}) end
    for i = 1, 6 do p_armor.put({name = "personal-laser-defense-equipment"}) end
    p_armor.put({name = "night-vision-equipment"})
    for i = 1, 6 do p_armor.put({name = "battery-mk2-equipmen"}) end

    player.insert {name = "submachine-gun", count = 1}
    player.insert {name = "uranium-rounds-magazine", count = 1000}
    -- player.insert {
    --     name = "rocket-launcher",
    --     count = 1
    -- }
    -- player.insert {
    --     name = "atomic-bomb",
    --     count = 5
    -- }
    -- player.insert {
    --   name = "loader",
    --   count = 50
    -- }
    -- player.insert {
    --   name = "fast-loader",
    --   count = 50
    -- }
    -- player.insert {
    --   name = "express-loader",
    --   count = 50
    -- }
end

function pandorasBox(player)
    player.insert {name = "rocket-launcher", count = 1}

    player.insert {name = "atomic-bomb", count = 5}
end

function linePlot(tiles, x1, y1, x2, y2, tileToFillWith)
    ix = (x2 - x1) / abs(x2 - x1)
    iy = (y2 - y1) / abs(y2 - y1)

    for y = x, pos.y + sizeY do
        table.insert(tiles, {name = tileToFillWith, position = {x, y}})
    end
end

function mmzPrint(player, tileToFillWith)
    -- player.teleport {player.position.x - 15, player.position.y - 15}
    -- waterFillArea(player, 14, 14, 15, 15)
    -- landFillArea(player, 14, 14, 15, 15, "dirt-7")
    -- player.teleport {player.position.x + 15, player.position.y + 15}

    local tiles = {}
    local pos = player.position

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
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x - 9 + i, pos.y - i}
        })
        table.insert(tiles,
                     {name = tileToFillWith, position = {pos.x + i, pos.y - i}})
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x + 1 + i, pos.y - i}
        })
    end

    for i = 0, 9 do
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x + 6 + i, pos.y - 4}
        })
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
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x + 6 + i, pos.y + 4}
        })
    end

    player.surface.set_tiles(tiles)

    -- Spawn spin belt
    cur_dir_index = 1
    dirs = {
        defines.direction.east, defines.direction.north,
        defines.direction.south, defines.direction.west
    }
    for i = -1, 0 do
        for j = -1, 0 do
            init_belt = player.surface.create_entity({
                name = "express-transport-belt",
                force = player.force,
                amount = 1,
                position = {player.position.x + i, player.position.y + j},
                direction = dirs[cur_dir_index]
            })
            cur_dir_index = cur_dir_index + 1
            if init_belt ~= nil then
                -- init_belt.direction=dirs[cur_dir_index]
                init_belt.minable = false
                init_belt.rotatable = false
                init_belt.destructible = false
            end
        end
    end
end

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

    -- steel chests
    for i = 0, 15 do
        initial_chest = player.surface.create_entity({
            name = "steel-chest",
            force = player.force,
            amount = 1,
            position = {player.position.x - 15 + i * 2, player.position.y + 4}
        })
        initial_chest.minable = false
        initial_chest.destructible = false
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
    mmzPrint(player, tileToFillWith)
end

function mmzPrintCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        -- for i=1,100 do
        mmzPrintExtra(player, "out-of-map")
        -- end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function tileRing(player, size, thichness, tileToFillWith)
    -- waterFillArea(player,size,thichness,0,-size/2)
    -- waterFillArea(player,thichness,size,-size/2,0)
    -- waterFillArea(player,thichness,size,size/2,0)
    -- waterFillArea(player,size,thichness,0,size/2)

    if (tileToFillWith == nil) then tileToFillWith = "water" end

    local tiles = {}
    local pos = player.position
    for x = pos.x - size / 2, pos.x + size / 2 do
        for y = pos.y - size / 2 - thichness, pos.y - size / 2 do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x + size / 2, pos.x + size / 2 + thichness do
        for y = pos.y - size / 2, pos.y + size / 2 do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x - size / 2, pos.x + size / 2 do
        for y = pos.y + size / 2, pos.y + size / 2 + thichness do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x - size / 2 - thichness, pos.x - size / 2 do
        for y = pos.y - size / 2, pos.y + size / 2 do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    player.surface.set_tiles(tiles)
end

function landFillArea(player, sizeX, sizeY, offsetX, offsetY, tileToFillWith)
    local tiles = {}
    local pos = player.position

    if (sizeX == nil) then sizeX = 200 end
    if (sizeY == nil) then sizeY = 200 end

    if (offsetX == nil) then offsetX = 0 end
    if (offsetY == nil) then offsetY = 0 end

    if (tileToFillWith == nil) then tileToFillWith = "grass-1" end

    pos.x = pos.x + offsetX
    pos.y = pos.y + offsetY

    for x = pos.x - sizeX, pos.x + sizeX do
        for y = pos.y - sizeY, pos.y + sizeY do
            local t = player.surface.get_tile(x, y)
            -- if t.name == "water" or t.name == "deepwater" then
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
            -- end
        end
    end
    player.surface.set_tiles(tiles)
end

function waterFillArea(player, sizeX, sizeY, offsetX, offsetY)
    local tiles = {}
    local pos = player.position

    if (sizeX == nil) then sizeX = 200 end
    if (sizeY == nil) then sizeY = 200 end

    if (offsetX == nil) then offsetX = 0 end
    if (offsetY == nil) then offsetY = 0 end

    pos.x = pos.x + offsetX
    pos.y = pos.y + offsetY

    for x = pos.x - sizeX, pos.x + sizeX do
        for y = pos.y - sizeY, pos.y + sizeY do
            if (x ~= pos.x) or (y ~= pos.y) then
                local t = player.surface.get_tile(x, y)
                table.insert(tiles, {name = "water", position = {x, y}})
            end
        end
    end
    player.surface.set_tiles(tiles)
end

function removeDecoratives(command)
    local player = game.players[command.player_index]
    if (player.admin == true) then
        player.surface.destroy_decoratives {}
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function get_accessible_containers(player, radius)
    nearby_entities = player.surface.find_entities_filtered {
        type = "container",
        position = player.position,
        radius = radius
    }
    inventories = {player}
    for i = 1, #nearby_entities do
        if (nearby_entities[i].name == "wooden-chest") or
            (nearby_entities[i].name == "iron-chest") or
            (nearby_entities[i].name == "steel-chest") then
            if player.can_reach_entity(nearby_entities[i]) and
                nearby_entities[i].has_items_inside() then
                table.insert(inventories, nearby_entities[i])
            end
        end
    end
    return inventories
end

function find_container_with_entity(entity_name, inventories, count)
    count = count or 1
    for i = 1, #inventories do
        if inventories[i].get_item_count(entity_name) > 0 then
            return inventories[i]
        end
    end
    return nil
end

function reviveCommand(command)
    local player = game.players[command.player_index]

    deconstructCommand(command)
    local constructRadius = 200

    -- if (command.parameter ~= nil) then constructRadius = command.parameter end

    furnaceEntities = player.surface.find_entities_filtered {
        type = "entity-ghost",
        position = player.position,
        radius = constructRadius
    }
    inventories = get_accessible_containers(player, constructRadius)

    for i = 1, #furnaceEntities do
        local ghostName = furnaceEntities[i].ghost_name

        if ((ghostName == "straight-rail") or (ghostName == "curved-rail")) then
            ghostName = "rail"
        end

        container_with_entity = find_container_with_entity(ghostName,
                                                           inventories)
        if container_with_entity ~= nil then
            placed_entity_status = furnaceEntities[i].silent_revive()
            if placed_entity_status then
                container_with_entity.remove_item({name = ghostName})
            end
        end
    end
end

function deconstructCommand(command)
    local player = game.players[command.player_index]
    local deconstructRadius = 200

    -- if (command.parameter ~= nil) then deconstructRadius = command.parameter end

    entitiesNearBy = player.surface.find_entities_filtered {
        position = player.position,
        radius = deconstructRadius
    }
    playerInventory = player.get_main_inventory()

    for i = 1, #entitiesNearBy do
        if (entitiesNearBy[i].to_be_deconstructed(player.force)) then
            -- if not (playerInventory.can_insert{name=entitiesNearBy[i].name, count=1}) then break end					
            -- entitiesNearBy[i].destroy()				
            -- util.insert_safe(player, {name=entitiesNearBy[i].name, count=1})				
            player.mine_entity(entitiesNearBy[i], false)
        end
    end
end

function refillEntitiesCommand(command)
    local player = game.players[command.player_index]
    -- if (command.parameter ~= nil) then searchRadius = command.parameter end
    local searchRadius = 200

    -- Get all inventorys from accessible containers
    inventories = get_accessible_containers(player, searchRadius)

    -- List of recipe names that can be a furnace recipe
    furnace_item_to_recipe_map = {
        ["iron-ore"] = "iron-plate",
        ["copper-ore"] = "copper-plate",
        ["stone"] = "stone-brick",
        ["iron-plate"] = "steel-plate"
    }

    -- Map of refillable entities to list of refillable items
    refillable_entity_to_items_map = {
        ["burner-mining-drill"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 50},
            ["wood"] = {type = "fuel", name = "wood", count = 100}
        },
        ["burner-inserter"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 5},
            ["wood"] = {type = "fuel", name = "wood", count = 10}
        },
        ["stone-furnace"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 50},
            ["wood"] = {type = "fuel", name = "wood", count = 100},
            ["iron-ore"] = {
                type = "furnace-ingredient",
                name = "iron-ore",
                count = 50
            },
            ["copper-ore"] = {
                type = "furnace-ingredient",
                name = "copper-ore",
                count = 50
            },
            ["stone"] = {
                type = "furnace-ingredient",
                name = "stone",
                count = 50
            },
            ["iron-plate"] = {
                type = "furnace-ingredient",
                name = "iron-plate",
                count = 100
            }
        },
        ["steel-furnace"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 50},
            ["solid-fuel"] = {type = "fuel", name = "solid-fuel", count = 50},
            ["iron-ore"] = {
                type = "furnace-ingredient",
                name = "iron-ore",
                count = 100
            },
            ["copper-ore"] = {
                type = "furnace-ingredient",
                name = "copper-ore",
                count = 100
            },
            ["stone"] = {
                type = "furnace-ingredient",
                name = "stone",
                count = 100
            },
            ["iron-plate"] = {
                type = "furnace-ingredient",
                name = "iron-plate",
                count = 100
            }
        },
        ["electric-furnace"] = {
            ["iron-ore"] = {
                type = "furnace-ingredient",
                name = "iron-ore",
                count = 100
            },
            ["copper-ore"] = {
                type = "furnace-ingredient",
                name = "copper-ore",
                count = 100
            },
            ["stone"] = {
                type = "furnace-ingredient",
                name = "stone",
                count = 100
            },
            ["iron-plate"] = {
                type = "furnace-ingredient",
                name = "iron-plate",
                count = 100
            }
        },
        ["boiler"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 50},
            ["wood"] = {type = "fuel", name = "wood", count = 100}
        },
        ["locomotive"] = {
            ["coal"] = {type = "fuel", name = "coal", count = 150},
            ["solid-fuel"] = {type = "fuel", name = "solid-fuel", count = 150},
            ["rocket-fuel"] = {type = "fuel", name = "rocket-fuel", count = 50},
            ["nuclear-fuel"] = {
                type = "fuel",
                name = "nuclear-fuel",
                count = 10
            }
        },
        ["assembling-machine-1"] = {
            ["coal"] = {type = "ingredient", name = "coal", count = 100},
            ["wood"] = {type = "ingredient", name = "wood", count = 100},
            ["iron-plate"] = {
                type = "ingredient",
                name = "iron-plate",
                count = 100
            },
            ["copper-plate"] = {
                type = "ingredient",
                name = "copper-plate",
                count = 100
            },
            ["stone"] = {type = "ingredient", name = "stone", count = 100},
            ["steel-plate"] = {
                type = "ingredient",
                name = "steel-plate",
                count = 100
            }
        },
        ["assembling-machine-2"] = {
            ["coal"] = {type = "ingredient", name = "coal", count = 100},
            ["wood"] = {type = "ingredient", name = "wood", count = 100},
            ["iron-plate"] = {
                type = "ingredient",
                name = "iron-plate",
                count = 100
            },
            ["copper-plate"] = {
                type = "ingredient",
                name = "copper-plate",
                count = 100
            },
            ["stone"] = {type = "ingredient", name = "stone", count = 100},
            ["steel-plate"] = {
                type = "ingredient",
                name = "steel-plate",
                count = 100
            }
        },
        ["assembling-machine-3"] = {
            ["coal"] = {type = "ingredient", name = "coal", count = 100},
            ["wood"] = {type = "ingredient", name = "wood", count = 100},
            ["iron-plate"] = {
                type = "ingredient",
                name = "iron-plate",
                count = 100
            },
            ["copper-plate"] = {
                type = "ingredient",
                name = "copper-plate",
                count = 100
            },
            ["stone"] = {type = "ingredient", name = "stone", count = 100},
            ["steel-plate"] = {
                type = "ingredient",
                name = "steel-plate",
                count = 100
            }
        },
        ["lab"] = {
            ["automation-science-pack"] = {
                type = "fuel",
                name = "automation-science-pack",
                count = 25
            },
            ["logistic-science-pack"] = {
                type = "fuel",
                name = "logistic-science-pack",
                count = 25
            },
            ["military-science-pack"] = {
                type = "fuel",
                name = "military-science-pack",
                count = 25
            },
            ["chemical-science-pack"] = {
                type = "fuel",
                name = "chemical-science-pack",
                count = 25
            },
            ["production-science-pack"] = {
                type = "fuel",
                name = "production-science-pack",
                count = 25
            },
            ["utility-science-pack"] = {
                type = "fuel",
                name = "utility-science-pack",
                count = 25
            },
            ["space-science-pack"] = {
                type = "fuel",
                name = "space-science-pack",
                count = 25
            }
        },
        ["gun-turret"] = {
            ["firearm-magazine"] = {name = "firearm-magazine", count = 200},
            ["piercing-rounds-magazine"] = {
                type = "fuel",
                name = "piercing-rounds-magazine",
                count = 200
            },
            ["uranium-rounds-magazine"] = {
                type = "fuel",
                name = "uranium-rounds-magazine",
                count = 200
            }
        }
    }

    -- Find all refillable items and put fuel into them
    for refillable_entity_name, refillable_item_map in pairs(
                                                           refillable_entity_to_items_map) do
        refillable_entities_found = player.surface.find_entities_filtered {
            name = refillable_entity_name,
            position = player.position,
            radius = searchRadius
        }

        for re_i, refillable_entity in pairs(refillable_entities_found) do
            -- TODO: Need to use different logic for furnace ores
            for refillable_item_name, refillable_item_stack_data in pairs(
                                                                        refillable_item_map) do
                item_type = refillable_item_stack_data["type"]
                refillable_item_stack = {
                    name = refillable_item_stack_data["name"],
                    count = refillable_item_stack_data["count"]
                }

                if item_type == "furnace-ingredient" then
                    recipe_name =
                        furnace_item_to_recipe_map[refillable_item_name]
                    prepared_item_count_in_furnace =
                        refillable_entity.get_item_count(recipe_name)
                    if ((prepared_item_count_in_furnace > 0) and
                        player.can_insert(
                            {
                                name = recipe_name,
                                count = prepared_item_count_in_furnace
                            })) then
                        -- log("Going to insert finished products to player " ..
                        --         recipe_name .. " with count " ..
                        --         prepared_item_count_in_furnace)
                        item_count_inserted = player.insert({
                            name = recipe_name,
                            count = prepared_item_count_in_furnace
                        })
                        if item_count_inserted > 0 then
                            refillable_entity.remove_item({
                                name = recipe_name,
                                count = item_count_inserted
                            })
                        end
                    end
                    if refillable_entity.previous_recipe and
                        (refillable_entity.previous_recipe.name == recipe_name) and
                        refillable_entity.can_insert(refillable_item_stack) then
                        container_with_item =
                            find_container_with_entity(refillable_item_name,
                                                       inventories,
                                                       refillable_item_stack_data["count"])
                        if container_with_item ~= nil then
                            -- log(
                            --     "Going to insert furnace ingredients to furnace " ..
                            --         refillable_entity.name .. " with item " ..
                            --         refillable_item_name)
                            item_count_inserted =
                                refillable_entity.insert(refillable_item_stack)
                            if item_count_inserted > 0 then
                                container_with_item.remove_item({
                                    name = refillable_item_name,
                                    count = item_count_inserted
                                })
                            end
                        end
                    end
                else -- if (item_type == "fuel") or (item_type == "ingredient") then
                    if refillable_entity.can_insert(refillable_item_stack) then
                        container_with_item =
                            find_container_with_entity(refillable_item_name,
                                                       inventories,
                                                       refillable_item_stack_data["count"])
                        if container_with_item ~= nil then
                            -- log("Going to insert ingredients to entity " ..
                            --         refillable_entity.name .. " with item " ..
                            --         refillable_item_name)
                            item_count_inserted =
                                refillable_entity.insert(refillable_item_stack)
                            if item_count_inserted > 0 then
                                container_with_item.remove_item({
                                    name = refillable_item_name,
                                    count = item_count_inserted
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end

function teleportCommand(command)
    local player = game.players[command.player_index]

    if (command.parameter == nil) then
        player.teleport(global["_spawn_position"])
        game.print(player.name .. " has teleported to the their main spawn area")
    else -- (command.parameter ~= nil) then	
        proximityTags = player.force.find_chart_tags(player.surface, {
            left_top = {-1000000, -1000000},
            right_bottom = {1000000, 1000000}
        })
        for i, proximityTag in ipairs(proximityTags) do
            if (proximityTag.text == command.parameter) then
                local t = player.surface.get_tile(proximityTag.position.x,
                                                  proximityTag.position.y)
                if t.name ~= "water" and t.name ~= "deepwater" then
                    player.teleport {
                        proximityTag.position.x, proximityTag.position.y
                    }
                    game.print(player.name ..
                                   " has teleported to the the custom tag " ..
                                   command.parameter)
                    return
                end
            end
        end
    end
end

function waterRingCommand(command)

    local player = game.players[command.player_index]
    if (player.admin == true) then
        size = command.parameter

        if (command.parameter == nil) then size = 550 end

        tileRing(player, size, 3)
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function protectionRingCommand(command)

    local player = game.players[command.player_index]
    if (player.admin == true) then
        size = command.parameter

        if (command.parameter == nil) then size = 550 end

        tileRing(player, size, 1, "out-of-map")
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function getPlayerByName(playerName)
    local paramPlayer

    for i = 1, #game.players do
        if (playerName == game.players[i].name) then
            paramPlayer = game.players[i]
            return paramPlayer
        end
    end

    return nil
end

function generateResources(paramPlayer, density, size)
    local surface = paramPlayer.surface
    local ore = nil
    local patchOffset = 5
    local oilPatchSide = size / 6

    if (density == nil) then density = 10000 end

    if (size == nil) then size = 140 end

    local randomX = paramPlayer.position.x + size + 10
    local randomY = paramPlayer.position.y + size + 10

    -- waterFillArea(paramPlayer, 2 * size + 16, 2 * size + 16, size + 10, size + 10)
    landFillArea(paramPlayer, size + 8, size + 8, size + 10, size + 10)

    for y = -size, size do
        for x = -patchOffset - size, -patchOffset - size / 2 do
            if surface.get_tile(randomX + x, randomY + y).collides_with(
                "ground-tile") then
                surface.create_entity({
                    name = "coal",
                    amount = 2 * density,
                    position = {randomX + x, randomY + y}
                })
            end
        end
    end

    for y = -size, size do
        for x = -size / 2, 3 * size / 2 do
            if surface.get_tile(randomX + x, randomY + y).collides_with(
                "ground-tile") then
                surface.create_entity({
                    name = "iron-ore",
                    amount = 3 * density,
                    position = {randomX + x, randomY + y}
                })
            end
        end
    end

    for y = -size, size do
        for x = 3 * size / 2 + patchOffset, 5 * size / 2 + patchOffset do
            if surface.get_tile(randomX + x, randomY + y).collides_with(
                "ground-tile") then
                surface.create_entity({
                    name = "copper-ore",
                    amount = 2 * density,
                    position = {randomX + x, randomY + y}
                })
            end
        end
    end

    for y = -size, size do
        for x = 5 * size / 2 + 2 * patchOffset, 3 * size + 2 * patchOffset do
            if surface.get_tile(randomX + x, randomY + y).collides_with(
                "ground-tile") then
                surface.create_entity({
                    name = "stone",
                    amount = density,
                    position = {randomX + x, randomY + y}
                })
            end
        end
    end

    for y = 0, oilPatchSide do
        for x = 0, oilPatchSide do
            surface.create_entity({
                name = "crude-oil",
                amount = 500 * density,
                position = {
                    randomX + size + 10 + 1 + x * 7,
                    randomY + size + 10 + 1 + y * 7
                }
            })
        end
    end

    waterFillArea(paramPlayer, size / 2, size / 2, -size / 2 - 10,
                  -size / 2 - 10)
end

function landFillCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        if (event.parameter == nil) then
            landFillArea(player)
        else
            size = tonumber(event.parameter)
            landFillArea(player, size, size, 0, 0)
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function waterFillCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        -- waterFillArea(player, 100, 100, 55, 55)
        if (event.parameter == nil) then
            waterFillArea(player)
        else
            size = tonumber(event.parameter)
            waterFillArea(player, size, size, 0, 0)
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function generateResourcesCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then generateResources(player, 3000, 80) end
end

function aegisCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then

        local miningSpeedIncrease = 10000
        local craftingSpeedIncrease = 10000
        -- local inserterCapacityIncrease = 10
        -- local laboratoryBonus=10
        -- local miningDrillBonus=100
        -- local trainBrakingBonus=100

        if (global["_aegis_on"]) then
            global["_aegis_on"] = false
            player.force.manual_mining_speed_modifier = player.force
                                                            .manual_mining_speed_modifier -
                                                            miningSpeedIncrease
            player.force.manual_crafting_speed_modifier = player.force
                                                              .manual_crafting_speed_modifier -
                                                              craftingSpeedIncrease
            -- player.force.inserter_stack_size_bonus = player.force.inserter_stack_size_bonus - inserterCapacityIncrease
            -- player.force.stack_inserter_capacity_bonus = player.force.stack_inserter_capacity_bonus - inserterCapacityIncrease
            -- player.force.laboratory_speed_modifier = player.force.laboratory_speed_modifier - laboratoryBonus
            -- player.force.laboratory_productivity_bonus = player.force.laboratory_productivity_bonus - laboratoryBonus
            -- player.force.mining_drill_productivity_bonus = player.force.mining_drill_productivity_bonus - miningDrillBonus
            -- player.force.train_braking_force_bonus = player.force.train_braking_force_bonus - trainBrakingBonus
        else
            global["_aegis_on"] = true
            player.force.manual_mining_speed_modifier = player.force
                                                            .manual_mining_speed_modifier +
                                                            miningSpeedIncrease
            player.force.manual_crafting_speed_modifier = player.force
                                                              .manual_crafting_speed_modifier +
                                                              craftingSpeedIncrease
            -- player.force.inserter_stack_size_bonus = player.force.inserter_stack_size_bonus + inserterCapacityIncrease
            -- player.force.stack_inserter_capacity_bonus = player.force.stack_inserter_capacity_bonus + inserterCapacityIncrease
            -- player.force.laboratory_speed_modifier = player.force.laboratory_speed_modifier + laboratoryBonus
            -- player.force.laboratory_productivity_bonus = player.force.laboratory_productivity_bonus + laboratoryBonus
            -- player.force.mining_drill_productivity_bonus = player.force.mining_drill_productivity_bonus + miningDrillBonus
            -- player.force.train_braking_force_bonus = player.force.train_braking_force_bonus + trainBrakingBonus
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function enableAllTechCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        -- for i=1,100 do
        player.force.research_all_technologies(true)
        -- end		
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function changeDiplomacyCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        for i = 1, #game.forces do
            if game.forces[i] ~= player.force then
                diplomacy = game.forces[i].get_friend(player.force)
                game.forces[i].set_friend(player.force, not diplomacy)
                player.force.set_friend(game.forces[i], not diplomacy)
            end
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function blackDeathCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        local surface = player.surface
        for key, entity in pairs(surface.find_entities_filtered({
            force = "enemy"
        })) do entity.destroy() end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function marcoPoloCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        local chartSize = 300

        if (event.parameter ~= nil) then

            local paramPlayer = getPlayerByName(event.parameter)

            if (paramPlayer ~= null) then
                player = paramPlayer
            else
                chartSize = event.parameter
            end
        end

        player.force.chart(player.surface, {
            {player.position.x - chartSize, player.position.y - chartSize},
            {player.position.x + chartSize, player.position.y + chartSize}
        })
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function equipPlayerCommand(command)
    local player = game.players[command.player_index]
    if (player.admin == true) then
        local paramPlayer = getPlayerByName(command.parameter)

        if (command.parameter == nil) then
            player.print("Player name not passed")
        elseif paramPlayer == nil then
            player.print("Player " .. command.parameter .. " was not found ")
        else
            equipPlayer(paramPlayer)
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function pandorasBoxCommand(command)
    local player = game.players[command.player_index]
    if (player.admin == true) then
        local paramPlayer = getPlayerByName(command.parameter)

        if (command.parameter == nil) then
            player.print("Player name not passed")
        elseif paramPlayer == nil then
            player.print("Player " .. command.parameter .. " was not found ")
        else
            pandorasBox(paramPlayer)
        end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function toggleCheatCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        player.cheat_mode = not player.cheat_mode
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function enableAllRecipesCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        -- if (global["_all_recipes_on"] == nil) or (global["_all_recipes_on"]==false) then
        player.force.enable_all_recipes()
        player.force.recipes["electric-energy-interface"].enabled = false
        --   global["_all_recipes_on"]=rue
        -- else
        --   player.reset_recipes()
        -- end
    else
        player.print(
            "You don't have administrative access required for this command")
    end
end

function add_Commands()

    commands.remove_command("teleport")
    commands.add_command("teleport",
                         "Use /teleport to teleport to main base or /teleport <SurfaceName> to teleport to a surface or /teleport <CustomTagText> to go to a custom tag location",
                         teleportCommand)
    commands.remove_command("reviveGhosts")
    commands.add_command("reviveGhosts",
                         "[Command]: Revives ghosts in the area near player using items from player inventory and available chests.",
                         reviveCommand)
    commands.remove_command("deconstruct")
    commands.add_command("deconstruct",
                         "[Command]: Destroys items marked for deconstruction and adds to player inventory. ",
                         deconstructCommand)
    commands.remove_command("refillEntities")
    commands.add_command("refillEntities",
                         "[Admin Command]: Refills entity from containers to nearby furnaces, burners, labs and other refillable entities.",
                         refillEntitiesCommand)
    commands.remove_command("removeDecoratives")
    commands.add_command("removeDecoratives",
                         "[Command]: destroys all decoratives from the surface. ",
                         removeDecoratives)
    commands.remove_command("waterRing")
    commands.add_command("waterRing",
                         "[Admin Command]:Creates a moot of specified size.",
                         waterRingCommand)
    commands.remove_command("protectionRing")
    commands.add_command("protectionRing",
                         "[Admin Command]:Creates a out of map protection ring of specified size.",
                         protectionRingCommand)
    commands.remove_command("landFill")
    commands.add_command("landFill", "[Admin Command]: Land fills an area.",
                         landFillCommand)
    commands.remove_command("waterFill")
    commands.add_command("waterFill", "[Admin Command]: Water fills an area.",
                         waterFillCommand)
    commands.remove_command("generateResources")
    commands.add_command("generateResources",
                         "[Admin Command]: Generates resources in an area.",
                         generateResourcesCommand)
    -- commands.remove_command("blackDeath")
    -- commands.add_command("blackDeath", "[Admin Command]: Kills all enemy entity on explored area.", blackDeathCommand)
    commands.remove_command("marcoPolo")
    commands.add_command("marcoPolo", "[Admin Command]: Explores a large area.",
                         marcoPoloCommand)
    commands.remove_command("aegis")
    commands.add_command("aegis", "[Admin Command]: Speeds up everything.",
                         aegisCommand)
    -- commands.remove_command("enableAllTech")
    -- commands.add_command("enableAllTech", "[Admin Command]: Unlocks all technologies.", enableAllTechCommand)
    commands.remove_command("changeDiplomacy")
    commands.add_command("changeDiplomacy",
                         "[Admin Command]: Toggles diplomatic stance with enemy.",
                         changeDiplomacyCommand)
    -- commands.remove_command("enableAllRecipes")
    -- commands.add_command("enableAllRecipes", "[Admin Command]: Emables all recipes.", enableAllRecipesCommand)
    -- m
    commands.remove_command("mmzPrint")
    commands.add_command("mmzPrint",
                         "[Admin Command]: Prints the MMZ spawn base.",
                         mmzPrintCommand)
end

return freeplay
