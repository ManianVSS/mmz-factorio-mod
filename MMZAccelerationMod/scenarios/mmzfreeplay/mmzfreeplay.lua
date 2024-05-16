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

        player.force.set_ammo_damage_modifier("bullet", 1)
        player.force.set_gun_speed_modifier("bullet", 1)
        -- player.force.set_turret_attack_modifier("gun-turret", 10)

        player.force.character_inventory_slots_bonus = player.force
                                                           .character_inventory_slots_bonus +
                                                           150
        player.force.character_running_speed_modifier = 1.5
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
        player.force.laboratory_speed_modifier = 1
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

        printBaseLayout(player)
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

if not remote.interfaces["mmzfreeplay"] then
    remote.add_interface("mmzfreeplay", freeplay_interface)
end

local is_debug = function()
    local surface = game.surfaces.nauvis
    local map_gen_settings = surface.map_gen_settings
    return map_gen_settings.width == 50 and map_gen_settings.height == 50
end

local mmzfreeplay = {}

mmzfreeplay.events = {
    [defines.events.on_player_created] = on_player_created,
    [defines.events.on_player_respawned] = on_player_respawned,
    [defines.events.on_cutscene_waypoint_reached] = on_cutscene_waypoint_reached,
    ["crash-site-skip-cutscene"] = skip_crash_site_cutscene,
    [defines.events.on_player_display_resolution_changed] = on_player_display_refresh,
    [defines.events.on_player_display_scale_changed] = on_player_display_refresh,
    [defines.events.on_cutscene_cancelled] = on_cutscene_cancelled
}

mmzfreeplay.on_configuration_changed = function()
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

mmzfreeplay.on_init = function()
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

mmzfreeplay.on_load = function() add_Commands() end

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

function createInitialChest(player, xpos, ypos)
    initial_chest = player.surface.create_entity({
        name = "steel-chest",
        force = player.force,
        amount = 1,
        position = {xpos, ypos}
    })
    initial_chest.minable = false
    initial_chest.destructible = false
    return initial_chest
end

function printBaseLayout(player, tileToFillWith)
    -- player.teleport {player.position.x - 15, player.position.y - 15}
    -- waterFillArea(player, 14, 14, 15, 15)
    -- landFillArea(player, 14, 14, 15, 15, "dirt-7")
    -- player.teleport {player.position.x + 15, player.position.y + 15}

    landFillArea(player, 8, 8, 0, 0, "dirt-7")

    -- Intial steel chests
    initial_chests = {}
    global["initial_chests"] = initial_chests
    count = 1
    for i = 0, 4 do
        for j = 0, 4 do
            table.insert(initial_chests, createInitialChest(player,
                                                            player.position.x -
                                                                i - 3,
                                                            player.position.y -
                                                                j - 3))
            table.insert(initial_chests, createInitialChest(player,
                                                            player.position.x -
                                                                i - 3,
                                                            player.position.y +
                                                                j + 2))
            table.insert(initial_chests, createInitialChest(player,
                                                            player.position.x +
                                                                i + 2,
                                                            player.position.y -
                                                                j - 3))
            table.insert(initial_chests, createInitialChest(player,
                                                            player.position.x +
                                                                i + 2,
                                                            player.position.y +
                                                                j + 2))
        end
    end

    -- Spawn spin belt
    cur_dir_index = 1
    dirs = {
        defines.direction.east, defines.direction.north,
        defines.direction.south, defines.direction.west
    }
    for i = -1, 0 do
        for j = -1, 0 do
            init_belt = player.surface.create_entity({
                name = "transport-belt",
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
    inventories = {player, table.unpack(global["initial_chests"])}
    for i = 1, #nearby_entities do
        if (nearby_entities[i].name == "wooden-chest") or
            (nearby_entities[i].name == "iron-chest") or
            (nearby_entities[i].name == "steel-chest") or
            (nearby_entities[i].name == "infinity-chest") then
            if player.can_reach_entity(nearby_entities[i]) and
                nearby_entities[i].has_items_inside() then
                table.insert(inventories, nearby_entities[i])
            end
        end
    end
    return inventories
end

function find_container_with_entity(entity_name, inventories, count)
    if (count == nil) or (count <= 0) then count = 1 end

    for i = 1, #inventories do
        if inventories[i].get_item_count(entity_name) >= count then
            return inventories[i]
        end
    end
    return nil
end

function deconstruct(player, radius)
    entitiesNearBy = player.surface.find_entities_filtered {
        position = player.position,
        radius = radius,
        to_be_deconstructed = true
    }
    for i = 1, #entitiesNearBy do
        player.mine_entity(entitiesNearBy[i], false)
    end
end

function reviveCommand(command)
    local player = game.players[command.player_index]
    local constructRadius = 200

    -- if (command.parameter ~= nil) then constructRadius = command.parameter end
    deconstruct(player, constructRadius)

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
    deconstruct(player, deconstructRadius)
end

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
        ["coal"] = {type = "fuel", count = 10, max = 100},
        ["wood"] = {type = "fuel", count = 20, max = 200}
    },
    ["burner-inserter"] = {
        ["coal"] = {type = "fuel", count = 10, max = 100},
        ["wood"] = {type = "fuel", count = 20, max = 200}
    },
    ["stone-furnace"] = {
        ["coal"] = {type = "fuel", count = 10, max = 100},
        ["wood"] = {type = "fuel", count = 20, max = 200},
        ["iron-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["copper-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["stone"] = {type = "furnaceitem", count = 10, max = 100},
        ["iron-plate"] = {type = "furnaceitem", count = 10, max = 100}
    },
    ["steel-furnace"] = {
        ["coal"] = {type = "fuel", count = 10, max = 100},
        ["wood"] = {type = "fuel", count = 20, max = 200},
        ["iron-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["copper-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["stone"] = {type = "furnaceitem", count = 10, max = 100},
        ["iron-plate"] = {type = "furnaceitem", count = 10, max = 100}
    },
    ["electric-furnace"] = {
        ["iron-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["copper-ore"] = {type = "furnaceitem", count = 10, max = 100},
        ["stone"] = {type = "furnaceitem", count = 10, max = 100},
        ["iron-plate"] = {type = "furnaceitem", count = 10, max = 100}
    },
    ["boiler"] = {
        ["coal"] = {type = "fuel", count = 10, max = 100},
        ["wood"] = {type = "fuel", count = 20, max = 200}
    },
    ["locomotive"] = {
        ["coal"] = {type = "fuel", count = 150, max = 150},
        ["solid-fuel"] = {type = "fuel", count = 150, max = 150},
        ["rocket-fuel"] = {type = "fuel", count = 30, max = 30},
        ["nuclear-fuel"] = {type = "fuel", count = 3, max = 3}
    },
    ["car"] = {
        ["coal"] = {type = "fuel", count = 150, max = 150},
        ["solid-fuel"] = {type = "fuel", count = 150, max = 150},
        ["rocket-fuel"] = {type = "fuel", count = 30, max = 30},
        ["nuclear-fuel"] = {type = "fuel", count = 3, max = 3}
    },
    ["tank"] = {
        ["coal"] = {type = "fuel", count = 150, max = 150},
        ["solid-fuel"] = {type = "fuel", count = 150, max = 150},
        ["rocket-fuel"] = {type = "fuel", count = 30, max = 30},
        ["nuclear-fuel"] = {type = "fuel", count = 3, max = 3}
    },
    ["assembling-machine-1"] = {
        ["coal"] = {type = "ingre", count = 10, max = 100},
        ["wood"] = {type = "ingre", count = 10, max = 100},
        ["iron-plate"] = {type = "ingre", count = 10, max = 100},
        ["copper-plate"] = {type = "ingre", count = 10, max = 100},
        ["stone"] = {type = "ingre", count = 10, max = 100},
        ["steel-plate"] = {type = "ingre", count = 10, max = 100},
        ["iron-gear-wheel"] = {type = "ingre", count = 10, max = 100},
        ["electronic-circuit"] = {type = "ingre", count = 10, max = 100},
        ["copper-cable"] = {type = "ingre", count = 10, max = 100},
        ["iron-stick"] = {type = "ingre", count = 10, max = 100},
        ["stone-brick"] = {type = "ingre", count = 10, max = 100},
        ["pipe"] = {type = "ingre", count = 100, max = 10},
        ["pipe-to-ground"] = {type = "ingre", count = 10, max = 100},
        ["transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["splitter"] = {type = "ingre", count = 10, max = 100},
        ["fast-splitter"] = {type = "ingre", count = 10, max = 100},
        ["express-splitter"] = {type = "ingre", count = 10, max = 100},
        ["underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["inserter"] = {type = "ingre", count = 10, max = 100},
        ["fast-inserter"] = {type = "ingre", count = 10, max = 100},
        ["stone-furnace"] = {type = "ingre", count = 10, max = 100},
        ["engine-unit"] = {type = "ingre", count = 10, max = 100},
        ["sulfur"] = {type = "ingre", count = 10, max = 100},
        ["advanced-circuit"] = {type = "ingre", count = 10, max = 100},
        ["stone-wall"] = {type = "ingre", count = 10, max = 100},
        ["grenade"] = {type = "ingre", count = 10, max = 100},
        ["piercing-rounds-magazine"] = {type = "ingre", count = 10, max = 200}
    },
    ["assembling-machine-2"] = {
        ["coal"] = {type = "ingre", count = 10, max = 100},
        ["wood"] = {type = "ingre", count = 10, max = 100},
        ["iron-plate"] = {type = "ingre", count = 10, max = 100},
        ["copper-plate"] = {type = "ingre", count = 10, max = 100},
        ["stone"] = {type = "ingre", count = 10, max = 100},
        ["steel-plate"] = {type = "ingre", count = 10, max = 100},
        ["iron-gear-wheel"] = {type = "ingre", count = 10, max = 100},
        ["electronic-circuit"] = {type = "ingre", count = 10, max = 100},
        ["copper-cable"] = {type = "ingre", count = 10, max = 100},
        ["iron-stick"] = {type = "ingre", count = 10, max = 100},
        ["stone-brick"] = {type = "ingre", count = 10, max = 100},
        ["pipe"] = {type = "ingre", count = 100, max = 10},
        ["pipe-to-ground"] = {type = "ingre", count = 10, max = 100},
        ["transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["splitter"] = {type = "ingre", count = 10, max = 100},
        ["fast-splitter"] = {type = "ingre", count = 10, max = 100},
        ["express-splitter"] = {type = "ingre", count = 10, max = 100},
        ["underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["inserter"] = {type = "ingre", count = 10, max = 100},
        ["fast-inserter"] = {type = "ingre", count = 10, max = 100},
        ["stone-furnace"] = {type = "ingre", count = 10, max = 100},
        ["engine-unit"] = {type = "ingre", count = 10, max = 100},
        ["sulfur"] = {type = "ingre", count = 10, max = 100},
        ["advanced-circuit"] = {type = "ingre", count = 10, max = 100},
        ["stone-wall"] = {type = "ingre", count = 10, max = 100},
        ["grenade"] = {type = "ingre", count = 10, max = 100},
        ["piercing-rounds-magazine"] = {type = "ingre", count = 10, max = 200}
    },
    ["assembling-machine-3"] = {
        ["coal"] = {type = "ingre", count = 10, max = 100},
        ["wood"] = {type = "ingre", count = 10, max = 100},
        ["iron-plate"] = {type = "ingre", count = 10, max = 100},
        ["copper-plate"] = {type = "ingre", count = 10, max = 100},
        ["stone"] = {type = "ingre", count = 10, max = 100},
        ["steel-plate"] = {type = "ingre", count = 10, max = 100},
        ["iron-gear-wheel"] = {type = "ingre", count = 10, max = 100},
        ["electronic-circuit"] = {type = "ingre", count = 10, max = 100},
        ["copper-cable"] = {type = "ingre", count = 10, max = 100},
        ["iron-stick"] = {type = "ingre", count = 10, max = 100},
        ["stone-brick"] = {type = "ingre", count = 10, max = 100},
        ["pipe"] = {type = "ingre", count = 100, max = 10},
        ["pipe-to-ground"] = {type = "ingre", count = 10, max = 100},
        ["transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-transport-belt"] = {type = "ingre", count = 10, max = 100},
        ["splitter"] = {type = "ingre", count = 10, max = 100},
        ["fast-splitter"] = {type = "ingre", count = 10, max = 100},
        ["express-splitter"] = {type = "ingre", count = 10, max = 100},
        ["underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["fast-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["express-underground-belt"] = {type = "ingre", count = 10, max = 100},
        ["inserter"] = {type = "ingre", count = 10, max = 100},
        ["fast-inserter"] = {type = "ingre", count = 10, max = 100},
        ["stone-furnace"] = {type = "ingre", count = 10, max = 100},
        ["engine-unit"] = {type = "ingre", count = 10, max = 100},
        ["sulfur"] = {type = "ingre", count = 10, max = 100},
        ["advanced-circuit"] = {type = "ingre", count = 10, max = 100},
        ["stone-wall"] = {type = "ingre", count = 10, max = 100},
        ["grenade"] = {type = "ingre", count = 10, max = 100},
        ["piercing-rounds-magazine"] = {type = "ingre", count = 10, max = 200}
    },
    ["lab"] = {
        ["automation-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["logistic-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["military-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["chemical-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["production-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["utility-science-pack"] = {type = "fuel", count = 1, max = 200},
        ["space-science-pack"] = {type = "fuel", count = 1, max = 200}
    },
    ["gun-turret"] = {
        ["firearm-magazine"] = {type = "fuel", count = 25, max = 200},
        ["piercing-rounds-magazine"] = {type = "fuel", count = 25, max = 200},
        ["uranium-rounds-magazine"] = {type = "fuel", count = 25, max = 200}
    },
    ["artillery-turret"] = {
        ["artillery-shell"] = {type = "fuel", count = 1, max = 10}
    }
}

function refillEntitiesCommand(command)
    local player = game.players[command.player_index]
    -- if (command.parameter ~= nil) then searchRadius = command.parameter end
    local searchRadius = 200

    -- Get all inventorys from accessible containers
    inventories = get_accessible_containers(player, searchRadius)

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
                item_count = refillable_item_stack_data["count"]
                item_max_count = refillable_item_stack_data["max"]
                refillable_item_stack = {
                    name = refillable_item_name,
                    count = item_count
                }

                if item_type == "furnaceitem" then
                    recipe_name =
                        furnace_item_to_recipe_map[refillable_item_name]
                    prepared_item_count_in_machine =
                        refillable_entity.get_item_count(recipe_name)
                    if ((prepared_item_count_in_machine > 0) and
                        player.can_insert(
                            {
                                name = recipe_name,
                                count = prepared_item_count_in_machine
                            })) then
                        -- log("Going to insert finished products to player " ..
                        --         recipe_name .. " with count " ..
                        --         prepared_item_count_in_furnace)
                        item_count_inserted = player.insert({
                            name = recipe_name,
                            count = prepared_item_count_in_machine
                        })
                        if item_count_inserted < prepared_item_count_in_machine then
                            depositPlayerItemsToChest(player)
                        end
                        if item_count_inserted > 0 then
                            refillable_entity.remove_item({
                                name = recipe_name,
                                count = item_count_inserted
                            })
                        end
                    end
                    if refillable_entity.previous_recipe and
                        (refillable_entity.previous_recipe.name == recipe_name) and
                        refillable_entity.can_insert(refillable_item_stack) and
                        (refillable_entity.get_item_count(refillable_item_name) <
                            item_max_count) then
                        container_with_item =
                            find_container_with_entity(refillable_item_name,
                                                       inventories, item_count)
                        if container_with_item ~= nil then
                            -- log(
                            --     "Going to insert furnace recipes to furnace " ..
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
                else -- if (item_type == "fuel") or (item_type == "ingre") then
                    -- TODO: 
                    if refillable_entity.type == "assembling-machine" then
                        current_recipe = refillable_entity.get_recipe()
                        if current_recipe ~= null then
                            recipe_name = current_recipe.name

                            prepared_item_count_in_machine =
                                refillable_entity.get_item_count(recipe_name)
                            if ((prepared_item_count_in_machine > 0) and
                                player.can_insert(
                                    {
                                        name = recipe_name,
                                        count = prepared_item_count_in_machine
                                    })) then
                                -- log("Going to insert finished products to player " ..
                                --         recipe_name .. " with count " ..
                                --         prepared_item_count_in_furnace)
                                item_count_inserted = player.insert({
                                    name = recipe_name,
                                    count = prepared_item_count_in_machine
                                })
                                if item_count_inserted <
                                    prepared_item_count_in_machine then
                                    depositPlayerItemsToChest(player)
                                end
                                if item_count_inserted > 0 then
                                    refillable_entity.remove_item({
                                        name = recipe_name,
                                        count = item_count_inserted
                                    })
                                end
                            end
                        end
                    end
                    if refillable_entity.can_insert(refillable_item_stack) and
                        (refillable_entity.get_item_count(refillable_item_name) <
                            item_max_count) then
                        container_with_item =
                            find_container_with_entity(refillable_item_name,
                                                       inventories, item_count)
                        if container_with_item ~= nil then
                            -- log("Going to insert recipes to entity " ..
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

depositable_items_list = {
    "coal", "wood", "solid-fuel", "rocket-fuel", "nuclear-fuel", "iron-ore",
    "copper-ore", "stone", "iron-plate", "copper-plate", "stone-brick",
    "steel-plate", "automation-science-pack", "logistic-science-pack",
    "military-science-pack", "chemical-science-pack", "production-science-pack",
    "utility-science-pack", "space-science-pack", "iron-gear-wheel",
    "electronic-circuit", "copper-cable", "iron-stick",
    --  "pipe",
    -- "pipe-to-ground", "transport-belt", "fast-transport-belt",
    -- "express-transport-belt", "splitter", "fast-splitter", "express-splitter",
    -- "underground-belt", "fast-underground-belt", "express-underground-belt",
    -- "inserter", "fast-inserter",
     "stone-furnace", "engine-unit", "sulfur",
    "advanced-circuit", 
    -- "stone-wall", "grenade", "firearm-magazine"
    -- "piercing-rounds-magazine", "uranium-rounds-magazine", "artillery-shell"
}

function depositPlayerItemsToChest(player)
    if player.has_items_inside() then
        for i, item_name in pairs(depositable_items_list) do
            item_count = player.get_item_count(item_name)
            if item_count > 0 then
                for ci, initial_chest in pairs(global["initial_chests"]) do
                    if initial_chest.can_insert({
                        name = item_name,
                        count = item_count
                    }) then
                        inserted_amount =
                            initial_chest.insert({
                                name = item_name,
                                count = item_count
                            })
                        if inserted_amount > 0 then
                            player.remove_item({
                                name = item_name,
                                count = inserted_amount
                            })
                            item_count = item_count - inserted_amount

                            if item_count <= 0 then
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function depositIntoChestsCommand(command)
    local player = game.players[command.player_index]
    depositPlayerItemsToChest(player)
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
    commands.remove_command("depositIntoChests")
    commands.add_command("depositIntoChests",
                         "[Command]: Revives ghosts in the area near player using items from player inventory and available chests.",
                         depositIntoChestsCommand)
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
    commands.remove_command("blackDeath")
    commands.add_command("blackDeath", "[Admin Command]: Kills all enemy entity on explored area.", blackDeathCommand)
    commands.remove_command("marcoPolo")
    commands.add_command("marcoPolo", "[Admin Command]: Explores a large area.",
                         marcoPoloCommand)
    commands.remove_command("aegis")
    commands.add_command("aegis", "[Admin Command]: Speeds up everything.",
                         aegisCommand)
    commands.remove_command("enableAllTech")
    commands.add_command("enableAllTech", "[Admin Command]: Unlocks all technologies.", enableAllTechCommand)
    commands.remove_command("changeDiplomacy")
    commands.add_command("changeDiplomacy",
                         "[Admin Command]: Toggles diplomatic stance with enemy.",
                         changeDiplomacyCommand)
    commands.remove_command("enableAllRecipes")
    commands.add_command("enableAllRecipes", "[Admin Command]: Emables all recipes.", enableAllRecipesCommand)
    -- 
    -- commands.remove_command("mmzPrint")
    -- commands.add_command("mmzPrint",
    --                      "[Admin Command]: Prints the MMZ spawn base.",
    --                      mmzPrintCommand)
end

return mmzfreeplay
