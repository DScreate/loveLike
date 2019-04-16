local Rock = GameObject:extend()

function Rock:new(zone, x, y, opts)
  Rock.super.new(self, area, x, y, opts)

  --local direction = table.random({-1, 1})

  self.w = opts.w or 8
  self.h = opts.h or 8
  self.size = opts.size or 8
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

function Rock:draw()
  useColor(hp_color)
  local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
  love.graphics.polygon('line', points)
  useColor(default_color)
end

return Rock
