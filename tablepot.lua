local tablepot = {debug=false}

local polygons = {pos={}, max=8}

function tablepot.newPollyCollider(x1,y1, x2,y2, x3,y3, x4,y4)
  local new = {x1=x1,y1=y1, x2=x2,y2=y2, x3=x3,y3=y3, x4=x4,y4=y4}
  new.body = love.physics.newBody(World, tablepot.decX, tablepot.decY, "static") -- x,y from its center
  new.shape = love.physics.newPolygonShape(x1,y1, x2,y2, x3,y3, x4,y4) --make a rectangle
  new.fixture = love.physics.newFixture(new.body, new.shape) --attach shape to body
  table.insert(tablepot, new)
end
--

function tablepot.newCircleCollider(x, y, r)
  local new = {x=x, y=y, r=r}
  new.body = love.physics.newBody(World, x, y, "static") -- x,y from its center
  new.shape = love.physics.newCircleShape(r) --make a rectangle
  new.fixture = love.physics.newFixture(new.body, new.shape) --attach shape to body
  table.insert(tablepot, new)
end
--

function tablepot.newRectCollider(x, y, w, h)
  local new = {x=x, y=y, w=w, h=h}
  new.ox = w/2
  new.oy = h/2
  new.body = love.physics.newBody(World, x, y, "static") -- x,y from its center
  new.shape = love.physics.newRectangleShape(w, h) --make a rectangle
  new.fixture = love.physics.newFixture(new.body, new.shape) --attach shape to body
  table.insert(tablepot, new)
end
--

function tablepot.load()
  tablepot.img = Images.table
  tablepot.x = 0
  tablepot.y = 0
  tablepot.w = tablepot.img.w
  tablepot.h = tablepot.img.h

  tablepot.decX = (Screen.w - tablepot.w) / 2
  tablepot.decY = (Screen.h - tablepot.h) / 2

  tablepot.newPollyCollider(132,84,     846,84,     833,115,    164,115)
  tablepot.newPollyCollider(932,84,     1654,84,    1622,115,   946,115)

  tablepot.newPollyCollider(84,144,     84, 871,    115,839,    115,175)
  tablepot.newPollyCollider(1684,175,   1684,839,   1715,871,   1715,144)

  tablepot.newPollyCollider(134,931,    848,931,    834,900,    166,900)
  tablepot.newPollyCollider(932,931,    1653, 931,  1621,900,   946,900)
end
--

function tablepot.update(dt)
end
--

function tablepot.draw()
  love.graphics.draw(tablepot.img.data, Screen.ox, Screen.oy, 0, 1, 1, tablepot.img.ox, tablepot.img.oy)
  --
  if tablepot.debug then
    for n=1, #tablepot do
      local collider = tablepot[n]
      love.graphics.polygon("fill", collider.body:getWorldPoints(collider.shape:getPoints())) -- draw a "filled in" polygon
    end
  end
end
--

function tablepot.keypressed(k, scan, isRepeat)
end
--

function tablepot.mousepressed(x, y, button, isTouche, presses)
end
--

return tablepot