local Rock = GameObject:extend()

function Rock:new(zone, x, y, opts)
  Rock.super.new(self, area, x, y, opts)

  --local direction = table.random({-1, 1})


  self.w = opts.w or 8
  self.h = opts.h or 8
  self.size = opts.size or 8
  self.hp = opts.hp or 10 * self.size

  self.points = opts.points or 8
  self.collider = self.zone.world:newPolygonCollider(createIrregularPolygon(self.points, self.size))
  self.collider:setPosition(self.x, self.y)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Enemy')
  self.collider:setFixedRotation(false)
  self.r = random(0, 2*math.pi)
  self.v = random(10, 20)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
  self.collider:applyAngularImpulse(random(-100, 100))
end

function Rock:update(dt)
  Rock.super.update(self, dt)
end

function Rock:hit(damage)
  self.hp = self.hp - damage
  if self.hp <= 0 then
    self:die()
  else
    self.hit_flash = true
    self.timer:after(0.2, function() self.hit_flash = false end)
  end
end

function Rock:draw()
  useColor(hp_color)
  local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
  love.graphics.polygon('line', points)
  useColor(default_color)
end

function Rock:die()
  self.dead = true
  self.zone:addGameObject('EnemyDeathEffect', self.x, self.y,
  {color = hp_color, w = self.w * self.size/4})
  local v = self.collider:getLinearVelocity()
  for i = 1, love.math.random(12, 16) do
    self.zone:addGameObject('ExplodeParticle', self.x, self.y, {color = hp_color, s = random(3,6),
    r = random(0, v) })
  end

  if (self.size > 2 and random(0, self.size) > 2) then
    for i = 1, love.math.random(0, self.size/2) do
      self.zone:addGameObject('Rock', self.x, self.y, { size = self.size / random(2, 4)})

    end
  end
end


return Rock
