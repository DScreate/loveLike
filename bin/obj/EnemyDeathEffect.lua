local EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(zone, x, y, opts)
    EnemyDeathEffect.super.new(self, zone, x, y, opts)
    self.depth = 75

    self.size = opts.size or 1

    self.current_color = default_color
    self.timer:after(0.1, function()
      self.current_color = self.color
      self.timer:after(0.15, function()
        self.dead = true
      end)
    end)
end

function EnemyDeathEffect:update(dt)
    EnemyDeathEffect.super.update(self, dt)
end

function EnemyDeathEffect:draw()
    useColor(self.current_color)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w * self.size, self.w * self.size)
end

function EnemyDeathEffect:destroy()
    EnemyDeathEffect.super.destroy(self)
end

return EnemyDeathEffect
