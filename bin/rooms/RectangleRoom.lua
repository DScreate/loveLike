local RectangleRoom = Object:extend()

function RectangleRoom:new ()
    -- body...
end

function RectangleRoom:update (dt)
    -- body...
end

function RectangleRoom:draw()
    love.graphics.rectangle("fill", gw/2, gh/2, 60, 20)
end

return RectangleRoom
