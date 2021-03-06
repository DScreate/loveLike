local Player = GameObject:extend()

function Player:new(zone, x, y, opts)
  Player.super:new(zone, x, y, opts)

  self.x, self.y = x, y
  self.w, self.h = 12, 12

  -- Collision setup
  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Player')


  self.r = -math.pi/2
  self.rv = 1.66*math.pi
  self.v = 0
  self.base_max_v = 100
  self.max_v = self.base_max_v
  self.a = 100
  self.max_boost = 100
  self.boost = self.max_boost
  self.can_boost = true
  self.boost_timer = 0
  self.boost_cooldown = 2

  self.max_hp = 100
  self.hp = self.max_hp

  self.max_ammo = 100
  self.ammo = self.max_ammo

  --self.shoot_timer = 0
  --self.shoot_cooldown = 0.24
  -- ATTACK DVC
  self.ammo_cost = 0
  self.attack_speed = 1
  self.attack = 'Neutral'
  --

  self:setAttack('Neutral')

  self.trail_color = skill_point_color
  self.timer:every(0.01, function()
    self.zone:addGameObject('TrailParticle',
    self.x - self.w*math.cos(self.r), self.y - self.h*math.sin(self.r),
    {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
  end)

  --timer:every(5, function() self.attack_speed = random(1, 2) end)

  --timer:after(1, function(func) print("foo") timer:after(1, 'func') end)
  input:bind('f4', function() self:die() end)
  input:bind('f5', function() slow(2, 2) end)
  input:bind('t', function() self:setAttack('Double') end)
  input:bind(',', function() self:setAttack('Big') end)

  self:autoShoot()
  self.timer:every(5, function() self:tick() end)

end

function Player:addAmmo(amount)
  print('Adding ammo')
  self.ammo = math.max(math.min(self.ammo + amount, self.max_ammo), 0)
end

function Player:addBoost(amount)
  print('Adding boost')
  self.boost = math.max(math.min(self.boost + amount, self.max_boost), 0)
end

function Player:addHP(amount)
  print('Adding HP')
  self.hp = math.max(math.min(self.hp + amount, self.max_hp), 0)
end

function Player:setAttack(attack)
  self.attack = attack
  self.attack_speed = attacks[attack].attack_speed
  self.ammo = self.max_ammo
  --self.ammo_cost = attacks[attack].ammo_cost
end

function Player:tick()
  self.zone:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:autoShoot()
  self.timer:after(0.48/self.attack_speed, function()
    AttackActions[self.attack](self)
    self:autoShoot()
  end)
  if self.ammo <= 0 then
    self:setAttack('Neutral')
    self.ammo = self.max_ammo
  end
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.boost = math.min(self.boost + 10*dt, self.max_boost)
  -- self.boost_timer = self.boost_timer + dt
  if self.boost_timer > self.boost_cooldown then self.can_boost = true
  else self.boost_timer = self.boost_timer + dt end

  if input:down('left') then self.r = self.r - self.rv * dt end
  if input:down('right') then self.r = self.r + self.rv * dt end

  self.v = math.min(self.v + self.a * dt, self.max_v)
  self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

  self.boosting = false
  self.braking = false

  if input:down('boost') and self.boost > 1 and self.can_boost then
    self.max_v = 2.0*self.base_max_v
    self.boosting = true
    self.trail_color = {85, 153, 204}
    self.boost = self.boost - 50*dt
    if self.boost <= 1 then
      self.boosting = false
      self.can_boost = false
      self.boost_timer = 0
    end
  elseif input:down('brake') and self.boost > 1 and self.can_boost then
    self.max_v = 0.5*self.base_max_v
    self.braking = true
    self.trail_color = {171, 64, 54}
    self.boost = self.boost - 50*dt
    if self.boost <= 1 then
      self.boosting = false
      self.can_boost = false
      self.boost_timer = 0
    end
  else
    self.max_v = self.base_max_v
    self.trail_color = skill_point_color
  end

  -- TODO Make collision checks into switch for more generic implementation
  if self.collider:enter('Collectable') then
    local collision_data = self.collider:getEnterCollisionData('Collectable')
    local object = collision_data.collider:getObject()
    if object.modifyResource then
      object:modifyResource(self)
    end
    object:die()
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

function Player:addAmmo(amount)
  self.ammo = math.min(self.ammo + amount, self.max_ammo)
end

function Player:draw()
  --setColor(107, 111, 244, 255)
  useColor({107, 111, 244})
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
