local Stage = Object:extend()

function Stage:new()
end

function Stage:update(dt)
end

function Stage:draw()
    love.graphics.rectangle("fill", 50, 50, 10, 40)
end

return Stage
