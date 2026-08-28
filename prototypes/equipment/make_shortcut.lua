local function make_shortcut(chip)
    if mods['PickerInventoryTools'] then
        local disabled_chip = table.deepcopy(chip)
        disabled_chip.name = 'picker-disabled-' .. chip.name
        disabled_chip.localised_name = {
            'nano-disabled-equipment.disabled',
            chip.localised_name or {'equipment-name.' .. chip.name}
        }

        data:extend {disabled_chip, {
            type = 'shortcut',
            name = 'toggle-' .. chip.name,
            order = 'c[toggles]-z[' .. chip.name .. ']',
            action = 'lua',
            toggleable = true,
            localised_name = {'shortcut.toggle-' .. chip.name},
            associated_control_input = nil,
            technology_to_unlock = 'personal-roboport-equipment',
            icon = chip.sprite.filename,
            icon_size = chip.sprite.width or 64,
            small_icon = chip.sprite.filename,
            small_icon_size = chip.sprite.width or 64
        }}
    end
end

return make_shortcut
