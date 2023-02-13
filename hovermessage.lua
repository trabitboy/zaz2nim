
--TODO try first on copy frame or eraser toggle

--currently rendered msg stored here
local currentMsg= nil
local fadeTimer= 0 --if fade timer is 0, msg is transparent
local initialFadeTimer=0 --used to calculate transparency


setHoverMsg=function(msg,time)
  if time==nil then
    fadeTimer=60
  else
    fadeTimer=time
  end
  initialFadeTimer=fadeTimer
  currentMsg=msg
end

--to be called last on each screen that needs hover msgs
displayHoverMsg=function()
  
  
  
  if fadeTimer>0 then
    fadeTimer= fadeTimer-1
  end
  
  if currentMsg~=nil and fadeTimer>0 then
    --WIP centering test trying printf instead
--    local width=#currentMsg * 4 * 8
    
    love.graphics.setColor(0,0,0,fadeTimer/initialFadeTimer)
--    love.graphics.print(currentMsg,64*buttonZoom,0,0,buttonZoom*4,buttonZoom*4)
    love.graphics.printf(currentMsg,64*buttonZoom,0,400,'left',0,buttonZoom*4,buttonZoom*4)
    love.graphics.setColor(1,1,1,1)
  end
end