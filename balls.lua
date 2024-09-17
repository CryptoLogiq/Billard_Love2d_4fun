local balls = {debug=false, nextBall=1, white=nil}

balls.imgs = {}


function balls.new(x,y,img)
  local ball = {rotate=0, x=x or 1392, y=y or love.graphics.getHeight()/2, sx=1, sy=1, scale=1, img=img or Images[16], vx=0, vy=0}
  ball.xDef = ball.x
  ball.yDef = ball.y
  ball.z = ball.x + ball.img.ox
  ball.w = ball.img.w
  ball.h = ball.img.h
  ball.ox = ball.img.ox
  ball.oy = ball.img.oy
  --
  ball.body = love.physics.newBody(World, x or ball.x, y or ball.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  ball.shape = love.physics.newCircleShape(ball.img.oy) --the ball's shape has a radius of 20
  ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  --
  ball.fixture:setRestitution(0.9) -- let the ball bounce
  ball.body:setLinearDamping(0.5) -- friction loose when move
  --
  -- print( ball.body:getAngularDamping() ) -- 0 defaut
  -- print( ball.body:getInertia() ) -- 149 defaut
  -- print( ball.body:isFixedRotation() ) -- false defaut

  ball.body:setAngularDamping(0.5)
  ball.body:setInertia(300)
  ball.body:setAngle(love.math.random(6))

  --
  table.insert(balls, ball)
  --
  return ball
end
--

function balls.load()
  balls.white = balls.new()
end
--

function balls.update(dt)
  for n=#balls, 1, -1 do
    local ball = balls[n]

    -- grain du tapis, arret plsu rapide des balls lentes
    local vx, vy = ball.body:getLinearVelocity()
    local newvx, newvy = vx, vy
    if  vx ~= 0 and math.abs(vx) <= 1 then newvx = 0 end
    if  vy ~= 0 and math.abs(vy) <= 1 then newvy = 0 end
    if newvx ~= vx or newvy ~= vy then ball.body:setLinearVelocity(newvx, newvy) end

    -- effet d'angle sur les balls
    local effectangle = ball.body:getAngle()
    local fx = math.cos(effectangle) * math.abs(newvx*0.2)
    local fy = math.sin(effectangle) * math.abs(newvy*0.2)
    if math.abs(fx) <= 1 then fx = 0 end
    if math.abs(fy) <= 1 then fy = 0 end
    ball.body:applyForce( fx, fy )


    -- update get positions and rotate for drawing
    ball.x = ball.body:getX()
    ball.y = ball.body:getY()
    ball.vx, ball.vy = ball.body:getLinearVelocity()
    ball.rotate = ball.body:getAngle()
  end
end
--

function balls.draw()
  for n=#balls, 1, -1 do
    local ball = balls[n]

    -- show image
    love.graphics.draw(ball.img.data, ball.x, ball.y, ball.rotate, ball.sx, ball.sy, ball.img.ox, ball.img.oy)

    -- show reel position
    if balls.debug then
      -- center ball
      love.graphics.setColor(1,0,0,1)
      love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), 2)

      -- ball collider
      love.graphics.setColor(0,1,0,1)
      love.graphics.circle("line", ball.body:getX(), ball.body:getY(), ball.shape:getRadius()*ball.scale)

      love.graphics.setColor(1,1,1,1)

    end

    if ball == balls.white then
      local vx, vy = ball.body:getLinearVelocity()
      if  vx == 0 and vy == 0 then
        local x,y = ball.body:getPosition()
        local mx, my = love.mouse.getPosition()
        local angle = math.angle(mx,my, x,y)
        love.graphics.line( x, y, x+(math.cos(angle)*600), y+(math.sin(angle)*600) )
      end
    end

end
end
--

function balls.keypressed(k, scan, isRepeat)
  print(k)
  if k == "space" and #balls < 16 then
    local mx, my = love.mouse.getPosition()
    balls.new(mx,my,Images[balls.nextBall])
    balls.nextBall = balls.nextBall + 1
  end
end
--

function balls.mousepressed(x, y, button, isTouche, presses)

end
--

return balls