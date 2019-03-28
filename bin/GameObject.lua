local GameObject = Object:extend()

function GameObject:new(zone, x, y, opts)
    print('Creating gameObject')
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.zone = zone
    self.x, self.y = x, y
    self.dead = false
    self.timer = Timer()
    self.id = UUID()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()

end

return GameObject
