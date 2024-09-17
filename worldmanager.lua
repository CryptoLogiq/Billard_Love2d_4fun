local WorldManager = {debug=false}
World = {}
local w = {}

--[[
Billard Anglais (pool) dimensions de jeu : 1,830 m x 0,915 m
Boules Anglais dimensions : 50.8 mm de diametre

ratio ok :
table inferieur de 16,89%
]]--

function WorldManager.newWorld(meter, xGravity, yGravity, sleep)

  local m = meter or 1
  local xg = xGravity or 0
  local yg = yGravity or 0
  local s = sleep or true
  love.physics.setMeter(m)
  World = love.physics.newWorld(xg*m, yg*m, s)
end
--

function WorldManager.load()
  WorldManager.newWorld(64)
end
--

function WorldManager.draw(xpos, ypos)
  if WorldManager.debug then

    local x = xpos or 10
    local y = ypos or 10
    local txt = "World Debug : \n"
    for k, v in pairs(w) do
      txt = txt .. tostring(k).."\t"..tostring(v()) .. "\n"
    end
    love.graphics.print(txt, x, y)

  end
end
--


function w.getBodies()
  return World:getBodies() --	Returns a table with all bodies.	Added since 11.0	
end
--
function w.getBodyCount()
  return World:getBodyCount() --	Returns the number of bodies in the w.		
end
--
function w.getCallbacks()
  return World:getCallbacks() --	Returns functions for the callbacks during the w update.		
end
--
function w.getContactCount()
  return World:getContactCount() --	Returns the number of contacts in the w.	Added since 0.8.0	
end
--
function w.getContactFilter()
  return World:getContactFilter() --	Returns the function for collision filtering.	Added since 0.8.0	
end
--
function w.getContacts()
  return World:getContacts() --	Returns a table with all Contacts.	Added since 11.0	
end
--
function w.getGravity()
  return World:getGravity() --	Get the gravity of the w.		
end
--
function w.getJointCount()
  return World:getJointCount() --	Returns the number of joints in the w.		
end
--
function w.getJoints()
  return World:getJoints() --	Returns a table with all joints.	Added since 11.0	
end
--
function w.isDestroyed()
  return World:isDestroyed() --	Gets whether the World is destroyed.	Added since 0.9.2	
end
--
function w.isLocked()
  return World:isLocked() --	Returns if the w is updating its state.	Added since 0.8.0	
end
--
function w.isSleepingAllowed()
  return World:isSleepingAllowed() --Gets the sleep behaviour of the w.
end
--

return WorldManager