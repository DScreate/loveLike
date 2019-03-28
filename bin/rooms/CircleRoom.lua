local CircleRoom = Object:extend()

function CircleRoom:new()
  -- body...
  self.zone = Zone()
  self.timer = Timer()

  self.zone:addGameObject('Circle', random(0, 800), random(0, 600), {}, random(25, 50))
  self:populate()
end


function CircleRoom:populate()
  timer:cancel('depopulate')
  timer:every(0.25, function()
    self.zone:addGameObject('Circle', random(0, 800), random(0, 600), {}, random(25, 50))
  end, 10, function()
    --print('after triggered')
    self:depopulate()
  end)
end

function CircleRoom:depopulate()
  --print('depopulate called')
  timer:every(random(0.5, 1), function()
    table.remove(self.zone.game_objects, love.math.random(1, #self.zone.game_objects))
    if #self.zone.game_objects == 0 then
      -- restart
      self:populate()
    end
  end,'depopulate')
end

function CircleRoom:update(dt)
  -- body...
  self.zone:update(dt)
end

function CircleRoom:draw()
  self.zone:draw()
end

return CircleRoom
