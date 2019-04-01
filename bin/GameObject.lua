local GameObject = Object:extend()

function GameObject:new(zone, x, y, opts)
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.zone = zone
    self.x, self.y = x, y
    self.dead = false
    self.depth = 50
    self.timer = Timer()
    self.creation_time = love.timer.getTime()
    self.id = UUID()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw()

end

function GameObject:destroy()
  self.timer:destroy()
  if self.collider then self.collider:destroy() end
  self.collider = nil
end

return GameObject
