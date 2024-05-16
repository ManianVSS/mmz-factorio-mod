-- data.raw["character"]["character"].max_health = 500
data.raw["character"]["character"].healing_per_tick = 1.5
data.raw["character"]["character"].collision_box = {{0, 0}, {0, 0}}
data.raw["character"]["character"].crafting_categories = {
    "crafting", "basic-crafting", "advanced-crafting", "smelting",
    "centrifuging"
}
-- data.raw["character"]["character"].inventory_size = 400
-- data.raw["character"]["character"].build_distance = 5000
-- -- data.raw["character"]["character"].drop_item_distance = 5000
-- data.raw["character"]["character"].reach_distance = 5000
-- -- data.raw["character"]["character"].item_pickup_distance = 10
-- -- data.raw["character"]["character"].loot_pickup_distance = 10
-- -- data.raw["character"]["character"].enter_vehicle_distance = 10
-- data.raw["character"]["character"].reach_resource_distance = 5000
data.raw["character"]["character"].ticks_to_stay_in_combat = 120
-- data.raw["character"]["character"].running_speed = 1.5
-- data.raw["character"]["character"].mining_speed = 5

data.raw["ammo-turret"]["gun-turret"].rotation_speed = 0.15
data.raw["ammo-turret"]["gun-turret"].preparing_speed = 0.8
data.raw["ammo-turret"]["gun-turret"].folding_speed = 0.8
data.raw["ammo-turret"]["gun-turret"].automated_ammo_count = 200
data.raw["ammo-turret"]["gun-turret"].attacking_speed = 50
-- data.raw["ammo-turret"]["gun-turret"].call_for_help_radius = 200
data.raw["ammo-turret"]["gun-turret"]["attack_parameters"].range = 100

data.raw["mining-drill"]["electric-mining-drill"].mining_speed = 15
data.raw["mining-drill"]["electric-mining-drill"].energy_usage = "2700kW"
data.raw["mining-drill"]["electric-mining-drill"].resource_searching_radius = 5
data.raw["mining-drill"]["electric-mining-drill"]["energy_source"]
    .emissions_per_minute = 300

data.raw["mining-drill"]["burner-mining-drill"].mining_speed = 2.5
data.raw["mining-drill"]["burner-mining-drill"].energy_usage = "1500kW"
data.raw["mining-drill"]["burner-mining-drill"].resource_searching_radius = 2.5
data.raw["mining-drill"]["burner-mining-drill"]["energy_source"]
    .emissions_per_minute = 120

data.raw["mining-drill"]["pumpjack"].mining_speed = 10
data.raw["mining-drill"]["pumpjack"].energy_usage = "900kW"
data.raw["mining-drill"]["pumpjack"].resource_searching_radius = 10
data.raw["mining-drill"]["pumpjack"]["energy_source"].emissions_per_minute = 100

data.raw["furnace"]["stone-furnace"].crafting_speed = 10
data.raw["furnace"]["stone-furnace"].energy_usage = "900kW"
data.raw["furnace"]["stone-furnace"]["energy_source"].emissions_per_minute = 20

data.raw["furnace"]["steel-furnace"].crafting_speed = 20
data.raw["furnace"]["steel-furnace"].energy_usage = "900kW"
data.raw["furnace"]["steel-furnace"]["energy_source"].emissions_per_minute = 40

data.raw["furnace"]["electric-furnace"].crafting_speed = 20
data.raw["furnace"]["electric-furnace"].energy_usage = "1800kW"
data.raw["furnace"]["electric-furnace"]["energy_source"].emissions_per_minute =
    10

data.raw["assembling-machine"]["assembling-machine-1"].crafting_speed = 5
data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = "750kW"
data.raw["assembling-machine"]["assembling-machine-1"]["energy_source"]
    .emissions_per_minute = 40
data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories = {
    "smelting", "crafting", "basic-crafting", "advanced-crafting",
    "centrifuging"
}

data.raw["assembling-machine"]["assembling-machine-2"].crafting_speed = 7.5
data.raw["assembling-machine"]["assembling-machine-2"].energy_usage = "1500kW"
data.raw["assembling-machine"]["assembling-machine-2"]["energy_source"]
    .emissions_per_minute = 30
data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories = {
    "smelting", "basic-crafting", "crafting", "advanced-crafting",
    "crafting-with-fluid", "centrifuging"
}

data.raw["assembling-machine"]["assembling-machine-3"].crafting_speed = 12.5
data.raw["assembling-machine"]["assembling-machine-3"].energy_usage = "3750kW"
data.raw["assembling-machine"]["assembling-machine-3"]["energy_source"]
    .emissions_per_minute = 20
data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories = {
    "smelting", "basic-crafting", "crafting", "advanced-crafting",
    "crafting-with-fluid", "centrifuging"
}

data.raw["assembling-machine"]["oil-refinery"].crafting_speed = 10
data.raw["assembling-machine"]["oil-refinery"].energy_usage = "4200kW"
data.raw["assembling-machine"]["oil-refinery"]["energy_source"]
    .emissions_per_minute = 60

data.raw["assembling-machine"]["chemical-plant"].crafting_speed = 10
data.raw["assembling-machine"]["chemical-plant"].energy_usage = "2100kW"
data.raw["assembling-machine"]["chemical-plant"]["energy_source"]
    .emissions_per_minute = 40

data.raw["assembling-machine"]["centrifuge"].crafting_speed = 10
data.raw["assembling-machine"]["centrifuge"].energy_usage = "3500kW"
data.raw["assembling-machine"]["centrifuge"]["energy_source"]
    .emissions_per_minute = 40

data.raw["generator"]["steam-engine"].maximum_temperature = 660
data.raw["generator"]["steam-turbine"].maximum_temperature = 1000
data.raw["solar-panel"]["solar-panel"].production = "600kW"
data.raw["accumulator"]["accumulator"]["energy_source"].buffer_capacity = "20MJ"
data.raw["accumulator"]["accumulator"]["energy_source"].input_flow_limit =
    "1200kW"
data.raw["accumulator"]["accumulator"]["energy_source"].output_flow_limit =
    "1200kW"

data.raw["boiler"]["boiler"].target_temperature = 660
data.raw["boiler"]["boiler"].energy_consumption = "9MW"
data.raw["boiler"]["boiler"]["energy_source"].emissions_per_minute = 300
data.raw["boiler"]["heat-exchanger"].target_temperature = 1000
data.raw["boiler"]["heat-exchanger"].energy_consumption = "20MW"

-- data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance = 7.5
data.raw["electric-pole"]["small-electric-pole"].supply_area_distance = 3.75
-- data.raw["electric-pole"]["small-electric-pole"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance = 9
data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 5
-- data.raw["electric-pole"]["medium-electric-pole"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance = 30
data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 4.5
-- data.raw["electric-pole"]["big-electric-pole"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["electric-pole"]["substation"].maximum_wire_distance = 18
-- data.raw["electric-pole"]["substation"].supply_area_distance = 9
-- data.raw["electric-pole"]["substation"].collision_box = {{0, 0}, {0, 0}}

data.raw["recipe"]["loader"].hidden = false
data.raw["recipe"]["loader"].enabled = true

data.raw["recipe"]["fast-loader"].hidden = false
data.raw["recipe"]["fast-loader"].enabled = true

data.raw["recipe"]["express-loader"].hidden = false
data.raw["recipe"]["express-loader"].enabled = true

data.raw["recipe"]["steel-plate"].enabled = true
data.raw["recipe"]["steel-chest"].enabled = true
data.raw["recipe"]["steel-furnace"].enabled = true

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

data.raw["transport-belt"]["transport-belt"].speed = 0.0625
data.raw["transport-belt"]["fast-transport-belt"].speed = 0.125
data.raw["transport-belt"]["express-transport-belt"].speed = 0.25

data.raw["underground-belt"]["underground-belt"].speed = 0.0625
data.raw["underground-belt"]["fast-underground-belt"].speed = 0.125
data.raw["underground-belt"]["express-underground-belt"].speed = 0.25

data.raw["splitter"]["splitter"].speed = 0.0625
data.raw["splitter"]["fast-splitter"].speed = 0.125
data.raw["splitter"]["express-splitter"].speed = 0.25

data.raw["loader"]["loader"].speed = 0.0625
data.raw["loader"]["fast-loader"].speed = 0.125
data.raw["loader"]["express-loader"].speed = 0.25

data.raw["inserter"]["burner-inserter"].extension_speed = 0.0214
data.raw["inserter"]["burner-inserter"].rotation_speed = 0.02

data.raw["inserter"]["inserter"].extension_speed = 0.06
data.raw["inserter"]["inserter"].rotation_speed = 0.028

data.raw["inserter"]["fast-inserter"].extension_speed = 0.14
data.raw["inserter"]["fast-inserter"].rotation_speed = 0.08

data.raw["inserter"]["long-handed-inserter"].extension_speed = 0.0914
data.raw["inserter"]["long-handed-inserter"].rotation_speed = 0.04

data.raw["inserter"]["stack-inserter"].extension_speed = 0.14
data.raw["inserter"]["stack-inserter"].rotation_speed = 0.08

data.raw["inserter"]["filter-inserter"].extension_speed = 0.14
data.raw["inserter"]["filter-inserter"].rotation_speed = 0.08

-- data.raw["item"]["coal"].stack_size = 1000
-- data.raw["item"]["wood"].stack_size = 1000
-- data.raw["item"]["iron-ore"].stack_size = 1000
-- data.raw["item"]["copper-ore"].stack_size = 1000
-- data.raw["item"]["iron-plate"].stack_size = 1000
-- data.raw["item"]["copper-plate"].stack_size = 1000
-- data.raw["item"]["stone-brick"].stack_size = 1000
-- data.raw["item"]["steel-plate"].stack_size = 1000

data.raw["offshore-pump"]["offshore-pump"].pumping_speed = 40
data.raw["pump"]["pump"].energy_usage = "290kW"
data.raw["pump"]["pump"].pumping_speed = 2000
data.raw["storage-tank"]["storage-tank"]["fluid_box"].base_area = 2500

data.raw["container"]["wooden-chest"].inventory_size = 64
data.raw["container"]["iron-chest"].inventory_size = 128
data.raw["container"]["steel-chest"].inventory_size = 256

data.raw["logistic-container"]["logistic-chest-passive-provider"].inventory_size =
    256
data.raw["logistic-container"]["logistic-chest-active-provider"].inventory_size =
    256
data.raw["logistic-container"]["logistic-chest-storage"].inventory_size = 256
data.raw["logistic-container"]["logistic-chest-buffer"].inventory_size = 256
data.raw["logistic-container"]["logistic-chest-requester"].inventory_size = 256

-- data.raw["straight-rail"]["straight-rail"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["curved-rail"]["curved-rail"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["locomotive"]["locomotive"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["rail-signal"]["rail-signal"].collision_box = {{0, 0}, {0, 0}}
-- data.raw["rail-chain-signal"]["rail-chain-signal"].collision_box = {
--     {0, 0}, {0, 0}
-- }


data.raw["unit"]["small-biter"].pollution_to_join_attack=400
data.raw["unit"]["medium-biter"].pollution_to_join_attack=800
data.raw["unit"]["big-biter"].pollution_to_join_attack=1600
data.raw["unit"]["behemoth-biter"].pollution_to_join_attack=3200
data.raw["unit"]["small-spitter"].pollution_to_join_attack=400
data.raw["unit"]["medium-spitter"].pollution_to_join_attack=800
data.raw["unit"]["big-spitter"].pollution_to_join_attack=1600
data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack=3200