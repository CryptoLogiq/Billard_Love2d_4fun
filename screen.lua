local screen = {}
screen.w, screen.h = love.graphics.getDimensions()
screen.ox, screen.oy = screen.w/2, screen.h/2

function screen.update(dt)
  screen.w, screen.h = love.graphics.getDimensions()
  screen.ox, screen.oy = screen.w/2, screen.h/2
end
--

return screen