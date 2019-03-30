local Circle = GameObject:extend()

function Circle:new(zone, x, y, opts, r)
  Circle.super.new(self, zone, x, y, opts)
  self.radius = 5
  timer:tween(2, self, {radius = r}, 'out-bounce')

end

function Circle:update(dt)
  Circle.super:update(dt)
end

function Circle:draw()
  --print('Drawing circle')
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Circle
