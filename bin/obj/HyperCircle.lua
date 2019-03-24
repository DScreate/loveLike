local HyperCircle = Circle:extend()

function HyperCircle:new(x, y, inner_radius, outer_radius, line_width)
  HyperCircle.super:new(x, y, inner_radius)
  self.line_width = line_width
  self.outer_radius = outer_radius
end

function HyperCircle:update(dt)
  HyperCircle.super.update(self, dt)
end

function HyperCircle:draw()
  HyperCircle.super:draw()
  love.graphics.setLineWidth(self.line_width)
  love.graphics.circle('line', self.x, self.y, self.outer_radius)
  love.graphics.setLineWidth(1)
end

return HyperCircle
