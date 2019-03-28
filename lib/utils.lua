function random(m, n)
  i = love.math.random() * (m - n) + n
  --print('random from m: ' .. m .. ', n: ' .. n .. ' result: ' .. i)
  return i
end

function UUID()
  local fn = function(x)
    local r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
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