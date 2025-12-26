local util = require("util")
local crash_site = require("crash-site")

local created_items = function()
  return
  {
    ["iron-plate"] = 300,
    -- ["copper-plate"] = 200,
    -- ["steel-plate"] = 100,
    ["wood"] = 100,
    ["submachine-gun"] = 1,
    ["firearm-magazine"] = 10,
    -- ["burner-mining-drill"] = 1,
    ["electric-mining-drill"] = 30,
    ["small-electric-pole"] = 30,
    ["stone-furnace"] = 1,
    ["solar-panel"]= 100,
    -- ["accumulator"]= 84
  }
end


local respawn_items = function()
  return
  {
    ["pistol"] = 1,
    ["firearm-magazine"] = 10
  }
end

local ship_items = function()
  return
  {
    ["firearm-magazine"] = 8
  }
end

local debris_items = function()
  return
  {
    ["iron-plate"] = 8
  }
end

local ship_parts = function()
  return crash_site.default_ship_parts()
end

local chart_starting_area = function()
  local r = storage.chart_distance or 200
  local force = game.forces.player
  local surface = game.surfaces[1]
  local origin = force.get_spawn_position(surface)
  force.chart(surface, {{origin.x - r, origin.y - r}, {origin.x + r, origin.y + r}})
end

local get_starting_message = function()
  if storage.custom_intro_message then
    return storage.custom_intro_message
  end
  if script.active_mods["space-age"] then
    return {"msg-intro-space-age"}
  end
  return {"msg-intro"}
end

local show_intro_message = function(player)
  if storage.skip_intro then return end

  if game.is_multiplayer() then
    player.print(get_starting_message())
  else
    game.show_message_dialog{text = get_starting_message()}
  end
end


local on_player_created = function(event)
  local player = game.get_player(event.player_index)
  util.insert_safe(player, storage.created_items)

  --  ************************* MMZ Soft Mod section start *******************************
  if ( (storage._map_initialized == nil) or (storage._map_initialized == false) ) then 
    init_soft_mod(player)
  end
  --  ************************* MMZ Soft Mod section end   *******************************

  if not storage.init_ran then

    --This is so that other mods and scripts have a chance to do remote calls before we do things like charting the starting area, creating the crash site, etc.
    storage.init_ran = true

    chart_starting_area()

    if not storage.disable_crashsite then
      local surface = player.surface
      surface.daytime = 0.7
      crash_site.create_crash_site(surface, {-5,-6}, util.copy(storage.crashed_ship_items), util.copy(storage.crashed_debris_items), util.copy(storage.crashed_ship_parts))
      util.remove_safe(player, storage.crashed_ship_items)
      util.remove_safe(player, storage.crashed_debris_items)
      player.get_main_inventory().sort_and_merge()
      if player.character then
        player.character.destructible = false
      end
      storage.crash_site_cutscene_active = true
      crash_site.create_cutscene(player, {-5, -4})
      return
    end

  end

  show_intro_message(player)
end

local on_player_respawned = function(event)
  local player = game.get_player(event.player_index)
  util.insert_safe(player, storage.respawn_items)
end

local on_cutscene_waypoint_reached = function(event)
  if not storage.crash_site_cutscene_active then return end
  if not crash_site.is_crash_site_cutscene(event) then return end

  local player = game.get_player(event.player_index)

  player.exit_cutscene()
  show_intro_message(player)
end

local skip_crash_site_cutscene = function(event)
  if not storage.crash_site_cutscene_active then return end
  if event.player_index ~= 1 then return end
  local player = game.get_player(event.player_index)
  if player.controller_type == defines.controllers.cutscene then
    player.exit_cutscene()
  end
end

local on_cutscene_cancelled = function(event)
  if not storage.crash_site_cutscene_active then return end
  if event.player_index ~= 1 then return end
  storage.crash_site_cutscene_active = nil
  local player = game.get_player(event.player_index)
  if player.gui.screen.skip_cutscene_label then
    player.gui.screen.skip_cutscene_label.destroy()
  end
  if player.character then
    player.character.destructible = true
  end
  player.zoom = 1.5
end

local on_player_display_refresh = function(event)
  crash_site.on_player_display_refresh(event)
end

local freeplay_interface =
{
  get_created_items = function()
    return storage.created_items
  end,
  set_created_items = function(map)
    storage.created_items = map or error("Remote call parameter to freeplay set created items can't be nil.")
  end,
  get_respawn_items = function()
    return storage.respawn_items
  end,
  set_respawn_items = function(map)
    storage.respawn_items = map or error("Remote call parameter to freeplay set respawn items can't be nil.")
  end,
  set_skip_intro = function(bool)
    storage.skip_intro = bool
  end,
  get_skip_intro = function()
    return storage.skip_intro
  end,
  set_custom_intro_message = function(message)
    storage.custom_intro_message = message
  end,
  get_custom_intro_message = function()
    return storage.custom_intro_message
  end,
  set_chart_distance = function(value)
    storage.chart_distance = tonumber(value) or error("Remote call parameter to freeplay set chart distance must be a number")
  end,
  get_disable_crashsite = function()
    return storage.disable_crashsite
  end,
  set_disable_crashsite = function(bool)
    storage.disable_crashsite = bool
  end,
  get_init_ran = function()
    return storage.init_ran
  end,
  get_ship_items = function()
    return storage.crashed_ship_items
  end,
  set_ship_items = function(map)
    storage.crashed_ship_items = map or error("Remote call parameter to freeplay set created items can't be nil.")
  end,
  get_debris_items = function()
    return storage.crashed_debris_items
  end,
  set_debris_items = function(map)
    storage.crashed_debris_items = map or error("Remote call parameter to freeplay set respawn items can't be nil.")
  end,
  get_ship_parts = function()
    return storage.crashed_ship_parts
  end,
  set_ship_parts = function(parts)
    storage.crashed_ship_parts = parts or error("Remote call parameter to freeplay set ship parts can't be nil.")
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

local init_ending_info = function()
  local is_space_age = script.active_mods["space-age"]
  local info =
  {
    image_path = is_space_age and "__base__/script/freeplay/victory-space-age.png" or "__base__/script/freeplay/victory.png",
    title = {"gui-game-finished.victory"},
    message = is_space_age and {"victory-message-space-age"} or {"victory-message"},
    bullet_points =
    {
      {"victory-bullet-point-1"},
      {"victory-bullet-point-2"},
      {"victory-bullet-point-3"},
      {"victory-bullet-point-4"}
    },
    final_message = {"victory-final-message"},
  }
  game.set_win_ending_info(info)
end

local freeplay = {}

freeplay.events =
{
  [defines.events.on_player_created] = on_player_created,
  [defines.events.on_player_respawned] = on_player_respawned,
  [defines.events.on_cutscene_waypoint_reached] = on_cutscene_waypoint_reached,
  ["crash-site-skip-cutscene"] = skip_crash_site_cutscene,
  [defines.events.on_player_display_resolution_changed] = on_player_display_refresh,
  [defines.events.on_player_display_scale_changed] = on_player_display_refresh,
  [defines.events.on_cutscene_cancelled] = on_cutscene_cancelled
}

freeplay.on_configuration_changed = function()
  storage.created_items = storage.created_items or created_items()
  storage.respawn_items = storage.respawn_items or respawn_items()
  storage.crashed_ship_items = storage.crashed_ship_items or ship_items()
  storage.crashed_debris_items = storage.crashed_debris_items or debris_items()
  storage.crashed_ship_parts = storage.crashed_ship_parts or ship_parts()

  if not storage.init_ran then
    -- migrating old saves.
    storage.init_ran = #game.players > 0
  end
  init_ending_info()
end



freeplay.on_init = function()
  game.allow_tip_activation = true
  storage.created_items = created_items()
  storage.respawn_items = respawn_items()
  storage.crashed_ship_items = ship_items()
  storage.crashed_debris_items = debris_items()
  storage.crashed_ship_parts = ship_parts()
  add_Commands()
  if is_debug() then
    storage.skip_intro = true
    storage.disable_crashsite = true
  end

  init_ending_info()

end

--  ************************* MMZ Soft Mod section start *******************************

local give_first_player_items = function(player)    
    player.insert {name = "iron-plate", count = 500}
    player.insert {name = "copper-plate", count = 300}
    player.insert {name = "steel-plate", count = 250}
    player.insert {name = "wood", count = 100}
    player.insert {name = "electric-mining-drill", count = 1}
    player.insert {name = "electric-furnace", count = 10}
    player.insert {name = "small-electric-pole", count = 10}
end

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

function mmzPrint(player, tileToFillWith)

    player.teleport {player.position.x - 31, player.position.y - 31}
    waterFillArea(player, 30, 30, 31, 31)
    landFillArea(player, 30, 30, 31, 31, "grass-1")
    player.teleport {player.position.x + 31, player.position.y + 31}

    for i = 1, 17 do
        initial_turret = player.surface.create_entity({
            name = "laser-turret",
            force = player.force,
            amount = 1,
            position = {player.position.x + 20, player.position.y - 18 + i * 2}
        })
        initial_turret.minable = false
        initial_turret.destructible = false

        initial_turret = player.surface.create_entity({
            name = "laser-turret",
            force = player.force,
            amount = 1,
            position = {player.position.x - 20, player.position.y - 18 + i * 2}
        })
        initial_turret.minable = false
        initial_turret.destructible = false

        initial_turret = player.surface.create_entity({
            name = "laser-turret",
            force = player.force,
            amount = 1,
            position = {player.position.x - 18 + i * 2, player.position.y + 20}
        })
        initial_turret.minable = false
        initial_turret.destructible = false

        initial_turret = player.surface.create_entity({
            name = "laser-turret",
            force = player.force,
            amount = 1,
            position = {player.position.x - 18 + i * 2, player.position.y - 20}
        })
        initial_turret.minable = false
        initial_turret.destructible = false
    end

    for i = 1, 11 do
        init_spanel = player.surface.create_entity({
            name = "solar-panel",
            force = player.force,
            amount = 1,
            position = {player.position.x + 22, player.position.y - 19 + i * 3}
        })
        init_spanel.minable = false
        init_spanel.destructible = false

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x + 25, player.position.y - 19 + i * 3}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false

        init_spanel = player.surface.create_entity({
            name = "solar-panel",
            force = player.force,
            amount = 1,
            position = {player.position.x - 23, player.position.y - 19 + i * 3}
        })
        init_spanel.minable = false
        init_spanel.destructible = false

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x - 26, player.position.y - 19 + i * 3}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false

        init_spanel = player.surface.create_entity({
            name = "solar-panel",
            force = player.force,
            amount = 1,
            position = {player.position.x - 19 + i * 3, player.position.y - 23}
        })
        init_spanel.minable = false
        init_spanel.destructible = false

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x - 19 + i * 3, player.position.y - 26}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false

        init_spanel = player.surface.create_entity({
            name = "solar-panel",
            force = player.force,
            amount = 1,
            position = {player.position.x - 19 + i * 3, player.position.y + 22}
        })
        init_spanel.minable = false
        init_spanel.destructible = false

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x - 19 + i * 3, player.position.y + 25}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false
    end

    local tiles = {}
    local pos = player.position

    pos.y = pos.y - 4

    if (tileToFillWith == nil) then
        tileToFillWith = "dirt-1"
    end

    for y = pos.y - 4, pos.y + 4 do
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x - 14, y}
        })
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x - 6, y}
        })
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x - 4, y}
        })
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x + 4, y}
        })
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
        table.insert(tiles, {
            name = tileToFillWith,
            position = {pos.x + i, pos.y - i}
        })
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

    -- initial_epole = player.surface.create_entity({
    --     name = "substation",
    --     force = player.force,
    --     amount = 1,
    --     position = {player.position.x, player.position.y }
    -- })
    -- initial_epole.minable = false
    -- initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x, player.position.y - 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x, player.position.y + 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x + 18, player.position.y}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x + 18, player.position.y - 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x + 18, player.position.y + 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x - 18, player.position.y}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x - 18, player.position.y - 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    initial_epole = player.surface.create_entity({
        name = "substation",
        force = player.force,
        amount = 1,
        position = {player.position.x - 18, player.position.y + 18}
    })
    initial_epole.minable = false
    initial_epole.destructible = false

    for i = 0, 8 do
        initial_accumulator = player.surface.create_entity({
            name = "accumulator",
            force = player.force,
            amount = 1,
            position = {player.position.x - 8 + i * 2, player.position.y + 10}
        })
        initial_accumulator.minable = false
        initial_accumulator.destructible = false
        -- initial_accumulator.energy = 10000

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x - 9 + i * 2, player.position.y + 11}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false

        initial_accumulator = player.surface.create_entity({
            name = "accumulator",
            force = player.force,
            amount = 1,
            position = {player.position.x - 8 + i * 2, player.position.y + 13}
        })
        initial_accumulator.minable = false
        initial_accumulator.destructible = false
        -- initial_accumulator.energy = 10000

        initial_accumulator = player.surface.create_entity({
            name = "accumulator",
            force = player.force,
            amount = 1,
            position = {player.position.x - 8 + i * 2, player.position.y - 10}
        })
        initial_accumulator.minable = false
        initial_accumulator.destructible = false
        -- initial_accumulator.energy = 10000

        initial_lamp = player.surface.create_entity({
            name = "small-lamp",
            force = player.force,
            amount = 1,
            position = {player.position.x - 9 + i * 2, player.position.y - 12}
        })
        initial_lamp.minable = false
        initial_lamp.destructible = false

        initial_accumulator = player.surface.create_entity({
            name = "accumulator",
            force = player.force,
            amount = 1,
            position = {player.position.x - 8 + i * 2, player.position.y - 13}
        })
        initial_accumulator.minable = false
        initial_accumulator.destructible = false
        -- initial_accumulator.energy = 10000
    end

    -- initial_playerPort = player.surface.create_entity({
    --     name = "player-port",
    --     force = player.force,
    --     amount = 1,
    --     position = {player.position.x, player.position.y}
    -- })
    -- initial_playerPort.minable = false
    -- initial_playerPort.destructible = false
end

function mmzPrintCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        -- for i=1,100 do
        mmzPrint(player, "out-of-map")
        -- end		
    end
end

function reviveCommand(command)
  local player = game.players[command.player_index]

  local constructRadius = 200

  if (command.parameter ~= nil) then
      constructRadius = command.parameter
  end

  ghostEntities = player.surface.find_entities_filtered {
      type = "entity-ghost",
      position = player.position,
      radius = constructRadius
  }
  playerInventory = player.get_main_inventory()
  inventoryContents = playerInventory.get_contents()

  for i = 1, #ghostEntities do
      local ghostName = ghostEntities[i].ghost_name

      if ((ghostName == "straight-rail") or (ghostName == "curved-rail")) then
          ghostName = "rail"
      end

     if ((inventoryContents[ghostName] ~= nil) and (inventoryContents[ghostName] > 0)) then
          ghostEntities[i].silent_revive()
          inventoryContents[ghostName] = inventoryContents[ghostName] - 1;
          playerInventory.remove {
              name = ghostName,
              count = 1
          }          
      end
  end
end

function init_soft_mod(player)

    storage._map_surface=player.surface
	storage._map_initialized=true
	storage._spawn_position=player.position

	player.force.friendly_fire=false	
	player.force.character_inventory_slots_bonus=player.force.character_inventory_slots_bonus+5000
	player.force.character_running_speed_modifier = 3
	player.force.manual_crafting_speed_modifier=200
	player.force.manual_mining_speed_modifier=100
	player.force.character_build_distance_bonus = 5000
	player.force.character_reach_distance_bonus = 5000	
	player.force.character_resource_reach_distance_bonus = 5000

    player.force.recipes["steel-plate"].enabled=true
	player.force.recipes["solar-panel"].enabled=true

	-- player.insert{name="submachine-gun", count=1}  
	-- player.insert{name="firearm-magazine", count=200} 

    give_first_player_items(player)

    player.print("Soft mod initialized")

  printBaseLayout(player)
end

-- Need to optimize the function instead of too much copy paste
function equipPlayer(player)
    player.insert {name = "power-armor-mk2", count = 1}
    local p_armor = player.get_inventory(5)[1].grid
    for i = 1, 4 do p_armor.put({name = "fission-reactor-equipment"}) end
    for i = 1, 6 do p_armor.put({name = "personal-laser-defense-equipment"}) end
    p_armor.put({name = "night-vision-equipment"})
    for i = 1, 6 do p_armor.put({name = "battery-mk2-equipment"}) end

    player.insert {name = "submachine-gun", count = 1}
    player.insert {name = "uranium-rounds-magazine", count = 1000}
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
    table.insert(storage["initial_chests"], initial_chest)
    return initial_chest
end

function printBaseLayout(player, tileToFillWith)
    -- player.teleport {player.position.x - 15, player.position.y - 15}
    -- waterFillArea(player, 14, 14, 15, 15)
    -- landFillArea(player, 14, 14, 15, 15, "dirt-7")
    -- player.teleport {player.position.x + 15, player.position.y + 15}

    landFillArea(player, 8, 8, 0, 0, "dirt-7")
    tileRing(player, 65, 1, "water", 10)
    generateResources(player, 500, 100, 31)

    -- Intial steel chests
    initial_chests = {}
    storage["initial_chests"] = initial_chests    
    count = 1
    for i = 0, 4 do
        for j = 0, 4 do
            createInitialChest(player, player.position.x - i - 3,
                               player.position.y - j - 3)
            createInitialChest(player, player.position.x - i - 3,
                               player.position.y + j + 2)
            createInitialChest(player, player.position.x + i + 2,
                               player.position.y - j - 3)
            createInitialChest(player, player.position.x + i + 2,
                               player.position.y + j + 2)
        end
    end

    mmzPrint(player, "dirt-7")

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

function tileRing(player, size, thichness, tileToFillWith, gap)
    -- waterFillArea(player,size,thichness,0,-size/2)
    -- waterFillArea(player,thichness,size,-size/2,0)
    -- waterFillArea(player,thichness,size,size/2,0)
    -- waterFillArea(player,size,thichness,0,size/2)

    if (tileToFillWith == nil) then tileToFillWith = "water" end
    if (gap==nil) then gap=0 end

    local tiles = {}
    local pos = player.position
    for x = pos.x - size / 2 + gap, pos.x + size / 2 - gap do
        for y = pos.y - size / 2 - thichness, pos.y - size / 2 do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x + size / 2, pos.x + size / 2 + thichness do
        for y = pos.y - size / 2 + gap , pos.y + size / 2 - gap do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x - size / 2 + gap , pos.x + size / 2 - gap do
        for y = pos.y + size / 2, pos.y + size / 2 + thichness do
            local t = player.surface.get_tile(x, y)
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
        end
    end
    for x = pos.x - size / 2 - thichness, pos.x - size / 2 do
        for y = pos.y - size / 2 + gap , pos.y + size / 2 - gap do
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
    inventories = {player, table.unpack(storage["initial_chests"])}
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
    "electronic-circuit", "copper-cable", "iron-stick", --  "pipe",
    -- "pipe-to-ground", "transport-belt", "fast-transport-belt",
    -- "express-transport-belt", "splitter", "fast-splitter", "express-splitter",
    -- "underground-belt", "fast-underground-belt", "express-underground-belt",
    -- "inserter", "fast-inserter",
    "stone-furnace", "engine-unit", "sulfur", "advanced-circuit"
    -- "stone-wall", "grenade", "firearm-magazine"
    -- "piercing-rounds-magazine", "uranium-rounds-magazine", "artillery-shell"
}

function depositPlayerItemsToChest(player)
    if player.has_items_inside() then
        for i, item_name in pairs(depositable_items_list) do
            item_count = player.get_item_count(item_name)
            if item_count > 0 then
                for ci, initial_chest in pairs(storage["initial_chests"]) do
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
        player.teleport(storage["_spawn_position"])
        game.print(player.name .. " has teleported to the their main spawn area")
    else -- (command.parameter ~= nil) then
        local paramPlayer = getPlayerByName(command.parameter)

        if  (paramPlayer ~= null) then
            player.teleport(paramPlayer.position.x, paramPlayer.position.y)
            player.print("You teleported to " .. command.parameter)
            paramPlayer.print(player.name .. " teleport to you.")
            return
        end

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

-- Deletes all resource entities in a given rectangular area
-- surface: LuaSurface object (e.g., game.surfaces["nauvis"])
-- pos1, pos2: tables with {x=..., y=...} defining opposite corners of the area
function delete_resources_in_area(surface, pos1, pos2)
    if not (surface and surface.valid) then
        log("Invalid surface provided.")
        return
    end

    -- Find all resource entities in the area
    local resources = surface.find_entities_filtered{
        area = {pos1, pos2},
        type = "resource"
    }

    -- Destroy each resource entity found
    for _, entity in pairs(resources) do
        if entity.valid then
            entity.destroy()
        end
    end

    log("Deleted " .. tostring(#resources) .. " resource entities.")
end

function tileFillArea(tileToFillWith, surface, pos1, pos2)
    if (tileToFillWith == nil) then tileToFillWith = "grass-1" end
    local tiles = {}
    for y = pos1.y, pos2.y do
        for x = pos1.x, pos2.x do
            local t = surface.get_tile(x, y)
            -- if t.name == "water" or t.name == "deepwater" then
            table.insert(tiles, {name = tileToFillWith, position = {x, y}})
            -- end
        end
    end
    surface.set_tiles(tiles)
end

function generateResource(resource_name,player, density, pos1, pos2)
    -- Chart the area    
    player.force.chart(player.surface, {
        {pos1.x, pos1.y},
        {pos2.x, pos2.y}
    })

    -- landfill the area
    tileFillArea('grass-1', player.surface, pos1, pos2)

    -- Delete resources in area before generating
    delete_resources_in_area(player.surface, pos1, pos2)

   for y = pos1.y, pos2.y do
        for x = pos1.x, pos2.x do
            if player.surface.get_tile(x, y).collides_with(
                "ground_tile") then
                player.surface.create_entity({
                    name = resource_name,
                    amount = density,
                    position = {x,  y}
                })
            end
        end
    end
end

function generateResources(player, density, size, patchOffset)
    if (density == nil) then density = 1000 end

    if (size == nil) then size = 100 end

    if (patchOffset == nil) then patchOffset = 10 end

    local surface = player.surface
    local center = player.position
    local center_x= player.position.x
    local center_y= player.position.y

    local ore = nil    
    local oilPatchSide = size / 6

    generateResource('coal', player, density * 2,
    {x=center_x-patchOffset-size,   y=center_y-patchOffset-size},
    {x=center_x-patchOffset,        y=center_y-patchOffset}
    )

    generateResource('iron-ore', player, density * 2,
    {x=center_x+patchOffset,        y=center_y-patchOffset-size},
    {x=center_x+patchOffset+size,   y=center_y-patchOffset}
    )

    generateResource('copper-ore', player, density,
    {x=center_x-patchOffset-size,   y=center_y+patchOffset},
    {x=center_x-patchOffset,        y=center_y+patchOffset+size}
    )

    generateResource('stone', player, density,
    {x=center_x+patchOffset,        y=center_y+patchOffset},
    {x=center_x+patchOffset+size,   y=center_y+patchOffset+size}
    )

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

function deleteResourcesCommand(event)
    local player = game.players[event.player_index]
    
     -- Delete resources in area before generating
    local surface = player.surface
    local center = player.position
    local radius = 250
    
    delete_resources_in_area(
        surface,
        {x = center.x - radius, y = center.y - radius},
        {x = center.x + radius, y = center.y + radius}
    )
end

function generateResourcesCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then generateResources(player, 1000, 20) end
end

function aegisCommand(event)
    local player = game.players[event.player_index]
    if (player.admin == true) then
        local craftingSpeedIncrease = 10000

        if (storage["_aegis_on"]) then
            storage["_aegis_on"] = false
            player.force.manual_crafting_speed_modifier = player.force
                                                              .manual_crafting_speed_modifier -
                                                              craftingSpeedIncrease
        else
            storage["_aegis_on"] = true
            player.force.manual_crafting_speed_modifier = player.force
                                                              .manual_crafting_speed_modifier +
                                                              craftingSpeedIncrease
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
        -- if (storage["_all_recipes_on"] == nil) or (storage["_all_recipes_on"]==false) then
        player.force.enable_all_recipes()
        -- player.force.recipes["electric-energy-interface"].enabled = false
        --   storage["_all_recipes_on"]=rue
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
                         "Use /teleport to teleport to main base or /teleport <SurfaceName> to teleport to a surface or /teleport <PlayerName> | <CustomTagText> to go to a player or custom tag location",
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

    commands.remove_command("deleteResources")
    commands.add_command("deleteResources",
                         "[Admin Command]: Deletes resources in an area.",
                         deleteResourcesCommand)

    commands.remove_command("generateResources")
    commands.add_command("generateResources",
                         "[Admin Command]: Generates resources in an area.",
                         generateResourcesCommand)

    commands.remove_command("blackDeath")
    commands.add_command("blackDeath",
                         "[Admin Command]: Kills all enemy entity on explored area.",
                         blackDeathCommand)

    commands.remove_command("marcoPolo")
    commands.add_command("marcoPolo", "[Admin Command]: Explores a large area.",
                         marcoPoloCommand)

    commands.remove_command("aegis")
    commands.add_command("aegis",
                         "[Admin Command]: Speeds up manual crafting speed (toggles).",
                         aegisCommand)

    commands.remove_command("enableAllTech")
    commands.add_command("enableAllTech",
                         "[Admin Command]: Unlocks all technologies.",
                         enableAllTechCommand)

    commands.remove_command("changeDiplomacy")
    commands.add_command("changeDiplomacy",
                         "[Admin Command]: Toggles diplomatic stance with enemy.",
                         changeDiplomacyCommand)

    commands.remove_command("enableAllRecipes")
    commands.add_command("enableAllRecipes",
                         "[Admin Command]: Emables all recipes.",
                         enableAllRecipesCommand)

    commands.remove_command("equipPlayer")
    commands.add_command("equipPlayer","[Admin Command]: Gives advanced equipment to a player.", equipPlayerCommand)

    commands.remove_command("pandorasBox")
    commands.add_command("pandorasBox", "[Admin command]: Give pandoras box to a player.", pandorasBoxCommand)

    commands.remove_command("toggleCheat")
    commands.add_command("toggleCheat", "[Admin command]: Craft without inventory items.", toggleCheatCommand)

    commands.remove_command("mmzPrint")
    commands.add_command("mmzPrint", "[Admin Command]: Creates a safe zone with MMZ print.", mmzPrintCommand)
    -- 
    -- commands.remove_command("mmzPrint")
    -- commands.add_command("mmzPrint",
    --                      "[Admin Command]: Prints the MMZ spawn base.",
    --                      mmzPrintCommand)
end

freeplay.on_load = function() add_Commands() end

--  ************************* MMZ Soft Mod section end start *******************************
return freeplay
