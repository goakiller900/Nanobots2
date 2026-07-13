local Interface = require('__kry_stdlib__/stdlib/scripts/interface')
require('__kry_stdlib__/stdlib/utils/string')

local function commands(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player or player.admin then
        local params = event.parameter and event.parameter:split(' ') or {}
        if params[1] == 'reset' then
            if params[2] == 'mod' then
                Interface.reset_mod(true)
            elseif params[2] == 'cell_queue' then
                Interface.reset_queue('cell_queue')
            elseif params[2] == 'nano_queue' then
                Interface.reset_queue('nano_queue')
            end
        elseif params[1] == 'count' then
            Interface.count_queue(params[2])
        end
    end
end

return commands
