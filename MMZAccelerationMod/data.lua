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

-- Enable recipes

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


-- Fuel inventory modifications
-- Increase fuel inventory of burner-inserter by 10 times
data.raw["inserter"]["burner-inserter"].energy_source.fuel_inventory_size =
    data.raw["inserter"]["burner-inserter"].energy_source.fuel_inventory_size * 10
-- Increase fuel inventory of boiler by 10 times
data.raw["boiler"]["boiler"].energy_source.fuel_inventory_size =
    data.raw["boiler"]["boiler"].energy_source.fuel_inventory_size * 10
-- Increase fuel inventory of locomotive by 10 times
data.raw["locomotive"]["locomotive"].energy_source.fuel_inventory_size =
    data.raw["locomotive"]["locomotive"].energy_source.fuel_inventory_size * 10
-- Increase fuel inventory of burner mining drill by 10 times
data.raw["mining-drill"]["burner-mining-drill"].energy_source.fuel_inventory_size =
    data.raw["mining-drill"]["burner-mining-drill"].energy_source.fuel_inventory_size *
    10
-- Increase fuel inventory of stone-furnace by 10 times
data.raw["furnace"]["stone-furnace"].energy_source.fuel_inventory_size =
    data.raw["furnace"]["stone-furnace"].energy_source.fuel_inventory_size * 10
-- Increase fuel inventory of steel-furnace by 10 times
data.raw["furnace"]["steel-furnace"].energy_source.fuel_inventory_size =
    data.raw["furnace"]["steel-furnace"].energy_source.fuel_inventory_size * 10
-- Increase fuel inventory of car by 10 times
data.raw["car"]["car"].energy_source.fuel_inventory_size =
    data.raw["car"]["car"].energy_source.fuel_inventory_size * 10


-- Mining drill modifications
-- Also increase the production and fuel consumption of burner mining drills by 15 times
data.raw["mining-drill"]["burner-mining-drill"].mining_speed =
    data.raw["mining-drill"]["burner-mining-drill"].mining_speed * 15
data.raw["mining-drill"]["burner-mining-drill"].energy_usage = tostring(
    tonumber(string.match(
                 data.raw["mining-drill"]["burner-mining-drill"].energy_usage,
                 "%d+")) * 15) .. "kW"
                 
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

-- Train modifications
-- Increase max speed of locomotive by 3 times
data.raw["locomotive"]["locomotive"].max_speed =
    data.raw["locomotive"]["locomotive"].max_speed * 3
-- Increas max speed of cargo-wagon by 3 times
data.raw["cargo-wagon"]["cargo-wagon"].max_speed =
    data.raw["cargo-wagon"]["cargo-wagon"].max_speed * 3
-- Increase max speed of fluid-wagon by 3 times
data.raw["fluid-wagon"]["fluid-wagon"].max_speed =
    data.raw["fluid-wagon"]["fluid-wagon"].max_speed * 3
-- Increase max speed of artillery-wagon by 3 times
data.raw["artillery-wagon"]["artillery-wagon"].max_speed =
    data.raw["artillery-wagon"]["artillery-wagon"].max_speed * 3

-- Increase the breaking force of locomotive by 3 times
data.raw["locomotive"]["locomotive"].braking_force =
    data.raw["locomotive"]["locomotive"].braking_force * 3
-- Increae the braking force of cargo-wagon by 3 times
data.raw["cargo-wagon"]["cargo-wagon"].braking_force =
    data.raw["cargo-wagon"]["cargo-wagon"].braking_force * 3
-- Increae the braking force of fluid-wagon by 3 times
data.raw["fluid-wagon"]["fluid-wagon"].braking_force =
    data.raw["fluid-wagon"]["fluid-wagon"].braking_force * 3
-- Increae the braking force of artillery-wagon by 3 times
data.raw["artillery-wagon"]["artillery-wagon"].braking_force =
    data.raw["artillery-wagon"]["artillery-wagon"].braking_force * 3

-- Increae the inventory size of cargo-wagon by 10 times
data.raw["cargo-wagon"]["cargo-wagon"].inventory_size =
    data.raw["cargo-wagon"]["cargo-wagon"].inventory_size * 10
-- Increae the inventory of fluid-wagon by 10 times
data.raw["fluid-wagon"]["fluid-wagon"].capacity =
    data.raw["fluid-wagon"]["fluid-wagon"].capacity * 10
-- Increae the inventory of artillery-wagon by 10 times
data.raw["artillery-wagon"]["artillery-wagon"].inventory_size =
    data.raw["artillery-wagon"]["artillery-wagon"].inventory_size * 10