local Circle = GameObject:extend()

function Circle:new(zone, x, y, opts, r)
  -- print('Creating circle: ' .. x .. ' '.. y)
  Circle.super.new(self, zone, x, y, opts)
  self.radius = 5
  timer:tween(2, self, {radius = r}, 'out-bounce')
  --[[
  timer:after(0, function(f)
    timer:tween(2, self, {radius = 96}, 'out-bounce', function()
      timer:tween(2, self, {radius = 0}, 'in-bounce')
    end)
    --timer:after(4, f)
  end)
  timer:after(8, function()
    print('Removing circle')
    self.dead = true
  end)
  ]]--
end

function Circle:update(dt)
  Circle.super:update(dt)
end

function Circle:draw()
  --print('Drawing circle')
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Circle
