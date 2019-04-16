local Stage = Object:extend()

function Stage:new()
  self.zone = Zone(self)
  self.zone:addPhysicsWorld()
  self.zone.world:addCollisionClass('Player')
  self.zone.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
  self.zone.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
  self.zone.world:addCollisionClass('Enemy', {ignores = {'Collectable'}})

  self.static_background = DrawZone(self)
  self.static_background:addDrawable(function()
    useColor(default_color)
    love.graphics.rectangle('fill',10, 10, 10, 10)
  end)
  self.scrolling_background = DrawZone(self)
  self.scrolling_background:addDrawable(function()
    useColor(DbWater)
    love.graphics.rectangle('fill', 50, 25, 35, 95)
  end)
  self.foreground = DrawZone(self)
  self.foreground:addDrawable( function()
    useColor(default_color)
    love.graphics.rectangle('fill', 150, 75, 250, 180)
  end)

  self.widthScale = 10
  self.heightScale = 10

  self.main_canvas = love.graphics.newCanvas(gw, gh)
  self.timer = Timer()

  self.player = self.zone:addGameObject('Player', gw/2, gh/2)
  --self.zone.world:setGravity(0, 2)

  input:bind('p', function()
    --self.zone:addGameObject('Ammo', random(0, gw), random(0, gh))
    self:spawnWithinRange('Ammo', gw / 2, gh / 2)
  end)

  input:bind('b', function()
    self:spawnWithinRange('Boost', gw / 2, gh / 2)
  end)

  input:bind('h', function()
    self:spawnWithinRange('HPResource', gw / 2, gh / 2)
  end)

  input:bind('r', function()
    self:spawnWithinRange('Rock', gw / 2, gh / 2, { size = 16 })
  end)

  input:bind('q', function()
    print(self.scrolling_background)
    local color = makeRandomSwatch()
    local x, y = self.player.x + random(-gw/2, gw/2), self.player.y + random(-gh/2, gh/2)
    local w, h = random(20, 100), random(20, 100)
    self:addDrawableWithinRange(self.scrolling_background, function() useColor(color) love.graphics.rectangle('fill', x, y, w, h) end
    , gw / 2, gh / 2, { size = 16 })
  end)

  --input:bind('f8', function() self:moveLayer() end)

  camera:setFollowLerp(0.4)
  camera:setFollowLead(1)
  camera:setFollowStyle('TOPDOWN')
  camera:setBounds(0, 0, gw * self.widthScale, gh * self.heightScale)

  camera:newLayer(-10, 0, function() self.static_background:draw() end)
  camera:newLayer(-5, 0.3, function() self.scrolling_background:draw() end)
  camera:newLayer(1, 1.0, function() self.zone:draw() end)
  camera:newLayer(10, 1.8, function() self.foreground:draw() end)

end

--[[
function Stage:moveLayer()
for i = 1, #camera.layers, 1 do
local copy = camera.layers[i]
if (camera.layers[i+1]) then
local ref = camera.layers[i+1]
ref.order = copy.order
ref.scale = copy.scale
else
camera.layers[i+1] = copy
end
end
end
]]

function Stage:addDrawableWithinRange(drawZone, drawable, x, y, opts)
  useColor(hp_color)
  if type(drawable) == "string" then
    drawZone:addGameObject(drawable, self.player.x + random(0-x, x), self.player.y + random(0-y, y), opts)
  else
    drawZone:addDrawable(drawable)
  end
end

function Stage:spawnWithinRange(gameObject, x, y, opts)
  self.zone:addGameObject(gameObject, self.player.x + random(0-x, x), self.player.y + random(0-y, y), opts)
end

function Stage:update(dt)
  camera:update(dt)
  self.zone:update(dt)
  self.static_background:update(dt)
  self.scrolling_background:update(dt)
  self.foreground:update(dt)
end

function Stage:draw()

  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
  --camera:attach()
  --self.zone:draw()
  --camera:detach()
  camera:draw()
  love.graphics.setCanvas()

  setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
  self.zone:destroy()
  self.zone = nil
end

return Stage
