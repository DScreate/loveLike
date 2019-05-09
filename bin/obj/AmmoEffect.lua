local AmmoEffect = GameObject:extend()

function AmmoEffect:new(zone, x, y, opts)
    AmmoEffect.super.new(self, zone, x, y, opts)
    self.depth = 75

    self.current_color = ammo_color
    self.timer:after(0.1, function()
      self.current_color = self.color or makeRandomSwatch()
      self.timer:after(0.15, function()
        self.dead = true
      end)
    end)
end

function AmmoEffect:update(dt)
    AmmoEffect.super.update(self, dt)
end

function AmmoEffect:draw()
    useColor(self.current_color)
    draft:rhombus(self.x, self.y, self.w, self.h, 'fill')
end

function AmmoEffect:destroy()
    AmmoEffect.super.destroy(self)
end

return AmmoEffect
