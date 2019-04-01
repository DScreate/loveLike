local Projectile = GameObject:extend()

function Projectile:new(zone, x, y, opts)
  Projectile.super.new(self, zone, x, y, opts)

  -- s represents the radius of the collider -> note it is not r because that is already in use
  self.s = opts.s or 2.5
  self.v = opts.v or 200
  self.color = hp_color

  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.s)
  self.collider:setObject(self)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

  self.timer:tween(0.5, self, {v = 400}, 'linear')

end

function Projectile:update(dt)
  Projectile.super.update(self, dt)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))


  -- TODO Look into refactoring to be based upon collider impacting edge of play area
  if self.x < 0 then self:die() end
  if self.y < 0 then self:die() end
  if self.x > gw then self:die() end
  if self.y > gh then self:die() end
end

function Projectile:draw()
  setColor(255, 255, 255, 255)
  love.graphics.circle('line', self.x, self.y, self.s)
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
  self.dead = true
  self.zone:addGameObject('ProjectileDeathEffect', self.x, self.y,
  {color = hp_color, w = 3*self.s})
end

return Projectile
