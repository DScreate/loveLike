local InfoText = GameObject:extend()

function InfoText:new(zone, x, y, opts)
  InfoText.super.new(self, zone, x, y, opts)
  self.depth = 80

  self.font = fonts.m5x7_16
  self.w, self.h = self.font:getWidth(self.text), self.font:getHeight()
  local all_info_texts = self.zone:getAllGameObjectsThat(function(o)
    if o:is(InfoText) and o.id ~= self.id then
      return true
    end
  end)
  local collidesWithOtherInfoText = function()
    for _, info_text in ipairs(all_info_texts) do
      return areRectanglesOverlapping(
      self.x, self.y, self.x + self.w, self.y + self.h,
      info_text.x, info_text.y, info_text.x + info_text.w, info_text.y + info_text.h)
    end
  end

  while collidesWithOtherInfoText() do
    self.x = self.x + table.random({-1, 0, 1})*self.w
    self.y = self.y + table.random({-1, 0, 1})*self.h
  end

  self.characters = {}
  self.background_colors = {}
  self.foreground_colors = {}
  for i = 1, #self.text do
    table.insert(self.characters, self.text:utf8sub(i, i))
  end

  local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
  self.visible = true
  self.timer:after(0.7, function()
    self.timer:every(0.05, function() self.visible = not self.visible end, 6)
    self.timer:every(0.7/10, function()
      for i, character in ipairs(self.characters) do
        if love.math.random(1, 20) <= 4 then
          -- change character
          local r = love.math.random(1, #random_characters)
          self.characters[i] = random_characters:utf8sub(r, r)
        else
          -- don't change
          self.characters[i] = character
        end
        if love.math.random(1, 20) <= 6 then
          -- change background color
          self.background_colors[i] = table.random(all_colors)
        else
          -- set background color to transparent
          self.background_colors[i] = nil
        end

        if love.math.random(1, 20) <= 1 then
          -- change foreground color
          if self.background_colors[i] then
            self.foreground_colors[i] = invertSwatch(self.background_colors[i])
          else
            self.foreground_colors[i] = makeRandomSwatch()
          end
        else
          -- set foreground color to imported color
          self.foreground_colors[i] = nil
        end
      end
    end)
  end)
  self.timer:after(1.10, function() self.dead = true end)



end

function InfoText:update(dt)
  InfoText.super.update(self, dt)
end

function InfoText:draw()
  if not self.visible then return end

  love.graphics.setFont(self.font)
  for i = 1, #self.characters do
    local width = 0
    if i > 1 then
      for j = 1, i - 1 do
        width = width + self.font:getWidth(self.characters[j])
      end
    end
    if self.background_colors[i] then
      useColor(self.background_colors[i])
      love.graphics.rectangle('fill', self.x + width, self.y - self.font:getHeight()/2,
      self.font:getWidth(self.characters[i]), self.font:getHeight())
    end

    useColor(self.foreground_colors[i] or self.color or default_color)
    love.graphics.print(self.characters[i], self.x + width, self.y,
    0, 1, 1, 0, self.font:getHeight()/2)
  end
  useColor(default_color)
end

return InfoText
