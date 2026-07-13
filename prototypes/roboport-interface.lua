-------------------------------------------------------------------------------
-- Logistic network roboport interface
-------------------------------------------------------------------------------
local Data = require('__kry_stdlib__/stdlib/data/data')
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')

Data {
    type = 'technology',
    name = 'roboport-interface',
    icon = '__Nanobots2-continued__/graphics/technology/roboport-interface.png',
    icon_size = 256,
    effects = {},
    prerequisites = {'construction-robotics', 'circuit-network'},
    unit = {
        count = 110,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack', 1},
            {'chemical-science-pack', 1}
        },
        time = 30
    },
    order = 'a-b-ba'
}

Recipe {
    type = 'recipe',
    name = 'roboport-interface',
    enabled = false,
    categories = {'crafting'},
    ingredients = {
        {type = 'item', name = 'constant-combinator', amount = 1},
        {type = 'item', name = 'radar', amount = 1},
        {type = 'item', name = 'roboport', amount = 1}
    },
    results = {{type = 'item', name = 'roboport-interface', amount = 1}},
    energy_required = 30
}:add_unlock('roboport-interface')

Data {
    type = 'item',
    name = 'roboport-interface',
    icon = '__Nanobots2-continued__/graphics/icons/roboport-interface.png',
    icon_size = 64,
    subgroup = 'logistic-network',
    order = 'c[signal]-a[roboport]-interface',
    place_result = 'roboport-interface-main',
    stack_size = 5
}

Data {
    type = 'item',
    name = 'roboport-interface-cc',
    icon = '__Nanobots2-continued__/graphics/icons/roboport-interface-cc.png',
    icon_size = 64,
    hidden = true,
    subgroup = 'logistic-network',
    order = 'c[signal]-a[roboport]-interface-cc',
    place_result = 'roboport-interface-cc',
    stack_size = 1000
}

local collision_mask = {
    layers = {
        item = true,
        meltable = true,
        object = true,
        player = true,
        water_tile = true,
        is_object = true,
        is_lower_object = true
    }
}

local ri_cc = Data('constant-combinator', 'constant-combinator'):copy('roboport-interface-cc')
ri_cc.icon = '__Nanobots2-continued__/graphics/icons/roboport-interface-cc.png'
ri_cc.icon_size = 64
ri_cc.flags = {'not-deconstructable', 'player-creation', 'placeable-off-grid'}
ri_cc.collision_mask = collision_mask
ri_cc.minable = nil
ri_cc.selection_box = {{0, 0}, {1, 1}}
ri_cc.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
for index, direction in pairs({'north', 'east', 'south', 'west'}) do
    ri_cc.sprites[direction] = Data.Sprites.empty_sprite()
    ri_cc.activity_led_sprites[direction] = {
        filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/combinator-led-constant-south.png',
        width = 11,
        height = 11,
        frame_count = 1,
        draw_as_glow = true,
        shift = {0, -0.75}
    }
    ri_cc.activity_led_light_offsets[index] = {0, -0.75}
    ri_cc.circuit_wire_connection_points[index] = {
        shadow = {red = {0.75, 0.5625}, green = {0.21875, 0.5625}},
        wire = {red = {0.5, -0.05}, green = {0.2, 0.15}}
    }
end
ri_cc.circuit_wire_max_distance = 9
ri_cc.activity_led_light = {intensity = 0.8, size = 1}

local ri_radar = Data('radar', 'radar'):copy('roboport-interface-scanner')
ri_radar.flags = {'not-deconstructable', 'player-creation', 'placeable-off-grid'}
ri_radar.icon = '__Nanobots2-continued__/graphics/icons/roboport-interface.png'
ri_radar.icon_size = 64
ri_radar.minable = nil
ri_radar.next_upgrade = nil
ri_radar.collision_mask = collision_mask
ri_radar.selection_box = {{-1, 0}, {0, 1}}
ri_radar.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
ri_radar.pictures = Data.Sprites.empty_pictures()
ri_radar.max_distance_of_sector_revealed = 0
ri_radar.max_distance_of_nearby_sector_revealed = 1
ri_radar.energy_per_sector = '20MJ'
ri_radar.energy_per_nearby_scan = '250kJ'
ri_radar.energy_usage = '300kW'

local ri_main = Data('roboport', 'roboport'):copy('roboport-interface-main')
ri_main.icon = '__Nanobots2-continued__/graphics/icons/roboport-interface.png'
ri_main.icon_size = 64
ri_main.flags = {'placeable-player', 'player-creation'}
ri_main.minable = {mining_time = 0.5, result = 'roboport-interface'}
ri_main.next_upgrade = nil
ri_main.max_health = 500
ri_main.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
ri_main.selection_box = {{-1, -1}, {1, 0}}
ri_main.energy_source = {
    type = 'electric',
    usage_priority = 'secondary-input',
    input_flow_limit = '50kW',
    buffer_capacity = '500kJ'
}
ri_main.recharge_minimum = '50kJ'
ri_main.energy_usage = '25kW'
ri_main.charging_energy = '1kW'
ri_main.logistics_radius = 0
ri_main.construction_radius = 0
ri_main.charge_approach_distance = 0
ri_main.robot_slots_count = 0
ri_main.material_slots_count = 0
ri_main.base = Data.Sprites.empty_picture()
ri_main.base_animation = {
    layers = {
        {
            filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/hr-roboport-interface-base.png',
            scale = 0.5,
            width = 256,
            height = 448,
            repeat_count = 16,
            animation_speed = 0.15,
            shift = {0.5, -2.0}
        },
        {
            filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/hr-roboport-interface.png',
            scale = 0.5,
            width = 256,
            height = 448,
            frame_count = 16,
            line_length = 8,
            animation_speed = 0.15,
            shift = {0.5, -2.0}
        },
        {
            filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/hr-roboport-interface-base-shadow.png',
            scale = 0.5,
            width = 422,
            height = 448,
            repeat_count = 16,
            animation_speed = 0.15,
            shift = {0.5, -2.0},
            draw_as_shadow = true
        },
        {
            filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/hr-roboport-interface-shadow.png',
            scale = 0.5,
            width = 256,
            height = 448,
            frame_count = 16,
            line_length = 8,
            animation_speed = 0.15,
            shift = {2.5, -2.0},
            draw_as_shadow = true
        },
        {
            filename = '__Nanobots2-continued__/graphics/entity/roboport-interface/hr-roboport-interface-glow.png',
            scale = 0.5,
            width = 256,
            height = 448,
            frame_count = 16,
            line_length = 8,
            animation_speed = 0.15,
            shift = {0.5, -2.0},
            draw_as_light = true
        }
    }
}
ri_main.base_patch = Data.Sprites.empty_animation()
ri_main.door_animation_up = Data.Sprites.empty_animation()
ri_main.door_animation_down = Data.Sprites.empty_animation()
ri_main.recharging_animation = Data.Sprites.empty_animation()
ri_main.recharging_light = nil
ri_main.request_to_open_door_timeout = 15
ri_main.spawn_and_station_height = 1.75
