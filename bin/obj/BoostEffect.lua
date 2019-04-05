local BoostEffect = GameObject:extend()

function BoostEffect:new(zone, x, y, opts)
  BoostEffect.super.new(self, zone, x, y, opts)

  self.depth = 75

  self.sx, self.sy = 1, 1
  self.timer:tween(0.35, self, {sx = 2, sy = 2}, 'in-out-cubic')

  self.current_color = opts.color or default_color
  self.timer:after(0.2, function()
    self.current_color = self.color
    self.timer:after(0.35, function()
      self.dead = true
    end)
  end)

  self.visible = true
  self.timer:after(0.2, function()
    self.timer:every(0.05, function() self.visible = not self.visible end, 6)
    self.timer:after(0.35, function() self.visible = true end)
  end)

end

function BoostEffect:update(dt)
  BoostEffect.super.update(self, dt)
end

function BoostEffect:draw()
  if not self.visible then return end

  useColor(self.current_color)
  draft:rhombus(self.x, self.y, 1.34*self.w, 1.34*self.h, 'fill')
  draft:rhombus(self.x, self.y, 3*self.w, 3*self.h, 'line')
  useColor(default_color)

end

function BoostEffect:destroy()
  BoostEffect.super.destroy(self)
end


return BoostEffect
