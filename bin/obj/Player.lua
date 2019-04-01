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
  self.base_max_v = 100
  self.max_v = self.base_max_v
  self.a = 100

  self.trail_color = skill_point_color
  self.timer:every(0.01, function()
    self.zone:addGameObject('TrailParticle',
    self.x - self.w*math.cos(self.r), self.y - self.h*math.sin(self.r),
    {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
  end)

  self.attack_speed = 1
  timer:every(5, function() self.attack_speed = random(1, 2) end)

  --timer:after(1, function(func) print("foo") timer:after(1, 'func') end)
  input:bind('f4', function() self:die() end)
  input:bind('f5', function() slow(2, 2) end)

  self:autoShoot()
  self.timer:every(5, function() self:tick() end)

end

function Player:tick()
  self.zone:addGameObject('TickEffect', self.x, self.y, {parent = self})
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
  self.y + 1.5*d*math.sin(self.r), {r = self.r, v = 100})
end

function Player:update(dt)
  Player.super.update(self, dt)

  if input:down('left') then self.r = self.r - self.rv * dt end
  if input:down('right') then self.r = self.r + self.rv * dt end

  self.v = math.min(self.v + self.a * dt, self.max_v)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

  self.boosting = false
  self.braking = false

  if input:down('boost') then
    self.max_v = 1.5*self.base_max_v
    self.boosting = true
    self.trail_color = {85, 153, 204}
  elseif input:down('brake') then
    self.max_v = 0.5*self.base_max_v
    self.braking = true
    self.trail_color = {171, 64, 54}
  else
    self.max_v = self.base_max_v
    self.trail_color = skill_point_color
  end


  camera:follow(self.x, self.y)
  -- TODO Refactor to use collider instead of pure positioning
  --[[
  if self.x < 0 then self:die() end
  if self.y < 0 then self:die() end
  if self.x > gw then self:die() end
  if self.y > gh then self:die() end
  ]]--
end

function Player:draw()
  setColor(107, 111, 244, 255)
  --useColor()
  love.graphics.circle('line', self.x, self.y, self.w)
  love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r),
  self.y + 2*self.w*math.sin(self.r))
  -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:die()
  self.dead = true
  flash(4)
  for i = 1, love.math.random(8, 12) do
    self.zone:addGameObject('ExplodeParticle', self.x, self.y)
  end
  slow(0.15, 1)
  camera:shake(6, 60, 0.4)

end

function Player:destroy()
  Player.super.destroy(self)
end

return Player
