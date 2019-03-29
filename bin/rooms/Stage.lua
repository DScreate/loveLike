local Stage = Object:extend()

function Stage:new()
  self.zone = Zone(self)
  self.zone:addPhysicsWorld()
  self.main_canvas = love.graphics.newCanvas(gw, gh)
  self.timer = Timer()

  self.player = self.zone:addGameObject('Player', gw/2, gh/2)

  self.zone.world:setGravity(0, 2)
end

function Stage:update(dt)
  camera.smoother = Camera.smooth.damped(5)
  camera:lockPosition(dt, gw/2, gh/2)
  self.zone:update(dt)
end

function Stage:draw()

  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
  camera:attach(0, 0, gw, gh)
  self.zone:draw()
  camera:detach()
  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
  self.zone:destroy()
  self.zone = nil
end

return Stage
