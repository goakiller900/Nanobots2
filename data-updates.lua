local Recipe = require('__kry_stdlib__/stdlib/data/recipe')

require('prototypes/technology/shortcuts')

local function item_exists(name)
    return data.raw.item[name] or data.raw.tool[name] or data.raw.module[name] or data.raw.capsule[name]
end

local function replace_if_available(recipe_name, old_name, new_name)
    if data.raw.recipe[recipe_name] and item_exists(new_name) then
        Recipe(recipe_name):replace_ingredient(old_name, new_name)
    end
end

local function add_if_available(recipe_name, item_name)
    if data.raw.recipe[recipe_name] and item_exists(item_name) then
        Recipe(recipe_name):add_ingredient({type = 'item', name = item_name, amount = 1})
    end
end

if mods.boblibrary then
    local key = 'bobmods-logistics-disableroboports'
    if settings.startup[key] and settings.startup[key].value then
        replace_if_available('roboport-interface', 'roboport', 'bob-logistic-zone-expander')
    end

    replace_if_available('gun-nano-emitter', 'electronic-circuit', 'basic-circuit-board')
    replace_if_available('ammo-nano-constructors', 'electronic-circuit', 'basic-circuit-board')
    replace_if_available('ammo-nano-termites', 'electronic-circuit', 'basic-circuit-board')

    add_if_available('equipment-bot-chip-items', 'robot-brain-construction')
    add_if_available('equipment-bot-chip-trees', 'robot-brain-construction')
    add_if_available('equipment-bot-chip-nanointerface', 'robot-brain-construction')
    add_if_available('equipment-bot-chip-nanointerface', 'gun-nano-emitter')
    add_if_available('equipment-bot-chip-launcher', 'robot-brain-combat')
    add_if_available('equipment-bot-chip-feeder', 'robot-brain-combat')
end
