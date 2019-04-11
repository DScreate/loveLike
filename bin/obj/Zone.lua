local Zone = Object:extend()

function Zone:new(room)
  print('Making Zone')
  self.room = room
  self.game_objects = {}
end

function Zone:getAllGameObjectsThat(filter)
    local out = {}
    for _, game_object in pairs(self.game_objects) do
        if filter(game_object) then
            table.insert(out, game_object)
        end
    end
    return out
end

function Zone:addPhysicsWorld()
  self.world = Physics.newWorld(0, 0, true)
end

function Zone:update(dt)
  if self.world then self.world:update(dt) end

  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i]
    game_object:update(dt)
    if game_object.dead then
      game_object:destroy()
      table.remove(self.game_objects, i)
    end
  end
end

function Zone:draw()
  table.sort(self.game_objects, function(a, b)
    if a.depth == b.depth then return a.creation_time < b.creation_time
    else return a.depth < b.depth end
  end)

  -- Uncomment this line to view colliders within zone
  if self.world then self.world:draw() end
  for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Zone:addGameObject(game_object_type, x, y, opts, ...)
  local opts = opts or {}
  local game_object = _G[game_object_type](self, x or 0, y or 0, opts, ...)
  game_object.class = game_object_type
  table.insert(self.game_objects, game_object)
  return game_object
end

function Zone:destroy()
  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i]
    game_object:destroy()
    table.remove(self.game_objects, i)
  end
  self.game_objects = {}

  if self.world then
    self.world:destroy()
    self.world = nil
  end
end

function Zone:queryCircleArea(x, y, r, object_types)
  local res = {}
  for _, gameObject in ipairs(self.game_objects) do
    if M.cotains(object_types, game_objects.class) then
      if (distance(x, y, gameObject.x, gameObject.y) < r) then
        table.insert(res, game_object)
      end
    end
  end

  return res
end

return Zone
