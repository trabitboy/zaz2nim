--first touch/simulated blit will fill this
local firstCol={x=-1,y=-1}
local lastCol={x=-1,y=-1}

--draws a line from last blit x last blit y to current coords
function mixBasicBlitBrushLineRemember(x,y)
	print("mixPaintbasicBlitBrushLineRemember line x,y "..x.." "..y)
  
  --if first call, store x y 
  if firstCol.x==-1 and firstCol.y==-1 then
    firstCol.x=x
    firstCol.y=y
  else
    lastCol.x=x
    lastCol.y=y
  end
	
  
  
--	local blits=calculateTraj(lastblitx,lastblity,x,y)
	
	
--	love.graphics.setCanvas(cvs)

--	if eraseMode== true then 
--			love.graphics.setBlendMode('replace')
--			--following is ok for square brush
--			-- love.graphics.setShader(eraserShader)
--			--alternative method
--      --TODO should we not set color to 1.0,1.0,1.0, 0 ?
--      -- dark alpha artifacting
      
--			love.graphics.setColor(0.0,0.0,0.0,0.0)

--	end
	
--  --DBG should not be a shader here
--  -- for basic ( looks a cut n paste mistake )
----  if brushShader~=nil then
----    print('brsh shader')
----    love.graphics.setShader(brushShader)
----  end 
  
--	for i,b in ipairs(blits) do
--		if eraseMode== true then
--		--TODO why different x y ? might explain jumpiness
--		       -- TODO events are actually recorded for top left of brush, refactor to do
--			love.graphics.circle('fill',x+brshradius,y+brshradius,eraserRadius)
--		else
--			love.graphics.draw(mybrush,b.xbl,b.ybl)
--		end
--	end

----  if brushShader~=nil then
----    love.graphics.setShader()
----  end 


--	if eraseMode== true then 

--		love.graphics.setColor(1.0,1.0,1.0,1.0)
--		love.graphics.setBlendMode('alpha')

--	end

----	love.graphics.setShader()

--	love.graphics.setCanvas()
	

--	lastblitx=x
--	lastblity=y
	
--	dirtycvs=true
end


mixPaintPenUpCB=function()
  --add msg first and last pos color
  addMsg(' first '..firstCol.x.. ' ' .. firstCol.y)
  
end

initMixPaintBasicMode=function()
  firstCol={x=-1,y=-1}
  lastCol={x=-1,y=-1}

  blitBrushLineRemember=mixBasicBlitBrushLineRemember
  backBufferRender=false
  penUpPaintModeCb=nil
  basicPaintUnderMode=false

end