function incResource(resource, amount, resource_max)
  --print('Changing resource: ' .. resource)
  resource = math.min(resource + amount, resource_max or 100)
end

function decResource(resource, amount, resource_min)
  --print('Changing resource: ' .. resource)
  resource = math.max(resource - amount, resource_min or 0)
end
