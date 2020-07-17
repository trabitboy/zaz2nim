--we exchange these reference every blit 

--we put this through the shader filter 
local srcCvs=nil

--this is where we blit ( should be blank before blit )
local tgtCvs=nil

--IMPORTANT DIFFERENCE in basic paint, we paint directly on cvs;
-- in shader paint, there is a display cvs for result of operation, and a src cvs
function initPaintUnderBlitMode()
  
  --when we enter blit mode , we need to make a copy in a canvas/tex
  --that will be the source for our operation--
  --remember, shader is tex( cvs size ) -> filter with brush tex -> cvs 
  
  --TODO not 2 , but 3 buffers : the 2 ping pongs for drawing,
  -- which are copied to display buffer after blit
  
  
  srcCvs = love.graphics.newCanvas(conf.cvsw,conf.cvsh)
  love.graphics.setCanvas(srcCvs)
  love.graphics.draw(cvs)
  
  tgtCvs = cvs
  
  blitBrushLineRemember=paintUnderBlitBrushLineRemember

  
end

-- uses 2 circular canvas to paint from one to the other 
--draws a line from last blit x last blit y to current coords
function paintUnderBlitBrushLineRemember(x,y)
	print("blit line x,y "..x.." "..y)
  
  --DUMB test before shader impl
  love.graphics.setCanvas(tgtCvs)
  
  love.graphics.draw(mybrush,x,y)
  
  love.graphics.setCanvas()
  
  
  --we rotate buffers
  
  
  
  --for display
  
  
  
  
  
  --lets just blit a very simple thing using shader and the ping pong buffers to begin with
	
  -- let's just blit something at x y
  
  
--	local blits=calculateTraj(lastblitx,lastblity,x,y)
	
	
--	love.graphics.setCanvas(cvs)

--	if eraseMode== true then 
--			love.graphics.setBlendMode('replace')
--			--following is ok for square brush
--			-- love.graphics.setShader(eraserShader)
--			--alternative method
--			love.graphics.setColor(0.0,0.0,0.0,0.0)

--	end
	
--  if brushShader~=nil then
--    print('brsh shader')
--    love.graphics.setShader(brushShader)
--  end 
  
--	for i,b in ipairs(blits) do
--		if eraseMode== true then
--		--TODO why different x y ? might explain jumpiness
--		       -- TODO events are actually recorded for top left of brush, refactor to do
--			love.graphics.circle('fill',x+brshradius,y+brshradius,eraserRadius)
--		else
--			love.graphics.draw(mybrush,b.xbl,b.ybl)
--		end
--	end

--  if brushShader~=nil then
--    love.graphics.setShader()
--  end 


--	if eraseMode== true then 

--		love.graphics.setColor(1.0,1.0,1.0,1.0)
--		love.graphics.setBlendMode('alpha')

--	end

----	love.graphics.setShader()

--	love.graphics.setCanvas()
	

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end
