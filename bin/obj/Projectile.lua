local Projectile = GameObject:extend()

function Projectile:new(zone, x, y, opts)
  Projectile.super.new(self, zone, x, y, opts)

  -- s represents the radius of the collider -> note it is not r because that is already in use
  self.s = opts.s or 2.5
  self.v = opts.v or 200

  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.s)
  self.collider:setObject(self)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

end

function Projectile:update(dt)
  Projectile.super.update(self, dt)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Projectile:draw()
  setColor(255, 255, 255, 255)
  love.graphics.circle('line', self.x, self.y, self.s)
end

return Projectile
