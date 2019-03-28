local Stage = Object:extend()

function Stage:new()
  print('Making Stage')
  self.zone = Zone(self)
  self.main_canvas = love.graphics.newCanvas(gw, gh)
  self.timer = Timer()

end

function Stage:populate()

end

function Stage:update(dt)
  self.zone:update(dt)
end

function Stage:draw()

  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
  love.graphics.circle('line', gw/2, gh/2, 50)
  self.zone:draw()
  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return Stage
