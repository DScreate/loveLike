local Player = GameObject:extend()

function Player:new(zone, x, y, opts)
  Player.super:new(zone, x, y, opts)

  self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)

  self.r = -math.pi/2
  self.rv = 1.66*math.pi
  self.v = 0
  self.max_v = 100
  self.a = 100

  self.attack_speed = 1
  timer:every(5, function() self.attack_speed = random(1, 2) end)

  --timer:after(1, function(func) print("foo") timer:after(1, 'func') end)

  self:autoShoot()

end

function Player:autoShoot()
  self.timer:after(0.24/self.attack_speed, function()
    self:shoot()
    self:autoShoot()
  end)
end

function Player:shoot()
  local d = 1.2 * self.w

  self.zone:addGameObject('ShootEffect', self.x + d*math.cos(self.r),
  self.y + d*math.sin(self.r), {player = self, d = d})

  self.zone:addGameObject('Projectile', self.x + 1.5* d * math.cos(self.r),
  self.y + 1.5*d*math.sin(self.r), {r = self.r})
end

function Player:update(dt)
  Player.super.update(self, dt)

  if input:down('left') then self.r = self.r - self.rv * dt end
  if input:down('right') then self.r = self.r + self.rv * dt end

  self.v = math.min(self.v + self.a * dt, self.max_v)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Player:draw()
  setColor(107, 111, 244, 255)
  love.graphics.circle('line', self.x, self.y, self.w)
  love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r),
  self.y + 2*self.w*math.sin(self.r))
  -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:destroy()
  Player.super.destroy(self)
end

return Player
