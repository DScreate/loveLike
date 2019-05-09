local Ammo = GameObject:extend()

function Ammo:new(zone, x, y, opts)
  Ammo.super.new(self, zone, x, y, opts)

  self.w, self.h = 8, 8
  self.attract_distance = 100
  self.collider = self.zone.world:newRectangleCollider(self.x, self.y, self.w, self.h)
  self.collider:setCollisionClass('Collectable')
  self.collider:setObject(self)
  self.collider:setFixedRotation(false)
  self.r = random(0, 2*math.pi)
  self.v = random(10, 20)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
  self.collider:applyAngularImpulse(random(-24, 24))

  self.modAmount = opts.modAmount or 2
end

function Ammo:modifyResource(player)
  incResource(player.ammo, player.max_ammo or 100, self.modAmount)
end



function Ammo:update(dt)
  Ammo.super.update(self, dt)
  local target = current_room.player
  if target and distance(self.x, self.y, target.x, target.y) < self.attract_distance then
    local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
    local angle = math.atan2(target.y - self.y, target.x - self.x)
    local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
    local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
    self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
    self.current_vector = final_heading
  else
    if self.current_vector then
      self.collider:setLinearVelocity(self.v*self.current_vector.x, self.v*self.current_vector.y)
    else
      self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    end
  end
end

function Ammo:draw()
  useColor(ammo_color)
  pushRotate(self.x, self.y, self.collider:getAngle())
  draft:rhombus(self.x, self.y, self.w, self.h, 'line')
  love.graphics.pop()
  love.graphics.setColor(default_color)

  --love.graphics.circle('line', self.x, self.y, self.attract_distance)

  --[[
  if self.current_vector then
    love.graphics.line(self.x, self.y,
    self.x + self.current_vector.x * self.v, self.y + self.current_vector.y * self.v)
  end
  ]]
end

function Ammo:die()
  self.dead = true
  local colorEffect = makeRandomSwatch()
  self.zone:addGameObject('AmmoEffect', self.x, self.y,
  {color = colorEffect, w = self.w, h = self.h})
  for i = 1, love.math.random(4, 8) do
    self.zone:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = colorEffect})
  end
end

return Ammo
