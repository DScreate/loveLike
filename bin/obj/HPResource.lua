local HPResource = GameObject:extend()

function HPResource:new(zone, x, y, opts)
  HPResource.super.new(self, zone, x, y, opts)

  self.depth = 75
  self.w, self.h = 15, 15
  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setCollisionClass('Collectable')
  self.collider:setObject(self)
  self.collider:setFixedRotation(false)
  self.r = random(0, 2*math.pi)
  self.v = random(10, 20)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
  self.collider:applyAngularImpulse(random(-24, 24))
end

function HPResource:update(dt)
  HPResource.super.update(self, dt)
end

function HPResource:draw()
  useColor(default_color)
  love.graphics.circle('line', self.x, self.y, self.w)
  useColor(hp_color)
  love.graphics.rectangle('fill', self.x - self.w/2, self.y - 2, self.w, 4)
  love.graphics.rectangle('fill', self.x - 2, self.y - self.h/2, 4, self.h)

end

function HPResource:die()
  self.dead = true
  local colorEffect = makeRandomSwatch()
  for i = 1, love.math.random(8, 12) do
    self.zone:addGameObject('ExplodeParticle', self.x, self.y)
  end
  self.zone:addGameObject('InfoText',  self.x + table.random({-1, 1})*self.w, self.y + table.random({-1, 1})*self.h,
  {text = '+HP', color = colorEffect})
end

return HPResource
