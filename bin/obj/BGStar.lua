local BGStar = GameObject:extend()

function BGStar:new(zone, x, y, opts)
  BGStar.super.new(self, zone, x, y, opts)



end

function BGStar:update(dt)
  BGStar.super.update(self, dt)


end

function BGStar:draw()
  useColor(DbWater)


  useColor(default_color)
end

function BGStar:die()
  self.dead = true;


end

return BGStar
