require('prototypes/technology/shortcuts')

local function item_exists(name)
    return data.raw.item[name]
        or data.raw.tool[name]
        or data.raw.module[name]
        or data.raw.capsule[name]
        or data.raw.gun[name]
end

local function ingredient_name(ingredient)
    return ingredient.name or ingredient[1]
end

local function ingredient_amount(ingredient)
    return ingredient.amount or ingredient[2]
end

local function set_ingredient_name(ingredient, name)
    if ingredient.name then
        ingredient.name = name
    else
        ingredient[1] = name
    end
end

local function set_ingredient_amount(ingredient, amount)
    if ingredient.amount then
        ingredient.amount = amount
    else
        ingredient[2] = amount
    end
end

local function is_item_ingredient(ingredient, name)
    return (ingredient.type == nil or ingredient.type == 'item') and ingredient_name(ingredient) == name
end

local function replace_ingredient(ingredients, old_name, new_name)
    if not ingredients then
        return
    end

    local replacement
    for _, ingredient in ipairs(ingredients) do
        if is_item_ingredient(ingredient, new_name) then
            replacement = ingredient
            break
        end
    end

    for index = #ingredients, 1, -1 do
        local ingredient = ingredients[index]
        if is_item_ingredient(ingredient, old_name) then
            if replacement then
                set_ingredient_amount(replacement, ingredient_amount(replacement) + ingredient_amount(ingredient))
                table.remove(ingredients, index)
            else
                set_ingredient_name(ingredient, new_name)
                replacement = ingredient
            end
        end
    end
end

local function add_ingredient(ingredients, item_name)
    if not ingredients then
        return
    end

    for _, ingredient in ipairs(ingredients) do
        if is_item_ingredient(ingredient, item_name) then
            return
        end
    end

    ingredients[#ingredients + 1] = {type = 'item', name = item_name, amount = 1}
end

local function update_recipe_ingredients(recipe, update)
    update(recipe.ingredients)
    if recipe.normal then
        update(recipe.normal.ingredients)
    end
    if recipe.expensive then
        update(recipe.expensive.ingredients)
    end
end

local function replace_if_available(recipe_name, old_name, new_name)
    local recipe = data.raw.recipe[recipe_name]
    if recipe and item_exists(new_name) then
        update_recipe_ingredients(recipe, function(ingredients)
            replace_ingredient(ingredients, old_name, new_name)
        end)
    end
end

local function add_if_available(recipe_name, item_name)
    local recipe = data.raw.recipe[recipe_name]
    if recipe and item_exists(item_name) then
        update_recipe_ingredients(recipe, function(ingredients)
            add_ingredient(ingredients, item_name)
        end)
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
