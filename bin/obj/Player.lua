local Player = GameObject:extend()

function Player:new(zone, x, y, opts)
  Player.super:new(zone, x, y, opts)

  --self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.collider = self.zone.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
end

function Player:update(dt)
  Player.super:update(dt)
end

function Player:draw()
  love.graphics.circle('line', self.x, self.y, self.w)
  -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:destroy()
    Player.super.destroy(self)
end

return Player
