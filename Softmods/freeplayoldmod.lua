local util = require("util")
local crash_site = require("crash-site")

local created_items = function()
  return
  {
    ["heavy-armor"]= 1,
    ["iron-plate"] = 1000,
    ["copper-plate"] = 500,
    ["steel-plate"] = 500,
    -- ["stone"] = 100,
    -- ["wood"] = 500,
    ["submachine-gun"] = 1,
    ["firearm-magazine"] = 200,
    ["electric-mining-drill"] = 50,  
    ["transport-belt"] = 500,  
    ["splitter"] = 50,    
    ["underground-belt"] = 50,
    -- ["small-electric-pole"] = 100,
    -- ["medium-electric-pole"] = 50,
    ["long-handed-inserter"] = 50,
    ["inserter"] = 50,
    ["loader"] = 10,
    -- ["electric-furnace"] = 20,    
  }
end

local respawn_items = function()
  return
  {
    ["submachine-gun"] = 1,
    ["firearm-magazine"] = 200
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
  local r = global.chart_distance or 200
  local force = game.forces.player
  local surface = game.surfaces[1]
  local origin = force.get_spawn_position(surface)
  force.chart(surface, {{origin.x - r, origin.y - r}, {origin.x + r, origin.y + r}})
end


local on_player_created = function(event)
  local player = game.get_player(event.player_index)
  util.insert_safe(player, global.created_items)

  if not global.init_ran then

    --This is so that other mods and scripts have a chance to do remote calls before we do things like charting the starting area, creating the crash site, etc.
    global.init_ran = true

    chart_starting_area()

    -- if not global.disable_crashsite then
    --   local surface = player.surface
    --   surface.daytime = 0.7
    --   crash_site.create_crash_site(surface, {-5,-6}, util.copy(global.crashed_ship_items), util.copy(global.crashed_debris_items), util.copy(global.crashed_ship_parts))
    --   util.remove_safe(player, global.crashed_ship_items)
    --   util.remove_safe(player, global.crashed_debris_items)
    --   player.get_main_inventory().sort_and_merge()
    --   if player.character then
    --     player.character.destructible = false
    --   end
    --   global.crash_site_cutscene_active = true
    --   crash_site.create_cutscene(player, {-5, -4})
    --   return
    -- end

  end

  if not global.skip_intro then
    if game.is_multiplayer() then
      player.print(global.custom_intro_message or {"msg-intro"})
    else
      game.show_message_dialog{text = global.custom_intro_message or {"msg-intro"}}
    end
  end

  if ((global["_map_initialized"] == nil) or (global["_map_initialized"] == false)) then -- player.name == "MasterManiaZ") then				
    global["_map_initialized"] = true
    global["_spawn_position"] = player.position
    global["_map_surface"] = player.surface
    global["_aegis_on"] = false

    player.force.friendly_fire = false

    player.force.recipes["loader"].enabled = true
    player.force.recipes["fast-loader"].enabled = true
    player.force.recipes["express-loader"].enabled = true
    -- player.force.recipes["railgun"].enabled = true
    -- player.force.recipes["railgun-dart"].enabled = true

    player.force.research_queue_enabled = true

    player.force.character_inventory_slots_bonus = player.force.character_inventory_slots_bonus + 100
    player.force.character_running_speed_modifier = 3
    -- player.force.manual_mining_speed_modifier = 100
    player.force.character_build_distance_bonus = 5000
    player.force.character_reach_distance_bonus = 5000
    player.force.character_resource_reach_distance_bonus = 5000
    -- player.force.manual_crafting_speed_modifier = 100

    player.force.technologies["automation"].researched = true
    -- player.force.recipes["assembling-machine-1"].enabled = true
    -- player.force.recipes["assembling-machine-2"].enabled = true
    player.force.recipes["splitter"].enabled = true
    -- player.force.recipes["fast-splitter"].enabled = true
    player.force.recipes["underground-belt"].enabled = true
    -- player.force.recipes["fast-transport-belt"].enabled = true
    -- player.force.recipes["fast-underground-belt"].enabled = true
    player.force.recipes["long-handed-inserter"].enabled = true
    player.force.recipes["fast-inserter"].enabled = true
    player.force.recipes["steel-plate"].enabled = true
    -- player.force.recipes["steel-furnace"].enabled = true
    player.force.recipes["engine-unit"].enabled = true
    player.force.recipes["stack-inserter"].enabled = true
    player.force.recipes["rail"].enabled = true
    player.force.recipes["rail-chain-signal"].enabled = true
    player.force.recipes["rail-signal"].enabled = true
    player.force.recipes["train-stop"].enabled = true
    player.force.recipes["locomotive"].enabled = true
    player.force.recipes["cargo-wagon"].enabled = true
    player.force.recipes["fluid-wagon"].enabled = true
    player.force.recipes["radar"].enabled = true
    player.force.recipes["pump"].enabled = true
    player.force.recipes["storage-tank"].enabled = true
    player.force.recipes["big-electric-pole"].enabled = true
    player.force.recipes["medium-electric-pole"].enabled = true
    -- player.force.recipes["player-port"].enabled=true
    player.force.recipes["green-wire"].enabled = true
    player.force.recipes["red-wire"].enabled = true
    player.force.recipes["oil-refinery"].enabled = true
    player.force.recipes["pumpjack"].enabled = true
    player.force.recipes["chemical-plant"].enabled = true
    player.force.recipes["basic-oil-processing"].enabled = true
    player.force.recipes["solid-fuel-from-heavy-oil"].enabled = true
    player.force.recipes["solid-fuel-from-light-oil"].enabled = true
    player.force.recipes["solid-fuel-from-petroleum-gas"].enabled = true
    player.force.recipes["advanced-oil-processing"].enabled = true
    player.force.recipes["light-oil-cracking"].enabled = true
    player.force.recipes["heavy-oil-cracking"].enabled = true
    player.force.recipes["plastic-bar"].enabled = true
    player.force.recipes["advanced-circuit"].enabled = true
    -- player.force.recipes["substation"].enabled = true
    player.force.recipes["electric-furnace"].enabled = true
    -- player.force.recipes["lubricant"].enabled = true
    -- player.force.recipes["express-splitter"].enabled = true
    -- player.force.recipes["express-transport-belt"].enabled = true
    -- player.force.recipes["express-underground-belt"].enabled = true
    player.force.recipes["sulfur"].enabled = true
    player.force.recipes["sulfuric-acid"].enabled = true
    player.force.recipes["battery"].enabled = true
    player.force.recipes["laser-turret"].enabled = true
    player.force.recipes["accumulator"].enabled = true
    player.force.recipes["solar-panel"].enabled = true
    player.force.recipes["small-lamp"].enabled = true

    mmzPrint(player, "out-of-map")

    -- local character = player.character
    -- player.character = nil
    -- if character then
    --     character.destroy()
    -- end
  end
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
      game.show_message_dialog{text = global.custom_intro_message or {"msg-intro"}}
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
    return global.created_items
  end,
  set_created_items = function(map)
    global.created_items = map or error("Remote call parameter to freeplay set created items can't be nil.")
  end,
  get_respawn_items = function()
    return global.respawn_items
  end,
  set_respawn_items = function(map)
    global.respawn_items = map or error("Remote call parameter to freeplay set respawn items can't be nil.")
  end,
  set_skip_intro = function(bool)
    global.skip_intro = bool
  end,
  get_skip_intro = function()
    return global.skip_intro
  end,
  set_custom_intro_message = function(message)
    global.custom_intro_message = message
  end,
  get_custom_intro_message = function()
    return global.custom_intro_message
  end,
  set_chart_distance = function(value)
    global.chart_distance = tonumber(value) or error("Remote call parameter to freeplay set chart distance must be a number")
  end,
  get_disable_crashsite = function()
    return global.disable_crashsite
  end,
  set_disable_crashsite = function(bool)
    global.disable_crashsite = bool
  end,
  get_init_ran = function()
    return global.init_ran
  end,
  get_ship_items = function()
    return global.crashed_ship_items
  end,
  set_ship_items = function(map)
    global.crashed_ship_items = map or error("Remote call parameter to freeplay set created items can't be nil.")
  end,
  get_debris_items = function()
    return global.crashed_debris_items
  end,
  set_debris_items = function(map)
    global.crashed_debris_items = map or error("Remote call parameter to freeplay set respawn items can't be nil.")
  end,
  get_ship_parts = function()
    return global.crashed_ship_parts
  end,
  set_ship_parts = function(parts)
    global.crashed_ship_parts = parts or error("Remote call parameter to freeplay set ship parts can't be nil.")
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

  if (_G["add_Commands"] ~= nil) then
    add_Commands()
  end

  if is_debug() then
    global.skip_intro = true
    global.disable_crashsite = true
  end

end

freeplay.on_load = function()
  -- add_Commands()
  if (_G["add_Commands"] ~= nil) then
    add_Commands()
  end
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

function equipPlayer(player)
  player.insert {
      name = "power-armor-mk2",
      count = 1
  }
  local p_armor = player.get_inventory(5)[1].grid
  p_armor.put({
      name = "fusion-reactor-equipment"
  })
  p_armor.put({
      name = "fusion-reactor-equipment"
  })
  p_armor.put({
      name = "fusion-reactor-equipment"
  })
  p_armor.put({
      name = "fusion-reactor-equipment"
  })

  p_armor.put({
      name = "personal-laser-defense-equipment"
  })
  p_armor.put({
      name = "personal-laser-defense-equipment"
  })
  p_armor.put({
      name = "personal-laser-defense-equipment"
  })
  p_armor.put({
      name = "personal-laser-defense-equipment"
  })
  p_armor.put({
      name = "personal-laser-defense-equipment"
  })
  p_armor.put({
      name = "personal-laser-defense-equipment"
  })

  p_armor.put({
      name = "night-vision-equipment"
  })  
  p_armor.put({
      name = "battery-mk2-equipment"
  })
  p_armor.put({
      name = "battery-mk2-equipment"
  })
  p_armor.put({
      name = "battery-mk2-equipment"
  })
  p_armor.put({
      name = "battery-mk2-equipment"
  })
  p_armor.put({
      name = "battery-mk2-equipment"
  })
  p_armor.put({
      name = "battery-mk2-equipment"
  })

  player.insert {
      name = "submachine-gun",
      count = 1
  }
  player.insert {
      name = "uranium-rounds-magazine",
      count = 1000
  }
  player.insert {
      name = "rocket-launcher",
      count = 1
  }
  player.insert {
      name = "atomic-bomb",
      count = 5
  }
  player.insert {
    name = "loader",
    count = 50
  }
  player.insert {
    name = "fast-loader",
    count = 50
  }
  player.insert {
    name = "express-loader",
    count = 50
  }
end

function pandorasBox(player)

  player.insert {
      name = "rocket-launcher",
      count = 1
  }

  player.insert {
      name = "atomic-bomb",
      count = 5
  }
end

function linePlot(tiles, x1, y1, x2, y2, tileToFillWith)
  ix = (x2 - x1) / abs(x2 - x1)
  iy = (y2 - y1) / abs(y2 - y1)

  for y = x, pos.y + sizeY do
      table.insert(tiles, {
          name = tileToFillWith,
          position = {x, y}
      })
  end
end

function block(ix, iy, fx, fy, dx, dy, ox, oy, block_function)
  for x = ix, fx, dx  do
    for y = iy, fy, dy do
      block_function(x+ox, y+oy)
    end
  end
end

function entityBlock(player, entity_name, ix, iy, fx, fy, dx, dy, ox, oy, ent_amount, minable, destructible, is_validpos, process_entity)
  
  if (dx == nil) then
    dx = 1
  end

  if (dy == nil) then
    dy = 1
  end

  if (ox == nil) then
    ox = 0
  end

  if (oy == nil) then
    oy = 0
  end

  if (ent_amount == nil) then
    ent_amount = 1
  end

  local tiles = {}
  block(ix, iy, fx, fy, dx, dy, ox, oy, function(x,y)        
            if (is_validpos==nil) or is_validpos(i,j) then
              placed_entity = player.surface.create_entity({
                  name = entity_name,
                  force = player.force,
                  amount = ent_amount,
                  position = {x,y}
              })
              if (minable ~= nil) then
                placed_entity.minable = minable
              end
              if (destructible ~= nil) then
                placed_entity.destructible = destructible
              end
              if (process_entity~=nil) then
                process_entity(placed_entity)
              end
            end
        end
      )
  player.surface.set_tiles(tiles)
 
end

function placeEntityMatrix(player, entity_name, ii, ij, fi, fj, mi, mj, offx, offy, ent_amount, minable, destructible, is_validpos, process_entity)
  
  if (offx == nil) then
    offx = 0
  end

  if (offy == nil) then
    offy = 0
  end

  if (mi == nil) then
    mi = 1
  end

  if (mj == nil) then
    mj = 1
  end

  if (ent_amount == nil) then
    ent_amount = 1
  end

  for i=ii, fi do
    for j=ij, fj do        
        if (is_validpos==nil) or is_validpos(i,j) then
            placed_entity = player.surface.create_entity({
                name = entity_name,
                force = player.force,
                amount = ent_amount,
                position = {player.position.x+i*mi+offx, player.position.y +j*mj+offy}
            })
            if (minable ~= nil) then
              placed_entity.minable = minable
            end
            if (destructible ~= nil) then
              placed_entity.destructible = destructible
            end
            if (process_entity~=nil) then
              process_entity(placed_entity)
            end
        end
    end
  end
end

function entityRing(player, entity_name, size, thichness, egap, cgap, offx, offy, ent_amount, minable, destructible, process_entity)
  
  if (entity_name == nil) then
    entity_name = "iron-ore"
  end

  if (egap == nil) then
    egap = 1
  end

  if (cgap == nil) then
    cgap = 0
  end

  local tiles = {}
  local pos = player.position
  
  entityBlock(player, entity_name, pos.x - size / 2 + cgap, pos.y - size / 2 - thichness, pos.x + size / 2 - cgap, pos.y - size / 2, egap, egap, offx, offy, ent_amount, minable, destructible, nil, process_entity)
  entityBlock(player, entity_name, pos.x + size / 2, pos.y - size / 2 + cgap, pos.x + size / 2 + thichness, pos.y + size / 2 - cgap, egap, egap, offx, offy, ent_amount, minable, destructible, nil, process_entity)
  entityBlock(player, entity_name, pos.x - size / 2 + cgap, pos.y + size / 2, pos.x + size / 2 - cgap, pos.y + size / 2 + thichness, egap, egap, offx, offy, ent_amount, minable, destructible, nil, process_entity)
  entityBlock(player, entity_name, pos.x - size / 2 - thichness, pos.y - size / 2 + cgap,pos.x - size / 2,  pos.y + size / 2 - cgap, egap, egap, offx, offy, ent_amount, minable, destructible, nil, process_entity)

  player.surface.set_tiles(tiles)
end

function mmzPrint(player, tileToFillWith)

  base_factor=7
  substation_tiles=18
  rim_size=substation_tiles*base_factor
  base_size=rim_size+18

  player.teleport {player.position.x - base_size-1, player.position.y - base_size-1}
  waterFillArea(player, base_size, base_size, base_size+1, base_size+1)
  landFillArea(player, base_size, base_size, base_size+1, base_size+1, "dirt-7")
  player.teleport {player.position.x + base_size+1, player.position.y + base_size+1}
  -- tileRing(player, base_size*2, 1, "water", base_factor)
  
  entityRing(player, "rock-huge", base_size*2+4, 0, 1, 0, 0, 0, 1, true, false)

  --Substations  
  placeEntityMatrix(player,"substation", -base_factor, -base_factor, base_factor, base_factor, substation_tiles,substation_tiles, 0, 0, 1, false, false ,
                    function(i,j)
                       return i~=0 or j~=0 
                      end
                   )

  entityRing(player, "tree-01", rim_size*2+substation_tiles+2, 6, 1, 20, 0, 0, 1, false, false)
  entityRing(player, "laser-turret", rim_size*2+substation_tiles, 0, 2, 20, 0, 0, 1, false, false)
  
  entityRing(player, "solar-panel", rim_size*2,substation_tiles/2, 1, 11, 0, 0, 1, false, false)
  entityRing(player, "accumulator", rim_size*2-substation_tiles-6, substation_tiles/2, 1, 12, 0, 0, 1, false, false)
  -- entityRing(player, "solar-panel", rim_size*2,substation_tiles/2, 3, 11, 0, 0, 1, false, false)
  -- entityRing(player, "accumulator", rim_size*2-substation_tiles, substation_tiles/3, 2, 12, 0, 0, 1, false, false)
  
  entityRing(player, "iron-ore", rim_size*2-2*substation_tiles-9, 4, 1, 15, 0, 0, 141, false, false)
  -- entityRing(player, "electric-mining-drill", rim_size*2-2*substation_tiles-4, 0, 3, 15, 0, 0, 1, true, false)
  entityRing(player, "electric-furnace", rim_size*2-2*substation_tiles-11, 0, 3, 15, 0, 0, 1, false, false)  
  entityRing(player, "iron-ore", rim_size*2-2*substation_tiles-21, 4, 1, 9, 0, 0, 141, false, false)
  -- entityRing(player, "electric-mining-drill", rim_size*2-2*substation_tiles-16, 0, 3, 9, 0, 0, 1, true, false)

  entityRing(player, "coal", rim_size*2-3*substation_tiles-33, 6, 1, 15, 0, 0, 211, false, false)

  entityRing(player, "copper-ore", rim_size*2-5*substation_tiles-28, 4, 1, 15, 0, 0, 143, false, false)
  entityRing(player, "electric-furnace", rim_size*2-5*substation_tiles-30, 0, 3, 15, 0, 0, 1, false, false)
  entityRing(player, "copper-ore", rim_size*2-5*substation_tiles-40, 4, 1, 9, 0, 0, 143, false, false)
  
  entityRing(player, "stone", rim_size*2-7*substation_tiles-28, 4, 1, 15, 0, 0, 73, false, false)
  entityRing(player, "electric-furnace", rim_size*2-7*substation_tiles-30, 0, 3, 15, 0, 0, 1, false, false)
  entityRing(player, "stone", rim_size*2-7*substation_tiles-40, 4, 1, 9, 0, 0, 73, false, false)

  entityRing(player, "assembling-machine-3", rim_size*2-9*substation_tiles-30, 0, 8, 15, 0, 0, 1, false, false)

  entityRing(player, "infinity-pipe", rim_size*2-11*substation_tiles-11, 0, 8, 6, 0, 0, 1, false, false, 
              function(entity) 
                entity.set_infinity_pipe_filter(
                  {
                    name="water",
                    percentage=1
                  }
                )
                entity.operable=false 
              end
            )
  
  entityRing(player, "steel-chest", rim_size*2-11*substation_tiles-22, 0, 1, 12, 0, 0, 1, false, false) 

  beltcount=0
  rotc={}
  rotc[0]=0
  rotc[1]=-1
  rotc[2]=1
  rotc[3]=2
  entityBlock(player, "express-transport-belt", -1, -1, 0, 0, 1, 1, 1, 0, 1, false, false, nil,
              function(entity)
                for i=0, rotc[beltcount] do
                  entity.rotate()
                end
                entity.rotatable=false
                beltcount=(beltcount+1)%4
              end
             )

  -- Artillery
  -- entityRing(player, "artillery-turret", rim_size*2+8, 0, 4, 10, 0, 0, 1, false, false,
  --             function(entity)
  --               -- entity.damage_dealt = 10000
  --                entity.get_output_inventory().insert {
  --                   name = "artillery-shell",
  --                   count = 200
  --               }
  --             end
  --           )
  
  local tiles = {}
  local pos = player.position

  pos.y = pos.y - 2

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
end

function mmzPrintCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then
      -- for i=1,100 do
      mmzPrint(player, "out-of-map")
      -- end		
  end
end

function tileBlock(player, ix, fx, iy, fy, dx, dy, ox, oy, tileToFillWith)
  local tiles = {}
  block(ix, iy, fx, fy, dx, dy, ox, oy, function(x,y)        
          local t = player.surface.get_tile(x, y)
          table.insert(tiles, {
              name = tileToFillWith,
              position = {x, y}
          })
        end
      )
  player.surface.set_tiles(tiles)
 
end

function tileRing(player, size, thichness, tileToFillWith, cgap)
  
  if (tileToFillWith == nil) then
      tileToFillWith = "water"
  end

  if (cgap == nil) then
    cgap = 0
  end

  local tiles = {}
  local pos = player.position
  
  tileBlock(player, pos.x - size / 2 + cgap, pos.x + size / 2 - cgap, pos.y - size / 2 - thichness, pos.y - size / 2, 1, 1, 0, 0, tileToFillWith )
  tileBlock(player, pos.x + size / 2, pos.x + size / 2 + thichness, pos.y - size / 2 + cgap, pos.y + size / 2 - cgap, 1, 1, 0, 0, tileToFillWith )
  tileBlock(player, pos.x - size / 2 + cgap, pos.x + size / 2 - cgap, pos.y + size / 2, pos.y + size / 2 + thichness, 1, 1, 0, 0, tileToFillWith )
  tileBlock(player, pos.x - size / 2 - thichness, pos.x - size / 2, pos.y - size / 2 + cgap, pos.y + size / 2 - cgap, 1, 1, 0, 0, tileToFillWith )

  player.surface.set_tiles(tiles)
end

function landFillArea(player, sizeX, sizeY, offsetX, offsetY, tileToFillWith)
  local tiles = {}
  local pos = player.position

  if (sizeX == nil) then
      sizeX = 200
  end
  if (sizeY == nil) then
      sizeY = 200
  end

  if (offsetX == nil) then
      offsetX = 0
  end
  if (offsetY == nil) then
      offsetY = 0
  end

  if (tileToFillWith == nil) then
      tileToFillWith = "grass-1"
  end

  pos.x = pos.x + offsetX
  pos.y = pos.y + offsetY

  for x = pos.x - sizeX, pos.x + sizeX do
      for y = pos.y - sizeY, pos.y + sizeY do
          local t = player.surface.get_tile(x, y)
          -- if t.name == "water" or t.name == "deepwater" then
          table.insert(tiles, {
              name = tileToFillWith,
              position = {x, y}
          })
          -- end
      end
  end
  player.surface.set_tiles(tiles)
end

function waterFillArea(player, sizeX, sizeY, offsetX, offsetY)
  local tiles = {}
  local pos = player.position

  if (sizeX == nil) then
      sizeX = 200
  end
  if (sizeY == nil) then
      sizeY = 200
  end

  if (offsetX == nil) then
      offsetX = 0
  end
  if (offsetY == nil) then
      offsetY = 0
  end

  pos.x = pos.x + offsetX
  pos.y = pos.y + offsetY

  for x = pos.x - sizeX, pos.x + sizeX do
      for y = pos.y - sizeY, pos.y + sizeY do
          local t = player.surface.get_tile(x, y)
          table.insert(tiles, {
              name = "water",
              position = {x, y}
          })
      end
  end
  player.surface.set_tiles(tiles)
end

function removeDecoratives(command)
  local player = game.players[command.player_index]
  if (player.admin == true) then
      player.surface.destroy_decoratives {}
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

      if (player.admin == true) then
          ghostEntities[i].silent_revive()      
      elseif ((inventoryContents[ghostName] ~= nil) and (inventoryContents[ghostName] > 0)) then
          ghostEntities[i].silent_revive()
          inventoryContents[ghostName] = inventoryContents[ghostName] - 1;
          playerInventory.remove {
              name = ghostName,
              count = 1
          }          
      end
  end
end

function deconstructCommand(command)
  local player = game.players[command.player_index]
  local deconstructRadius = 200

  if (command.parameter ~= nil) then
      deconstructRadius = command.parameter
  end

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
              local t = player.surface.get_tile(proximityTag.position.x, proximityTag.position.y)
              if t.name ~= "water" and t.name ~= "deepwater" then
                  player.teleport {proximityTag.position.x, proximityTag.position.y}
                  game.print(player.name .. " has teleported to the the custom tag " .. command.parameter)
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

      if (command.parameter == nil) then
          size = 550
      end

      tileRing(player, size, 3)
  end
end

function protectionRingCommand(command)

  local player = game.players[command.player_index]
  if (player.admin == true) then
      size = command.parameter

      if (command.parameter == nil) then
          size = 550
      end

      tileRing(player, size, 1, "out-of-map")
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

  if (density == nil) then
      density = 10000
  end

  if (size == nil) then
      size = 140
  end

  local randomX = paramPlayer.position.x + size + 10
  local randomY = paramPlayer.position.y + size + 10

  waterFillArea(paramPlayer, 2 * size + 16, 2 * size + 16, size + 10, size + 10)
  landFillArea(paramPlayer, size + 8, size + 8, size + 10, size + 10)

  for y = -size, size do
      for x = -patchOffset - size, -patchOffset - size / 2 do
          if surface.get_tile(randomX + x, randomY + y).collides_with("ground-tile") then
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
          if surface.get_tile(randomX + x, randomY + y).collides_with("ground-tile") then
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
          if surface.get_tile(randomX + x, randomY + y).collides_with("ground-tile") then
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
          if surface.get_tile(randomX + x, randomY + y).collides_with("ground-tile") then
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
              position = {randomX + size + 10 + 1 + x * 7, randomY + size + 10 + 1 + y * 7}
          })
      end
  end

  waterFillArea(paramPlayer, size / 2, size / 2, -size / 2 - 10, -size / 2 - 10)
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
  end
end

function generateResourcesCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then
      generateResources(player, 3000, 80)
  end
end

function aegisCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then

      local miningSpeedIncrease = 10000
      local craftingSpeedIncrease = 10000

      if (global["_aegis_on"]) then
          global["_aegis_on"] = false
          player.force.manual_mining_speed_modifier = player.force.manual_mining_speed_modifier - miningSpeedIncrease
          player.force.manual_crafting_speed_modifier = player.force.manual_crafting_speed_modifier -
                                                            craftingSpeedIncrease
      else
          global["_aegis_on"] = true
          player.force.manual_mining_speed_modifier = player.force.manual_mining_speed_modifier + miningSpeedIncrease
          player.force.manual_crafting_speed_modifier = player.force.manual_crafting_speed_modifier +
                                                            craftingSpeedIncrease
      end
  end
end

function enableAllTechCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then
      -- for i=1,100 do
      player.force.research_all_technologies()
      -- end		
  end
end

function blackDeathCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then
      local surface = player.surface
      for key, entity in pairs(surface.find_entities_filtered(
                                   {
              force = "enemy"
          })) do
          entity.destroy()
      end
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

      player.force.chart(player.surface, {{player.position.x - chartSize, player.position.y - chartSize},
                                          {player.position.x + chartSize, player.position.y + chartSize}})
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
  end
end

function toggleCheatCommand(event)
  local player = game.players[event.player_index]
  if (player.admin == true) then
      player.cheat_mode = not player.cheat_mode
  end
end

function add_Commands()
  commands.add_command("teleport",
      "Use /teleport to teleport to main base or /teleport <SurfaceName> to teleport to a surface or /teleport <CustomTagText> to go to a custom tag location",
      teleportCommand)
  commands.add_command("reviveGhosts",
      "[Command]: Revives ghosts in the area near player using items from player inventory.", reviveCommand)
  commands.add_command("deconstruct",
      "[Command]: Destroys items marked for deconstruction and adds to player inventory. ", deconstructCommand)
  commands.add_command("removeDecoratives", "[Command]: destroys all decoratives from the surface. ",
      removeDecoratives)
  commands.add_command("waterRing", "[Admin Command]:Creates a moot of specified size.", waterRingCommand)
  commands.add_command("protectionRing", "[Admin Command]:Creates a out of map protection ring of specified size.",
      protectionRingCommand)
  commands.add_command("landFill", "[Admin Command]: Land fills an area.", landFillCommand)
  commands.add_command("waterFill", "[Admin Command]: Water fills an area.", waterFillCommand)
  commands.add_command("generateResources", "[Admin Command]: Generates resources in an area.",
      generateResourcesCommand)
  commands.add_command("blackDeath", "[Admin Command]: Kills all enemy entity on explored area.", blackDeathCommand)
  commands.add_command("marcoPolo", "[Admin Command]: Explores a large area.", marcoPoloCommand)
  commands.add_command("aegis", "[Admin Command]: Unlocks all technologies.", aegisCommand)
  commands.add_command("enableAllTech", "[Admin Command]: Unlocks all technologies.", enableAllTechCommand)

  commands.add_command("mmzPrint", "[Admin Command]: Creates a safe zone with MMZ print.", mmzPrintCommand)
  commands.add_command("equipPlayer", "[Admin Command]:Gives player equipments.", equipPlayerCommand)
  commands.add_command("pandorasBox", "[Admin Command]:Gives player nuke.", pandorasBoxCommand)
  commands.add_command("toggleCheatMode", "[User Command]: Cheat mode toggling.", toggleCheatCommand)
end

return freeplay
