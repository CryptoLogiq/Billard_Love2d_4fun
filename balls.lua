local balls = {debug=false, nextBall=1, white=nil}

balls.imgs = {}


function balls.new(x,y,imgNumber)
  local ball = {rotate=0, x=x, y=y, sx=1, sy=1, scale=1, imgSource=Images[imgNumber], vx=0, vy=0}
  ball.xDef = ball.x
  ball.yDef = ball.y
  --
  ball.image = ball.imgSource.data
  ball.w = ball.imgSource.w
  ball.h = ball.imgSource.h
  ball.ox = ball.imgSource.ox
  ball.oy = ball.imgSource.oy
  --
  ball.rayon = math.max(ball.ox, ball.oy)
  ball.angle_visuel = 0 -- Angle visuel initial
  ball.z_offset = 0 -- Déplacement en Z pour l'effet de profondeur
  --
  ball.body = love.physics.newBody(World, x or ball.x, y or ball.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  ball.shape = love.physics.newCircleShape(ball.rayon) --the ball's shape has a radius of 25.5
  ball.fixture = love.physics.newFixture(ball.body, ball.shape) -- Attach fixture to body and give it a density of 1.
  --
  ball.fixture:setRestitution(0.5) -- let the ball bounce
  ball.body:setLinearDamping(0.5) -- force loose when move

  -- ball.body:getMass() -- environ 0.56
  ball.body:setMass(1) -- environ 0.56
  --
  -- print( ball.body:getAngularDamping() ) -- 0 defaut
  -- print( ball.body:getInertia() ) -- 149 defaut
  -- print( ball.body:isFixedRotation() ) -- false defaut

  ball.body:setAngularDamping(0.5)
  --ball.body:setInertia(300)
  ball.body:setAngle(love.math.random(math.rad(360)))

  --ball.body:setBullet(true) -- true = CCD / false = World:update defaut

  --
  table.insert(balls, ball)
  --
  return ball
end
--

function balls.createColumBalls(x, y, d, nbBalls)
  for n = 1, nbBalls do -- 5
    balls.new(x,	y, #balls+1)
    y = y + d
  end
end
--

function balls.createAllsBalls()

  local nextBall = 0
  local x = 441
  local y = Screen.oy
  local r = Images[1].ox
  local d = Images[1].w
  --
  y = y - (d * 2)
  local yStart = y
  --
  local nbCol = 0
  for n=5,  1, -1 do
    balls.createColumBalls(x, y, d, n)
    nbCol = nbCol + 1
    x = x + (d-6)
    y = yStart + (r*nbCol)
  end

  -- white ball
  balls.white = balls.new(1392, Screen.oy, 16)
end
--

function balls.WhiteBallDraw(ball)
  local mx, my = love.mouse.getPosition()
  local angle = math.angle(mx,my, ball.x,ball.y)
--  local dist = math.max(1, Cue.power) * ( math.min(Cue.mode.speed, Cue.listMode[2].speed) / 5 )
  local contact = 0
  local dist = 0
  love.graphics.setColor(Cue.mode.color)
  love.graphics.line(ball.x, ball.y, ball.x+(math.cos(angle)*dist), ball.y+(math.sin(angle)*dist) )
  love.graphics.setColor(1,1,1,1)
end

function balls.load()
  balls.createAllsBalls()
end
--

function balls.update(dt)
  for n=#balls, 1, -1 do
    local ball = balls[n]

    -- Obtenir la vitesse de la ball
    local vx, vy = ball.body:getLinearVelocity() -- Si tu utilises Box2D

    -- Calculer la distance parcourue
    local distance = math.sqrt(vx^2 + vy^2) * dt
    local perimetre = 2 * math.pi * ball.rayon
    local delta_angle = (distance / perimetre) * 2 * math.pi

    -- Mettre à jour l'angle visuel
    ball.angle_visuel = ball.angle_visuel + delta_angle

    -- Simuler le mouvement en Z
    ball.z_offset = 5 * math.sin(ball.angle_visuel) -- Ajuste la profondeur


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

    if ball == balls.white and Cue.isVisible then
      balls.WhiteBallDraw(ball)
    end

    -- show image
    love.graphics.draw(ball.image, ball.x, ball.y, ball.rotate, ball.sx, ball.sy, ball.ox, ball.oy)

--    -- ################### Roulement de la boule ###################
--    -- WIP

--    -- Calculer l'offset pour simuler le mouvement
--    local x, y = ball.body:getPosition()

--    love.graphics.push()
--    love.graphics.translate(x, y) -- Déplacer à la position de la ball

--    -- Calculer l'offset pour simuler le mouvement
--    local offset = ball.rayon * math.sin(ball.angle_visuel) -- Ajuste ce facteur pour le mouvement

--    -- Dessiner la première moitié de la ball (gauche)
--    love.graphics.setScissor(-ball.ox + offset, -ball.oy, ball.ox, ball.h)
--    love.graphics.draw(ball.image, 0, 0, 0, 1, 1, 0, 0) -- Dessiner la moitié gauche

--    -- Dessiner la deuxième moitié de la ball (droite)
--    love.graphics.setScissor(-ball.ox - offset, -ball.oy, ball.ox, ball.h)
--    love.graphics.draw(ball.image, 0, 0, 0, 1, 1, 0, 0) -- Dessiner la moitié droite

--    -- Réinitialiser le scissor
--    love.graphics.setScissor()

--    love.graphics.pop()
--    -- ################### -- Fin -- ###################

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

  end
end
--

function balls.keypressed(k, scan, isRepeat)
  if k == "space" and #balls < 16 then
    local mx, my = love.mouse.getPosition()
    balls.new(mx,my,balls.nextBall)
    balls.nextBall = balls.nextBall + 1
    print(mx, my)
  end
end
--

function balls.mousepressed(x, y, button, isTouche, presses)
end
--

return balls