function random(min, max)
  local min, max = min or 0, max or 1
  return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function gaussRandom(min, max, skew)
  local u, v = random(0,1), random(0,1)


  local num = math.sqrt(-2 * math.log(u)) * math.cos(2 * math.pi * v)
  if(num > 1 or num < 0) then gaussRandom(min, max, skew) end
  num = math.pow(num, skew)
  num = num * (max - min)
  num = num + min

  return num
end

function UUID()
  local fn = function(x)
    local r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function createIrregularPolygon(point_amount, size)
  local point_amount = point_amount or 8
  local size = size or 8
  local points = {}
  for i = 1, point_amount do
    local angle_interval = 2*math.pi/point_amount
    local distance = size + random(-size/4, size/4)
    local angle = (i-1)*angle_interval + random(-angle_interval/4, angle_interval/4)
    table.insert(points, distance*math.cos(angle))
    table.insert(points, distance*math.sin(angle))
  end
  return points

end

function areRectanglesOverlapping(x1, y1, x2, y2, x3, y3, x4, y4)
  return not (x3 > x2 or x4 < x1 or y3 > y2 or y4 < y1)
end

function setColor(r, g, b, a)
  love.graphics.setColor(r/255, g/255, b/255, (a or 255)/255)
end

function useColor(swatch)
  love.graphics.setColor(swatch[1]/255, swatch[2]/255, swatch[3]/255, (swatch[4] or 255)/255)
end

function makeRandomSwatch(r, g, b, a)
  local red = r or random(0,255)
  local green = g or random(0,255)
  local blue = b or random(0,255)
  local alpha = a or 255

  return {red, green, blue, alpha}
end

function invertSwatch(swatch)
  return {255 - swatch[1], 255 - swatch[2], 255 - swatch[3], 255}
end
function table.random(t)
  return t[love.math.random(1, #t)]
end

function pushRotate(x, y, r)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.translate(-x, -y)
end

function pushRotateScale(x, y, r, sx, sy)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.scale(sx or 1, sy or sx or 1)
  love.graphics.translate(-x, -y)
end

function printAll(...)
  local args = {...}
  local string = ''
  for _, arg in ipairs(args) do
    string = string .. arg
  end
  print(string)
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end

-- GARBAGE COLLECTION CHECKING --
function count_all(f)
  local seen = {}
  local count_table
  count_table = function(t)
    if seen[t] then return end
    f(t)
    seen[t] = true
    for k,v in pairs(t) do
      if type(v) == "table" then
        count_table(v)
      elseif type(v) == "userdata" then
        f(v)
      end
    end
  end
  count_table(_G)
end

function type_count()
  local counts = {}
  local enumerate = function (o)
    local t = type_name(o)
    counts[t] = (counts[t] or 0) + 1
  end
  count_all(enumerate)
  return counts
end

global_type_table = nil
function type_name(o)
  if global_type_table == nil then
    global_type_table = {}
    for k,v in pairs(_G) do
      global_type_table[v] = k
    end
    global_type_table[0] = "table"
  end
  return global_type_table[getmetatable(o) or 0] or "Unknown"
end
