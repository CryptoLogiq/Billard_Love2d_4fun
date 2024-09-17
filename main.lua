function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end -- get pixel distance

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end -- get radian angle

function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end -- Normaliser deux nombres.

-- Calculer la moyenne d'un nombre arbitraire d'angles (en radians).
function math.averageAngles(...)
  local x,y = 0,0
  for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
  return math.atan2(y, x)
end

Game = {debug=true}

Screen = require("screen")
Images = require("images")
WorldManager = require("worldmanager")
Tablepot = require("tablepot")
Balls = require("balls")
Cue = require("cue")

function love.load()
  Images.load()
  --
  WorldManager.load()
  --
  Tablepot.load()
  Balls.load()
  Cue.load()
end
--

function love.update(dt)
  Screen.update(dt)
  --
  World:update(dt)
  Tablepot.update(dt)
  Balls.update(dt)
  Cue.update(dt)
end
--

function love.draw()
  Images.draw()
  --
  WorldManager.draw()
  Tablepot.draw()
  Balls.draw()
  Cue.draw()
  --
  if Game.debug then
    love.graphics.print(love.timer.getFPS( ), 10, 10)
  end
end
--

function love.keypressed(k, scan, isRepeat)
  Balls.keypressed(k, scan, isRepeat)
  Cue.keypressed(k, scan, isRepeat)
end
--

function love.mousepressed(x, y, button, isTouche, presses)
  Cue.mousepressed(x, y, button,isTouche, presses)
end
--

function love.wheelmoved(x,y)
  Cue.wheelmoved(x,y)
end
--