-- Modify various entity parameters for increased performance
-- Character modifications
data.raw["character"]["character"].max_health = 1000
data.raw["character"]["character"].healing_per_tick = 1
data.raw["character"]["character"].collision_box = {{0, 0}, {0, 0}}
data.raw["character"]["character"].crafting_categories = {
    "crafting", "basic-crafting", "advanced-crafting", "smelting",
    "centrifuging"
}
data.raw["character"]["character"].inventory_size = 500
data.raw["character"]["character"].build_distance = 5000
data.raw["character"]["character"].drop_item_distance = 5000
data.raw["character"]["character"].reach_distance = 5000
-- data.raw["character"]["character"].item_pickup_distance = 10
-- data.raw["character"]["character"].loot_pickup_distance = 10
-- data.raw["character"]["character"].enter_vehicle_distance = 10
data.raw["character"]["character"].reach_resource_distance = 5000
data.raw["character"]["character"].ticks_to_stay_in_combat = 100
data.raw["character"]["character"].running_speed = 0.6
data.raw["character"]["character"].mining_speed = 10000
data.raw["character"]["character"].crafting_speed = 1000

-- -- Modify rocks
-- data.raw["huge-rock"].minable=
--     {
--       mining_particle = "stone-particle",
--       mining_time = 3,
--       results =
--       {
--         {type = "item", name = "iron-ore", amount_min = 96, amount_max = 200},
--         {type = "item", name = "copper-ore", amount_min = 96, amount_max = 200},
--         {type = "item", name = "stone", amount_min = 96, amount_max = 200},
--         {type = "item", name = "coal", amount_min = 96, amount_max = 200}
--       }
--     }
-- data.raw["big-rock"].minable=
--     {
--       mining_particle = "stone-particle",
--       mining_time = 3,
--       results =
--       {
--         {type = "item", name = "iron-ore", amount_min = 48, amount_max = 100},
--         {type = "item", name = "copper-ore", amount_min = 48, amount_max = 100},
--         {type = "item", name = "stone", amount_min = 48, amount_max = 100},
--         {type = "item", name = "coal", amount_min = 48, amount_max = 100}
--       }
--     }

-- Lab modifications
data.raw["lab"]["lab"].energy_usage = tostring(
                                          tonumber(string.match(
                                                       data.raw["lab"]["lab"]
                                                           .energy_usage, "%d+")) *
                                              10) .. "kW"
data.raw["lab"]["lab"].researching_speed =
    data.raw["lab"]["lab"].researching_speed * 10


-- chest modifications
local chest_entities={"wooden-chest","iron-chest","steel-chest"}
for _, chest_name in pairs(chest_entities) do
    data.raw["container"][chest_name].inventory_size =
        data.raw["container"][chest_name].inventory_size * 10
end


-- Robot modifications

-- For all data.raw entities which have suffix "-robot", increase speed and
-- payload size, and adjust energy consumption and capacity by 10 times.
-- robot_entities = {"construction-robot", "logistic-robot"}
-- for _, robot_name in pairs(robot_entities) do
--     data.raw[robot_name][robot_name].speed =
--         data.raw[robot_name][robot_name].speed * 10
--     data.raw[robot_name][robot_name].max_payload_size =
--         data.raw[robot_name][robot_name].max_payload_size * 10
--     data.raw[robot_name][robot_name].energy_per_move = tostring(tonumber(
--                                                                     string.match(
--                                                                         data.raw[robot_name][robot_name]
--                                                                             .energy_per_move,
--                                                                         "%d+")) *
--                                                                     10) .. "kJ"
--     data.raw[robot_name][robot_name].max_energy = tostring(tonumber(
--                                                                string.match(
--                                                                    data.raw[robot_name][robot_name]
--                                                                        .max_energy,
--                                                                    "%d+")) * 10) ..
--                                                       "MJ"
--     data.raw[robot_name][robot_name].speed_multiplier_when_out_of_energy =
--         data.raw[robot_name][robot_name].speed_multiplier_when_out_of_energy
-- end
-- data.raw["construction-robot"]["construction-robot"].speed = 0.18
-- data.raw["construction-robot"]["construction-robot"].max_payload_size = 3
-- data.raw["construction-robot"]["construction-robot"].energy_per_move = "15kJ"
-- data.raw["construction-robot"]["construction-robot"].max_energy = "4.5MJ"
-- data.raw["construction-robot"]["construction-robot"]
--     .speed_multiplier_when_out_of_energy = 0.33

-- data.raw["logistic-robot"]["logistic-robot"].speed = 0.15
-- data.raw["logistic-robot"]["logistic-robot"].max_payload_size = 3
-- data.raw["logistic-robot"]["logistic-robot"].energy_per_move = "15kJ"
-- data.raw["logistic-robot"]["logistic-robot"].max_energy = "4.5MJ"
-- data.raw["logistic-robot"]["logistic-robot"].speed_multiplier_when_out_of_energy =
--     0.33

-- data.raw["ammo-turret"]["gun-turret"].rotation_speed = 0.045
-- data.raw["ammo-turret"]["gun-turret"].preparing_speed = 0.24
-- data.raw["ammo-turret"]["gun-turret"].folding_speed = 0.24
-- data.raw["ammo-turret"]["gun-turret"].automated_ammo_count = 30
-- data.raw["ammo-turret"]["gun-turret"].attacking_speed = 1.5
-- -- data.raw["ammo-turret"]["gun-turret"].call_for_help_radius = 120
-- data.raw["ammo-turret"]["gun-turret"]["attack_parameters"].range = 54

-- data.raw["electric-turret"]["laser-turret"].rotation_speed = 0.03
-- data.raw["electric-turret"]["laser-turret"].preparing_speed = 0.15
-- data.raw["electric-turret"]["laser-turret"].folding_speed = 0.15
-- -- data.raw["electric-turret"]["laser-turret"].call_for_help_radius = 120
-- data.raw["electric-turret"]["laser-turret"]["attack_parameters"].range = 72

-- Mining drill modifications

mining_drill_entities = {
    "electric-mining-drill", "burner-mining-drill", "pumpjack"
}

-- Remove pollution for all mining entities
for _, drill_name in pairs(mining_drill_entities) do
    if data.raw["mining-drill"][drill_name].energy_source.emissions_per_minute[
        "pollution"] ~= nil then
        data.raw["mining-drill"][drill_name].energy_source.emissions_per_minute[
            "pollution"] = 0
    end
end


-- For all drill entities, create new entity types which are copied from base but have 15x mining speed and energy consumption
-- Recipe cost also increase by 15 times
for _, drill_name in pairs(mining_drill_entities) do
    local base_drill = data.raw["mining-drill"][drill_name]
    local new_drill = table.deepcopy(base_drill)
    new_drill.name = drill_name .. "-mmz"
    new_drill.minable.result = drill_name .. "-mmz"
    new_drill.mining_speed = base_drill.mining_speed * 15
    new_drill.energy_usage = tostring(tonumber(string.match(
                                                   base_drill.energy_usage,
                                                   "%d+")) * 15) .. "kW"
    -- If energy_source has fuel_inventory_size, increase it by 15 times
    if new_drill.energy_source.fuel_inventory_size ~= nil then
        new_drill.energy_source.fuel_inventory_size =
            base_drill.energy_source.fuel_inventory_size * 15
    end

    -- Increase pollution by 15 times if applicable
    if new_drill.energy_source.emissions_per_minute["pollution"] ~= nil then
        new_drill.energy_source.emissions_per_minute["pollution"] =
            base_drill.energy_source.emissions_per_minute["pollution"] * 0 --15
    end

    new_drill.resource_searching_radius =
        base_drill.resource_searching_radius * 15
    data:extend({new_drill})

    -- Also create new item for the modded drill
    local base_item = data.raw["item"][drill_name]
    local new_item = table.deepcopy(base_item)
    new_item.name = drill_name .. "-mmz"
    new_item.place_result = drill_name .. "-mmz"
    data:extend({new_item})

    -- Create new recipe for the modded drill
    local base_recipe = data.raw["recipe"][drill_name]
    local new_recipe = table.deepcopy(base_recipe)
    new_recipe.name = drill_name .. "-mmz"
    new_recipe.enabled = true
    new_recipe.ingredients = base_recipe.ingredients
    new_recipe.results[1]["name"] = drill_name .. "-mmz"
    -- Set the recipe ingredient to be 15 times the base item
    new_recipe.ingredients = {{type = "item", name = drill_name, amount = 15}}

    data:extend({new_recipe})
end

-- For all data.raw entities which are mining drills, increase mining speed,
-- energy usage, resource searching radius per minute by 10 times.
-- for _, drill_name in pairs(mining_drill_entities) do
--     data.raw["mining-drill"][drill_name].mining_speed =
--         data.raw["mining-drill"][drill_name].mining_speed * 15
--     data.raw["mining-drill"][drill_name].energy_usage = tostring(tonumber(
--                                                                      string.match(
--                                                                          data.raw["mining-drill"][drill_name]
--                                                                              .energy_usage,
--                                                                          "%d+")) *
--                                                                      15) .. "kW"
--     data.raw["mining-drill"][drill_name].resource_searching_radius =
--         data.raw["mining-drill"][drill_name].resource_searching_radius * 10
-- end

-- Furnace modifications
furnace_entities = {"stone-furnace", "steel-furnace", "electric-furnace"}

-- Remove pollution for all furnace entities
for _, furnace_name in pairs(furnace_entities) do
    if data.raw["furnace"][furnace_name].energy_source.emissions_per_minute[
        "pollution"] ~= nil then
        data.raw["furnace"][furnace_name].energy_source.emissions_per_minute[
            "pollution"] = 0
    end
end

-- Create new furnace entities with increased crafting speed and energy usage
for _, furnace_name in pairs(furnace_entities) do
    local base_furnace = data.raw["furnace"][furnace_name]
    local new_furnace = table.deepcopy(base_furnace)
    new_furnace.name = furnace_name .. "-mmz"
    new_furnace.minable.result = furnace_name .. "-mmz"
    new_furnace.crafting_speed = base_furnace.crafting_speed * 24
    new_furnace.energy_usage = tostring(tonumber(string.match(
                                                     base_furnace.energy_usage,
                                                     "%d+")) * 24) .. "kW"

    -- If energy_source has fuel_inventory_size, increase it by 24 times   
    if new_furnace.energy_source.fuel_inventory_size ~= nil then
        new_furnace.energy_source.fuel_inventory_size =
            base_furnace.energy_source.fuel_inventory_size * 24
    end

    -- Increase pollution by 24 times if applicable
    if new_furnace.energy_source.emissions_per_minute["pollution"] ~= nil then
        new_furnace.energy_source.emissions_per_minute["pollution"] =
            base_furnace.energy_source.emissions_per_minute["pollution"] * 0 --24
    end

    data:extend({new_furnace})

    -- Also create new item for the modded furnace
    local base_item = data.raw["item"][furnace_name]
    local new_item = table.deepcopy(base_item)
    new_item.name = furnace_name .. "-mmz"
    new_item.place_result = furnace_name .. "-mmz"
    data:extend({new_item})

    -- Create new recipe for the modded furnace
    local base_recipe = data.raw["recipe"][furnace_name]
    local new_recipe = table.deepcopy(base_recipe)
    new_recipe.name = furnace_name .. "-mmz"
    new_recipe.enabled = true
    new_recipe.ingredients = base_recipe.ingredients
    new_recipe.results[1]["name"] = furnace_name .. "-mmz"
    -- Set the recipe ingredient to be 24 times the base item
    new_recipe.ingredients = {{type = "item", name = furnace_name, amount = 24}}
    data:extend({new_recipe})
end

-- data.raw["furnace"]["stone-furnace"].crafting_speed = 3
-- data.raw["furnace"]["stone-furnace"].energy_usage = "270kW"

-- data.raw["furnace"]["steel-furnace"].crafting_speed = 6
-- data.raw["furnace"]["steel-furnace"].energy_usage = "270kW"

-- data.raw["furnace"]["electric-furnace"].crafting_speed = 6
-- data.raw["furnace"]["electric-furnace"].energy_usage = "540kW"

-- Assembling machine modifications
assembling_machine_entities = {
    "assembling-machine-1", "assembling-machine-2", "assembling-machine-3",
    "oil-refinery", "chemical-plant", "centrifuge"
}

-- Remove pollution for all assembling machine entities
for _, machine_name in pairs(assembling_machine_entities) do
    if data.raw["assembling-machine"][machine_name].energy_source.emissions_per_minute[
        "pollution"] ~= nil then
        data.raw["assembling-machine"][machine_name].energy_source.emissions_per_minute[
            "pollution"] = 0
    end
end

-- Create new assembling machine entities with increased crafting speed and energy usage
for _, machine_name in pairs(assembling_machine_entities) do
    local base_machine = data.raw["assembling-machine"][machine_name]
    local new_machine = table.deepcopy(base_machine)
    new_machine.name = machine_name .. "-mmz"
    new_machine.minable.result = machine_name .. "-mmz"
    new_machine.crafting_speed = base_machine.crafting_speed * 15
    new_machine.energy_usage = tostring(tonumber(string.match(
                                                     base_machine.energy_usage,
                                                     "%d+")) * 15) .. "kW"

    -- Increase pollution by 15 times if applicable
    if new_machine.energy_source.emissions_per_minute["pollution"] ~= nil then
        new_machine.energy_source.emissions_per_minute["pollution"] =
            base_machine.energy_source.emissions_per_minute["pollution"] * 0 --15
    end
       
    data:extend({new_machine})

    -- Also create new item for the modded assembling machine
    local base_item = data.raw["item"][machine_name]
    local new_item = table.deepcopy(base_item)
    new_item.name = machine_name .. "-mmz"
    new_item.place_result = machine_name .. "-mmz"
    data:extend({new_item})

    -- Create new recipe for the modded assembling machine
    local base_recipe = data.raw["recipe"][machine_name]
    local new_recipe = table.deepcopy(base_recipe)
    new_recipe.name = machine_name .. "-mmz"
    new_recipe.enabled = true
    new_recipe.ingredients = base_recipe.ingredients
    new_recipe.results[1]["name"] = machine_name .. "-mmz"
    -- Set the recipe ingredient to be 15 times the base item
    new_recipe.ingredients = {
        {type = "item", name = machine_name, amount = 15}
    }
    data:extend({new_recipe})
end

-- Create a solar-panel-mmz which is 15 time more efficient
-- Also make the solar panel store electricity like an accumulator
local base_solar_panel = data.raw["solar-panel"]["solar-panel"]
local new_solar_panel = table.deepcopy(base_solar_panel)
new_solar_panel.name = "solar-panel-mmz"
new_solar_panel.minable.result = "solar-panel-mmz"
new_solar_panel.production = tostring(tonumber(string.match(
                                                    base_solar_panel.production,
                                                    "%d+")) * 100) .. "kW"
data:extend({new_solar_panel})

-- Also create new item for the modded solar panel
local base_item = data.raw["item"]["solar-panel"]
local new_item = table.deepcopy(base_item)
new_item.name = "solar-panel-mmz"
new_item.place_result = "solar-panel-mmz"
data:extend({new_item})

-- Create new recipe for the modded solar panel
local base_recipe = data.raw["recipe"]["solar-panel"]
local new_recipe = table.deepcopy(base_recipe)
new_recipe.name = "solar-panel-mmz"
new_recipe.enabled = true
new_recipe.ingredients = base_recipe.ingredients
new_recipe.results[1]["name"] = "solar-panel-mmz"
-- Set the recipe ingredient to be 15 times the base item
new_recipe.ingredients = {
    {type = "item", name = "solar-panel", amount = 100}
}
data:extend({new_recipe})

-- Create an accumulator-mmz which is 15 time more efficient
local base_accumulator = data.raw["accumulator"]["accumulator"]
local new_accumulator = table.deepcopy(base_accumulator)
new_accumulator.name = "accumulator-mmz"
new_accumulator.minable.result = "accumulator-mmz"
new_accumulator.energy_source.buffer_capacity =  tostring(tonumber(
                                                        string.match(
                                                            base_accumulator.energy_source
                                                                .buffer_capacity,
                                                            "%d+")) * 84) .. "MJ"
new_accumulator.energy_source.input_flow_limit = tostring(tonumber(
                                                       string.match(
                                                           base_accumulator.energy_source
                                                               .input_flow_limit,
                                                           "%d+")) * 84) .. "kW"
new_accumulator.energy_source.output_flow_limit = tostring(tonumber(
                                                        string.match(
                                                            base_accumulator.energy_source
                                                                .output_flow_limit,
                                                            "%d+")) * 84) .. "kW"
data:extend({new_accumulator})
-- Also create new item for the modded accumulator
local base_item = data.raw["item"]["accumulator"]
local new_item = table.deepcopy(base_item)
new_item.name = "accumulator-mmz"
new_item.place_result = "accumulator-mmz"
data:extend({new_item})
-- Create new recipe for the modded accumulator but the recipe ingredients is same as solar-panel
local base_recipe = data.raw["recipe"]["accumulator"]
local new_recipe = table.deepcopy(base_recipe)
new_recipe.name = "accumulator-mmz"
new_recipe.enabled = true
new_recipe.ingredients = base_recipe.ingredients
new_recipe.results[1]["name"] = "accumulator-mmz"
-- Set the recipe ingredient to be 15 times the base item
new_recipe.ingredients = {
    {type = "item", name = "solar-panel", amount = 84}
}
data:extend({new_recipe})


-- data.raw["assembling-machine"]["assembling-machine-1"].crafting_speed = 1.5
-- data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = "225kW"

-- data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories = {
--     "smelting", "crafting", "basic-crafting", "advanced-crafting",
--     "centrifuging"
-- }

-- data.raw["assembling-machine"]["assembling-machine-2"].crafting_speed = 2.25
-- data.raw["assembling-machine"]["assembling-machine-2"].energy_usage = "450kW"

-- data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories = {
--     "smelting", "basic-crafting", "crafting", "advanced-crafting",
--     "crafting-with-fluid", "centrifuging"
-- }

-- data.raw["assembling-machine"]["assembling-machine-3"].crafting_speed = 3.75
-- data.raw["assembling-machine"]["assembling-machine-3"].energy_usage = "1125kW"

-- data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories = {
--     "smelting", "basic-crafting", "crafting", "advanced-crafting",
--     "crafting-with-fluid", "centrifuging"
-- }

-- data.raw["assembling-machine"]["oil-refinery"].crafting_speed = 3
-- data.raw["assembling-machine"]["oil-refinery"].energy_usage = "1260kW"

-- data.raw["assembling-machine"]["chemical-plant"].crafting_speed = 3
-- data.raw["assembling-machine"]["chemical-plant"].energy_usage = "630kW"

-- data.raw["assembling-machine"]["centrifuge"].crafting_speed = 3
-- data.raw["assembling-machine"]["centrifuge"].energy_usage = "1050kW"

-- Power generation modifications
-- Steam engine and steam turbine maximum temperatures increased by 10 times
-- data.raw["generator"]["steam-engine"].maximum_temperature =
--     data.raw["generator"]["steam-engine"].maximum_temperature * 10
-- data.raw["generator"]["steam-turbine"].maximum_temperature =
--     data.raw["generator"]["steam-turbine"].maximum_temperature * 10
-- data.raw["solar-panel"]["solar-panel"].production = tostring(tonumber(
--                                                                  string.match(
--                                                                      data.raw["solar-panel"]["solar-panel"]
--                                                                          .production,
--                                                                      "%d+")) *
--                                                                  10) .. "kW"

-- -- Accumulator modifications
-- data.raw["accumulator"]["accumulator"]["energy_source"].buffer_capacity = "15MJ"
-- data.raw["accumulator"]["accumulator"]["energy_source"].input_flow_limit =
--     "900kW"
-- data.raw["accumulator"]["accumulator"]["energy_source"].output_flow_limit =
--     "900kW"

-- data.raw["boiler"]["boiler"].target_temperature = 495
-- data.raw["boiler"]["boiler"].energy_consumption = "5.4MW"

-- data.raw["boiler"]["heat-exchanger"].target_temperature = 1500
-- data.raw["boiler"]["heat-exchanger"].energy_consumption = "30MW"

-- -- data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance = 7.5
-- data.raw["electric-pole"]["small-electric-pole"].supply_area_distance = 3.5
-- data.raw["electric-pole"]["small-electric-pole"].collision_box = {
--     {-0.01, -0.01}, {0.01, 0.01}
-- }
-- -- data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance = 9
-- data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 5
-- data.raw["electric-pole"]["medium-electric-pole"].collision_box = {
--     {-0.01, -0.01}, {0.01, 0.01}
-- }
-- -- data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance = 30
-- data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 3.5
-- data.raw["electric-pole"]["big-electric-pole"].collision_box = {
--     {-0.01, -0.01}, {0.01, 0.01}
-- }
-- -- data.raw["electric-pole"]["substation"].maximum_wire_distance = 18
-- -- data.raw["electric-pole"]["substation"].supply_area_distance = 9
-- data.raw["electric-pole"]["substation"].collision_box = {
--     {-0.01, -0.01}, {0.01, 0.01}
-- }

data.raw["recipe"]["loader"].hidden = false
data.raw["recipe"]["loader"].enabled = true

data.raw["recipe"]["fast-loader"].hidden = false
data.raw["recipe"]["fast-loader"].enabled = true

data.raw["recipe"]["express-loader"].hidden = false
data.raw["recipe"]["express-loader"].enabled = true

data.raw["recipe"]["steam-engine"].enabled = true
data.raw["recipe"]["electric-mining-drill"].enabled = true
data.raw["recipe"]["steel-plate"].enabled = true
data.raw["recipe"]["steel-chest"].enabled = true
data.raw["recipe"]["steel-furnace"].enabled = true

data.raw["recipe"]["iron-stick"].enabled = true
data.raw["recipe"]["rail"].enabled = true
data.raw["recipe"]["engine-unit"].enabled = true
data.raw["recipe"]["locomotive"].enabled = true
data.raw["recipe"]["cargo-wagon"].enabled = true
data.raw["recipe"]["rail-signal"].enabled = true
data.raw["recipe"]["rail-chain-signal"].enabled = true
data.raw["recipe"]["train-stop"].enabled = true
data.raw["recipe"]["medium-electric-pole"].enabled = true
data.raw["recipe"]["big-electric-pole"].enabled = true
data.raw["recipe"]["assembling-machine-1"].enabled = true
data.raw["recipe"]["assembling-machine-2"].enabled = true
data.raw["recipe"]["solar-panel"].enabled = true

-- data.raw["transport-belt"]["transport-belt"].speed = 0.09375
-- data.raw["transport-belt"]["fast-transport-belt"].speed = 0.1875
-- data.raw["transport-belt"]["express-transport-belt"].speed = 0.28125

-- data.raw["underground-belt"]["underground-belt"].speed = 0.09375
-- data.raw["underground-belt"]["fast-underground-belt"].speed = 0.1875
-- data.raw["underground-belt"]["express-underground-belt"].speed = 0.28125

-- data.raw["splitter"]["splitter"].speed = 0.09375
-- data.raw["splitter"]["fast-splitter"].speed = 0.1875
-- data.raw["splitter"]["express-splitter"].speed = 0.28125

-- data.raw["loader"]["loader"].speed = 0.09375
-- data.raw["loader"]["fast-loader"].speed = 0.1875
-- data.raw["loader"]["express-loader"].speed = 0.28125

-- data.raw["inserter"]["burner-inserter"].extension_speed = 0.0642
-- data.raw["inserter"]["burner-inserter"].rotation_speed = 0.03

-- data.raw["inserter"]["inserter"].extension_speed = 0.09
-- data.raw["inserter"]["inserter"].rotation_speed = 0.042

-- data.raw["inserter"]["fast-inserter"].extension_speed = 0.21
-- data.raw["inserter"]["fast-inserter"].rotation_speed = 0.12

-- data.raw["inserter"]["long-handed-inserter"].extension_speed = 0.1371
-- data.raw["inserter"]["long-handed-inserter"].rotation_speed = 0.06

-- data.raw["inserter"]["stack-inserter"].extension_speed = 0.21
-- data.raw["inserter"]["stack-inserter"].rotation_speed = 0.12

-- data.raw["inserter"]["stack-filter-inserter"].extension_speed = 0.21
-- data.raw["inserter"]["stack-filter-inserter"].rotation_speed = 0.12

-- data.raw["inserter"]["filter-inserter"].extension_speed = 0.21
-- data.raw["inserter"]["filter-inserter"].rotation_speed = 0.12

-- data.raw["locomotive"]["locomotive"].max_speed = 2.6
-- data.raw["locomotive"]["locomotive"].max_power = "1800kW"
-- data.raw["locomotive"]["locomotive"].braking_force = 30
-- -- data.raw["locomotive"]["locomotive"]["burner"].fuel_inventory_size = 9

-- data.raw["cargo-wagon"]["cargo-wagon"].max_speed = 4.5
-- data.raw["cargo-wagon"]["cargo-wagon"].braking_force = 9
-- data.raw["cargo-wagon"]["cargo-wagon"].inventory_size = 120

-- data.raw["fluid-wagon"]["fluid-wagon"].max_speed = 4.5
-- data.raw["fluid-wagon"]["fluid-wagon"].braking_force = 9
-- data.raw["fluid-wagon"]["fluid-wagon"].capacity = 75000

-- data.raw["artillery-wagon"]["artillery-wagon"].max_speed = 4.5
-- data.raw["artillery-wagon"]["artillery-wagon"].braking_force = 9
-- data.raw["artillery-wagon"]["artillery-wagon"].inventory_size = 3

-- data.raw["item"]["coal"].stack_size = 1000
-- data.raw["item"]["wood"].stack_size = 1000
-- data.raw["item"]["iron-ore"].stack_size = 1000
-- data.raw["item"]["copper-ore"].stack_size = 1000
-- data.raw["item"]["iron-plate"].stack_size = 1000
-- data.raw["item"]["copper-plate"].stack_size = 1000
-- data.raw["item"]["stone-brick"].stack_size = 1000
-- data.raw["item"]["steel-plate"].stack_size = 1000

-- data.raw["offshore-pump"]["offshore-pump"].pumping_speed =
--     data.raw["offshore-pump"]["offshore-pump"].pumping_speed * 10
-- data.raw["pump"]["pump"].energy_usage = "87kW"
-- data.raw["pump"]["pump"].pumping_speed = 600
-- data.raw["storage-tank"]["storage-tank"]["fluid_box"].base_area = 750

-- data.raw["container"]["wooden-chest"].inventory_size = 48
-- data.raw["container"]["iron-chest"].inventory_size = 96
-- data.raw["container"]["steel-chest"].inventory_size = 144

-- data.raw["logistic-container"]["logistic-chest-passive-provider"].inventory_size =
--     144
-- data.raw["logistic-container"]["logistic-chest-active-provider"].inventory_size =
--     144
-- data.raw["logistic-container"]["logistic-chest-storage"].inventory_size = 144
-- data.raw["logistic-container"]["logistic-chest-buffer"].inventory_size = 144
-- data.raw["logistic-container"]["logistic-chest-requester"].inventory_size = 144

-- data.raw["straight-rail"]["straight-rail"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["curved-rail"]["curved-rail"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["locomotive"]["locomotive"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["rail-signal"]["rail-signal"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["rail-chain-signal"]["rail-chain-signal"].collision_box = {
--     {0, 0}, {0, 0}
-- }

-- data.raw["solar-panel"]["solar-panel"].collision_box = {{-1, -1}, {1, 1}}
-- data.raw["solar-panel"]["solar-panel"].selection_box = {{-1, -1}, {1, 1}}
-- data.raw["accumulator"]["accumulator"].collision_box = {
--     {-0.4, -0.4}, {0.4, 0.4}
-- }
-- data.raw["accumulator"]["accumulator"].selection_box = {
--     {-0.5, -0.5}, {0.5, 0.5}
-- }
-- data.raw["accumulator"]["accumulator"].drawing_box = {{-0.5, -0.5}, {0.5, 0.5}}

-- data.raw["radar"]["radar"].collision_box = {{-0.01, -0.01}, {0.01, 0.01}}
-- data.raw["radar"]["radar"].energy_per_sector = "1MJ"
-- data.raw["radar"]["radar"].energy_usage = "900kW"
-- data.raw["radar"]["radar"].max_distance_of_sector_revealed = 42
-- data.raw["radar"]["radar"].max_distance_of_nearby_sector_revealed = 9
-- data.raw["radar"]["radar"].energy_per_nearby_scan = "25kJ"
-- data.raw["radar"]["radar"].rotation_speed = 0.03

-- eshape = {width = 1, height = 1, type = "full"}
-- data.raw["energy-shield-equipment"]["energy-shield-equipment"].shape = eshape
-- data.raw["energy-shield-equipment"]["energy-shield-equipment"]["energy_source"]
--     .buffer_capacity = "360kJ"
-- data.raw["energy-shield-equipment"]["energy-shield-equipment"]["energy_source"]
--     .input_flow_limit = "720kW"
-- data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"].shape =
--     eshape
-- data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"]["energy_source"]
--     .buffer_capacity = "540kJ"
-- data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"]["energy_source"]
--     .input_flow_limit = "1080kW"
-- data.raw["battery-equipment"]["battery-equipment"].shape = eshape
-- data.raw["battery-equipment"]["battery-equipment"]["energy_source"]
--     .buffer_capacity = "60MJ"
-- data.raw["battery-equipment"]["battery-mk2-equipment"].shape = eshape
-- data.raw["battery-equipment"]["battery-mk2-equipment"]["energy_source"]
--     .buffer_capacity = "300MJ"

-- data.raw["solar-panel-equipment"]["solar-panel-equipment"].power = "90kW"
-- data.raw["generator-equipment"]["fusion-reactor-equipment"].shape = eshape
-- data.raw["generator-equipment"]["fusion-reactor-equipment"].power = "2250kW"
-- data.raw["active-defense-equipment"]["personal-laser-defense-equipment"].shape =
--     eshape
-- data.raw["active-defense-equipment"]["personal-laser-defense-equipment"]["energy_source"]
--     .buffer_capacity = "660kJ"
-- data.raw["active-defense-equipment"]["personal-laser-defense-equipment"]["attack_parameters"]
--     .range = 20

-- data.raw["roboport-equipment"]["personal-roboport-equipment"].shape = eshape
-- data.raw["roboport-equipment"]["personal-roboport-equipment"]["energy_source"]
--     .buffer_capacity = "105MJ"
-- data.raw["roboport-equipment"]["personal-roboport-equipment"]["energy_source"]
--     .input_flow_limit = "10500KW"
-- data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"].shape = eshape
-- data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"]["energy_source"]
--     .buffer_capacity = "105MJ"
-- data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"]["energy_source"]
--     .input_flow_limit = "10500KW"

-- data.raw["unit"]["small-biter"].pollution_to_join_attack = 200
-- data.raw["unit"]["medium-biter"].pollution_to_join_attack = 400
-- data.raw["unit"]["big-biter"].pollution_to_join_attack = 600
-- data.raw["unit"]["behemoth-biter"].pollution_to_join_attack = 800
-- data.raw["unit"]["small-spitter"].pollution_to_join_attack = 200
-- data.raw["unit"]["medium-spitter"].pollution_to_join_attack = 400
-- data.raw["unit"]["big-spitter"].pollution_to_join_attack = 600
-- data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack = 800

-- data.raw["wall"]["stone-wall"].max_health = 35000
