local cue = {power = 0, maxPower=10, speed=500, guiIsVisible = false}

local ball = nil

function cue.load()
  if not Balls.white then
    print("Cue need load after Balls lua")
  else
    ball = Balls.white
  end
end
--

function cue.update(dt)
  for n=1, #Balls do
    local b = Balls[n]
    if ball.vx ~= 0 and ball.vy ~= 0 then
      cue.guiIsVisible = false
      return false
    end
  end
  cue.guiIsVisible = true
  return true
end
--

function cue.draw()
  if cue.guiIsVisible then
    local x, y, w, h
    w = 25
    h = 8
    x = ball.x - 50
    y = ball.y - ball.oy - ( ((h+1)*10) + 18 )
    --
    love.graphics.print("Power", x, y)
    y = y + 18
    --
    for n=10, 1, -1 do
      love.graphics.setColor(0.15,0.25,0.3,1)
      love.graphics.rectangle("line", x, y, w, h)
      if n <= cue.power then
        love.graphics.setColor(0.15,1,0.3,1)
        love.graphics.rectangle("fill", x, y, w, h)
      end
      love.graphics.setColor(1,1,1,1)
      y=y+(h+1)
    end
    --
  end
end
--

function cue.keypressed(k, scan, isRepeat)
end
--

function cue.mousepressed(x, y, button, isTouche, presses)
  --
  local ball = Balls.white
  --
  local radian = math.angle(x,y, ball.x,ball.y)
  local arx = math.cos(radian)
  local ary = math.sin(radian)
  local force = cue.power * cue.speed
  --
  if button == 1 and ball.vx == 0 and ball.vy == 0 then
    ball.body:setLinearVelocity(arx*force, ary*force) -- impulse
    ball.body:applyAngularImpulse(love.math.random(-6.0, 6.0))
    cue.power = 0
  elseif button == 2 then
    ball.body:setLinearVelocity(0, 0) -- impulse
    ball.body:setPosition(ball.xDef, ball.yDef) -- replace
  end

end
--


function cue.wheelmoved(x,y)
  --print(x,y) --  y = 1 up  //  y = -1 down

  cue.power = cue.power + y

  if cue.power < 0 then
    cue.power = 0 
  elseif cue.power > cue.maxPower then
    cue.power = cue.maxPower
  end

end
--

return cue