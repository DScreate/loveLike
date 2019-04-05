local Boost = GameObject:extend()

function Boost:new(zone, x, y, opts)
  Boost.super.new(self, zone, x, y, opts)

  self.depth = 75
  self.w, self.h = 12, 12
  --self.attract_distance = 100
  self.collider = self.zone.world:newRectangleCollider(self.x, self.y, self.w, self.h)
  self.collider:setCollisionClass('Collectable')
  self.collider:setObject(self)
  self.collider:setFixedRotation(true)
  --self.collider:setAngle(9)
  self.r = random(0, 2*math.pi)
  self.v = random(10, 20)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
  --self.collider:applyAngularImpulse(random(-24, 24))
end

function Boost:update(dt)
  Boost.super.update(self, dt)
end

function Boost:draw()
  useColor(boost_color)
  --pushRotate(self.x, self.y, self.collider:getAngle())
  draft:rhombus(self.x, self.y, 1.5*self.w, 1.5*self.h, 'line')
  draft:rhombus(self.x, self.y, 0.5*self.w, 0.5*self.h, 'fill')
  --love.graphics.pop()
  useColor(default_color)
end

function Boost:die()
  self.dead = true
  local colorEffect = makeRandomSwatch()
  self.zone:addGameObject('BoostEffect', self.x, self.y,
  {color = colorEffect, w = self.w, h = self.h})

end

return Boost
