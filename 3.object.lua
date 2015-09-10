window = {}
window.prototype = {
    x = 10,
    y = 11,
    width  = 100,
    height = 50,
    print  = print,
}
-- 定义 metatable 并定义 __index 方法
window.mt = {}
--window.mt.__index = window.prototype
window.mt.__index = function(table, key)
    return window.prototype[key];   
end
-- 设置 window 元表
setmetatable(window, window.mt)

-- 定义 window 构造函数
window.new = function(o)
    setmetatable(o, window.mt)
    return o
end

new_window = window.new{x = 20, y = 21}
--new_window = window.new({x = 20, y = 21})
--new_window = window.new{}

--[[
    new_window -> 有没有 x key --没有-> metatable.__index -> 返回 window.prototype[x]
--]]

new_window.print 'hello'
print(new_window.x)
print(new_window.width)


