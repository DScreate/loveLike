local PolygonRoom = Object:extend()

function PolygonRoom:new ()
    -- body...
end

function PolygonRoom:update (dt)
    -- body...
end

function PolygonRoom:draw()
    love.graphics.polygon('fill', 100, 100, 200, 100, 150, 200)
end

return PolygonRoom
