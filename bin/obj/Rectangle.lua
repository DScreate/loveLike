local Rectangle = GameObject:extend()

function Rectangle:new(zone, x, y, opts, w, h)
  Rectangle.super.new(self, zone, x, y, opts)
  self.width = w
  self.height = h
end

function Rectangle:update(dt)
  Rectangle.super:update(dt)
end

function Rectangle:draw()
  love.graphics.rectangle('fill', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end

return Rectangle
