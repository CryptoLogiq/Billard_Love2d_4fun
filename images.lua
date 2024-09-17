local images = {debug=false, current=1}
local folder = "Assets"

function images.new(pfolder, pfile)
  local name = string.sub(pfile, 1, (#pfile)-4)
  local img = { name=name, source=pfile , data=love.graphics.newImage(pfolder.."/"..pfile) }
  img.w, img.h = img.data:getDimensions()
  img.ox = img.w / 2
  img.oy = img.h / 2
  table.insert(images, img)
  images[name] = img
  return img
end
--

function images.load()
  local files = love.filesystem.getDirectoryItems(folder)
  for n=1, 16 do
    local filename = "ball_"..tostring(n)..".png"
    images.new(folder, filename)
  end
  --
  images.new(folder, "cue.png")
  images.new(folder, "table.png")
  images.new(folder, "table_colliders.png")
  images.new(folder, "triangle.png")
  --
  images.current = #images - 2
end
--

function images.draw()
  if images.debug and #images > 0 then
    local img = images[images.current]
    local x = (love.graphics.getWidth()/2)
    local y = (love.graphics.getHeight()/2)
    love.graphics.draw(img.data, x, y, 0, 1, 1, img.ox, img.oy)
    love.graphics.print("Img sizes : w="..tostring(img.w)..", h="..tostring(img.h), 5, love.graphics.getHeight()-20)
  end
end
--

function images.keypressed(k, scan, isRepeat)
  if images.debug and #images > 0 then
    if k == "right" then
      images.current = images.current + 1
      if images.current > #images then images.current = 1 end
    elseif k == "left" then
      images.current = images.current - 1
      if images.current < 1 then images.current = #images end
    elseif k == "up" then
      images.current = #images - 2
      if images.current < 1 then images.current = #images end
    end
  end
end
--

return images