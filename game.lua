local game = {debug=true, players={}, currentPlayer=1}

local players = game.players

function game.newPlayers(nbPlayers)
  for n=1, nbPlayers do
    local newPlayer = {lstBalls={}}
    table.insert(players, newPlayer)
  end
end
--

function game.newGame()
  for n=1, #players do
    players[n].lstBalls = {}
  end
end
--

function game.drawScore()
  local startX = Tablepot.decX + (Tablepot.img.ox/2)
  local y = 45
  local w = Images[1].w
  local h = Images[1].h
  local d = Images[1].w
  local r = d / 2
  --
  for n=1, #players do
    local p = players[n]
    --
    local x = startX - (#p.lstBalls * d)
    --
    love.graphics.print("Joueur "..tostring(n), x-r, y-(r+18) )
    --
    if #p.lstBalls >= 1 then
      --
      for n=1, #p.lstBalls do
        local ball = p.lstBalls[n]
        love.graphics.draw(ball.image, x, y, 0, 1, 1, ball.ox, ball.oy)
        x = x + d
      end
      --
    else
      love.graphics.rectangle("line", x-r, y-r, w, h)
      love.graphics.circle("line", x, y, r)
    end
    --
    startX = startX + Tablepot.img.ox
  end
end
--

function game.load()
  game.newPlayers(2)
  game.newGame()
end
--

function game.update(dt)
end
--

function game.draw()
  game.drawScore()
  --
  if Game.debug then
    love.graphics.print(love.timer.getFPS( ), 10, 10)
  end
end
--

function game.keypressed(k, scan, isRepeat)
end
--

function game.mousepressed(x, y, button, isTouche, presses)
end
--

return game