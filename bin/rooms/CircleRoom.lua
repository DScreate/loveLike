local CircleRoom = Object:extend()

function CircleRoom:new()
    -- body...
end

function CircleRoom:update(dt)
    -- body...
end

function CircleRoom:draw()
    love.graphics.circle("fill", gw/2, gh/2, 24)
end

return CircleRoom
