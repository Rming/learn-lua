local person = {
    first = "rming",
    last  = "wang",
}

local _dump
_dump = function(t)
    for k,v in pairs(t) do
        if k ~= '_G' and type(v) == 'table' then
            _dump(v)
            --print(k..'=>table')
        else
            print(string.format('%s=>%s', k, v))
        end
    end    
end

_dump(person)
