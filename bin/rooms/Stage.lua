local Stage = Object:extend()

function Stage:new()
  self.zone = Zone(self)
  self.zone:addPhysicsWorld()
  self.zone.world:addCollisionClass('Player')
  self.zone.world:addCollisionClass('Projectile', {ignores = {'Projectile'}})
  self.zone.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})


  self.main_canvas = love.graphics.newCanvas(gw, gh)
  self.timer = Timer()

  self.player = self.zone:addGameObject('Player', gw/2, gh/2)
  --self.zone.world:setGravity(0, 2)

  input:bind('p', function()
    --self.zone:addGameObject('Ammo', random(0, gw), random(0, gh))
    self:spawnWithinRange('Ammo', gw, gh)
  end)

  camera:setFollowLerp(0.4)
  camera:setFollowLead(1)
  camera:setFollowStyle('TOPDOWN')
end

function Stage:spawnWithinRange(gameObject, x, y)
  self.zone:addGameObject(gameObject, self.player.x + random(0-x, x), self.player.y + random(0-y, y))
end

function Stage:update(dt)
  camera:update(dt)
  self.zone:update(dt)
end

function Stage:draw()

  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
  camera:attach()
  self.zone:draw()
  camera:detach()
  camera:draw()
  love.graphics.setCanvas()

  setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
  self.zone:destroy()
  self.zone = nil
end

return Stage
