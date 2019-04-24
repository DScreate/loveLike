local Projectile = GameObject:extend()

function Projectile:new(zone, x, y, opts)
  Projectile.super.new(self, zone, x, y, opts)

  -- s represents the radius of the collider -> note it is not r because that is already in use
  self.s = opts.s or 2.5
  self.v = opts.v or 200
  self.color = hp_color

  self.damage = opts.damage or 100

  self.TTD = opts.ttd or 12

  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.s)
  self.collider:setCollisionClass('Projectile')

  self.collider:setObject(self)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

  self.timer:tween(0.5, self, {v = 400}, 'out-cubic')
  self.timer:after(self.TTD, function() self:die() end)

end

function Projectile:update(dt)
  Projectile.super.update(self, dt)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

  if self.collider:enter('Enemy') then
    local collision_data = self.collider:getEnterCollisionData('Enemy')
    local object = collision_data.collider:getObject()
    if object.hit then

      object:hit(self.damage)
    end

    self:die()
  end
end

function Projectile:draw()
  useColor(default_color)

  pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo())
  love.graphics.setLineWidth(self.s - self.s/4)
  love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
  useColor(hp_color) -- change half the projectile line to another color
  love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
  love.graphics.setLineWidth(1)
  love.graphics.pop()
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
