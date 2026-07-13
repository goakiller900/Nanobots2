local table = require('__kry_stdlib__/stdlib/utils/table')

local function NtoZ_c(x, y)
    return (x >= 0 and x or (-0.5 - x)), (y >= 0 and y or (-0.5 - y))
end

local function cantorPair_v7(pos)
    local x, y = NtoZ_c(math.floor(pos.x), math.floor(pos.y))
    local s = x + y
    local h = s * (s + 0.5) + x
    return h + h
end

local function entity_index(entity, fallback_unit_number, fallback_position)
    if entity and entity.valid then
        return entity.unit_number or cantorPair_v7(entity.position)
    end
    return fallback_unit_number or (fallback_position and cantorPair_v7(fallback_position))
end

local Queue = {}

function Queue.new(t)
    if t and t._hash then
        return setmetatable(t, Queue.mt)
    end
    return setmetatable({_hash = {}}, Queue.mt)
end

function Queue.set_hash(t, data)
    local index = entity_index(data.entity, data.unit_number, data.position)
    if not index then
        return nil
    end
    t._hash[index] = t._hash[index] or {}
    t._hash[index][data.action] = true
    return index
end

function Queue.count(t)
    local count = 0
    for index in pairs(t) do
        if type(index) == 'number' then
            count = count + 1
        end
    end
    return count, table.size(t._hash)
end

function Queue.get_hash(t, entity)
    local index = entity_index(entity)
    return index and t._hash[index] or nil
end

function Queue.insert(t, data, tick, count)
    data.hash = Queue.set_hash(t, data)
    if not data.hash then
        return t, count
    end
    t[tick] = t[tick] or {}
    t[tick][#t[tick] + 1] = data
    return t, count
end

function Queue.next(t, _next_tick, tick_spacing, dont_combine)
    tick_spacing = tick_spacing or 1
    local count = 0
    local tick = (_next_tick and _next_tick >= game.tick and _next_tick) or game.tick
    local next_tick = function(really_dont_combine)
        tick = tick + tick_spacing
        while (dont_combine or really_dont_combine) and t[tick] do
            tick = tick + 1
        end
        count = count + 1
        return tick, count
    end
    local queue_count = function(num)
        count = count + (num or 0)
        return count
    end
    return next_tick, queue_count
end

function Queue.execute(t, event)
    local entries = t[event.tick]
    if not entries then
        return t
    end

    t[event.tick] = nil
    for _, data in ipairs(entries) do
        local index = data.hash
        local bucket = index and t._hash[index]
        if bucket then
            bucket[data.action] = nil
            if table.size(bucket) == 0 then
                t._hash[index] = nil
            end
        end
    end

    for _, data in ipairs(entries) do
        local action = Queue[data.action]
        if action then
            action(data)
        end
    end
    return t
end

Queue.mt = {__index = Queue, __call = nil}
return setmetatable(Queue, {__call = function(_, ...) return Queue.new(...) end})
