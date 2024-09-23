
local cue = {debug=false, power = 0, maxPower=10, isVisible = false, mode=nil}
cue.listMode = { 
  { name="soft",    speed=100,   id=1,   color={0.15,0.8,0.3,0.8} } ,
  { name="medium",  speed=300,  id=2,   color={0.3,0.15,0.8,0.8} } ,
  { name="hard",    speed=900,  id=3,   color={0.8,0.15,0.3,0.8} }
}
--

local texts = {}

local ball = nil

function cue.loadTexts()
  local font = love.graphics.getFont()
  --
  for n=1, #cue.listMode do
    local mode = cue.listMode[n]
    local txt = {}
    txt.str= "POWER".."\n"..string.upper(mode.name)
    txt.data = love.graphics.newText(font, "")
    txt.data:addf(txt.str, 50, "center")
    txt.w, txt.h = txt.data:getDimensions()
    table.insert(texts, txt)
  end
end
--

function cue.setCueMode()
  local id = cue.mode.id
  id = id + 1
  if id > #cue.listMode then id = 1 end
  cue.mode = cue.listMode[id]
end
--

function cue.resetCueMode()
  cue.mode = cue.listMode[1]
  --
  cue.power = 0
end
--

function cue.showGui()
  if ball.vx == 0 and ball.vy == 0 then
    cue.isVisible = true
  else
    cue.isVisible = false
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

function cue.drawPower()
  if cue.isVisible then
    local x, y, w, h, text, ox
    w = 26
    h = 8
    ox = w / 2
    x = 100
    y = 200
    --
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", x-26, y-2, 52, 30)
    love.graphics.setColor(0.5,0.5,0.5,1)
    love.graphics.rectangle("line", x-26, y-2, 52, 30)
    local txt = texts[cue.mode.id]
    love.graphics.setColor(cue.mode.color[1], cue.mode.color[2], cue.mode.color[3], 1)
    love.graphics.draw(txt.data, x, y, 0, 1, 1, txt.w/2)
    love.graphics.setColor(1,1,1,1)
    --
    y = y + 32
    x = x - ox
    --
    for n=10, 1, -1 do
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("line", x, y, w, h)
      if n <= cue.power then
        love.graphics.setColor(cue.mode.color[1], cue.mode.color[2], cue.mode.color[3], 1)
      else
        love.graphics.setColor(0.5,0.5,0.5,1)
      end
      love.graphics.rectangle("fill", x+1, y+1, w-2, h-2)
      love.graphics.setColor(1,1,1,1)
      y=y+(h+1)
    end
    --

  end
end
--

function cue.drawCue()
  if cue.isVisible then
    local mx, my = love.mouse.getPosition()
    cue.angle = math.angle(mx,my, ball.x,ball.y)
    local px = ball.x - ( (cue.img.ox + ball.ox + (cue.power*10)) * math.cos(cue.angle) )
    local py = ball.y - ( (cue.img.ox + ball.ox + (cue.power*10)) * math.sin(cue.angle) )
    love.graphics.draw(cue.img.data, px, py, cue.angle, 1, 1, cue.img.ox, cue.img.oy)
    love.graphics.circle("fill", px, py, 10)
  end
end
--

function cue.shoot(x, y)
  local radian = math.angle(x,y, ball.x,ball.y)
  local arx = math.cos(radian)
  local ary = math.sin(radian)
  local force = cue.power * cue.mode.speed

  --

  --    ball.body:applyLinearImpulse(arx*force, ary*force) -- impulse
  ball.body:setLinearVelocity(arx*force, ary*force) -- impulse
  --ball.body:applyAngularImpulse(love.math.random(-6.0, 6.0))

  --

  cue.resetCueMode()
end
--

function cue.load()
  ball = Balls.white
  --
  cue.resetCueMode()
  cue.img = Images.cue
  --
  cue.loadTexts()
end
--

function cue.update(dt)
  cue.showGui()
end
--

function cue.draw()
  cue.drawPower()
  cue.drawCue()
end
--

function cue.keypressed(k, scan, isRepeat)
end
--

function cue.mousepressed(x, y, button, isTouche, presses)
  if button == 1 and ball.vx == 0 and ball.vy == 0 then
    cue.shoot(x, y)
  elseif button == 2 and cue.debug then
    ball.body:setLinearVelocity(0, 0) -- impulse
    ball.body:setPosition(ball.xDef, ball.yDef) -- replace
  end

  if button == 2 and cue.isVisible then
    cue.setCueMode()
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