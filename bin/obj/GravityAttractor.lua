local GravityAttractor = Object:extend()

function GravityAttractor:new(parent, opts)
  local opts = opts or {}
  if opts then for k, v in pairs(opts) do self[k] = v end end

  self.parent = parent
  self.x, self.y = parent.x, parent.y
  self.mass = opts.mass or 1000
  self.radius = opts.radius or 100

  print(self.radius)
  self.attractors = {}

  self.current_vector = opts.inVec or Vector(0, 0)

  if not(self.parent.zone.gravity_attractors) then
    self.parent.zone.gravity_attractors = {}
  end
  table.insert(self.parent.zone.gravity_attractors, self)
end

function GravityAttractor:destroy()
  if self.parent.zone.gravity_attractors[self] then
    table.remove(self.parent.zone.gravity_attractors, self)
  end
  if self.attractors then
    self.attractors = nil
  end
end

function GravityAttractor:update(dt)
  if not self.attractors then return end
  self.x, self.y = self.parent.x, self.parent.y

  for _, gravity_attractor in ipairs(self.parent.zone.gravity_attractors) do

    if(gravity_attractor.parent ~= self.parent and
     (distance(self.x, self.y, gravity_attractor.x, gravity_attractor.y) <= self.radius)) then
      if not(self.attractors[gravity_attractor]) then
        table.insert(self.attractors, gravity_attractor)
      end
    elseif(self.attractors[gravity_attractor]) then
      table.remove(attractors, gravity_attractor)
    end
  end


  if #self.attractors > 0 then
    for _, attractor in ipairs(self.attractors) do
      local force = self:getAttractionForce(attractor)
      self:addForce(force)
    end
  end
end

function GravityAttractor:draw()
  love.graphics.circle('line', self.x, self.y, self.radius)

  if self.current_vector then
    love.graphics.line(self.x, self.y,
    self.x + self.current_vector.x * self.parent.collider:getLinearVelocity(),
    self.y + self.current_vector.y * self.parent.collider:getLinearVelocity())
  end
end

function GravityAttractor:getAttractionForce(gravity_attractor)
  local d = distance(self.x, self.y, gravity_attractor.x, gravity_attractor.y)
  local acc = ((gravity_attractor.mass * self.mass) / (d * d))

  local vec = Vector(gravity_attractor.x - self.x, gravity_attractor.y - self.y):normalized()
  local ang = vec:angleTo()

  local parent_v = self.parent.collider:getLinearVelocity()

  return Vector(vec.x * (d * math.cos(ang)) + (parent_v * math.cos(ang)),
   vec.y * (d * math.sin(ang)) + (parent_v * math.cos(ang)) )

end

function GravityAttractor:addForce(force)
  if self.parent.collider then
    self.parent.collider:setLinearVelocity(force.x, force.y)
  else
    print('No parent collider!')
  end
end

return GravityAttractor
