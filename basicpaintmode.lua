


--draws a line from last blit x last blit y to current coords
function basicBlitBrushLineRemember(x,y)
	print("basicBlitBrushLineRemember line x,y "..x.." "..y)
  
	
  
	local blits=calculateTraj(lastblitx,lastblity,x,y)
	
	
	love.graphics.setCanvas(cvs)

	if eraseMode== true then 
			love.graphics.setBlendMode('replace')
			--following is ok for square brush
			-- love.graphics.setShader(eraserShader)
			--alternative method
      --TODO should we not set color to 1.0,1.0,1.0, 0 ?
      -- dark alpha artifacting
      
			love.graphics.setColor(0.0,0.0,0.0,0.0)

	end
	
  if brushShader~=nil then
    print('brsh shader')
    love.graphics.setShader(brushShader)
  end 
  
	for i,b in ipairs(blits) do
		if eraseMode== true then
		--TODO why different x y ? might explain jumpiness
		       -- TODO events are actually recorded for top left of brush, refactor to do
			love.graphics.circle('fill',x+brshradius,y+brshradius,eraserRadius)
		else
			love.graphics.draw(mybrush,b.xbl,b.ybl)
		end
	end

  if brushShader~=nil then
    love.graphics.setShader()
  end 


	if eraseMode== true then 

		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.setBlendMode('alpha')

	end

--	love.graphics.setShader()

	love.graphics.setCanvas()
	

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end


initBasicPaintMode=function()
  
  blitBrushLineRemember=basicBlitBrushLineRemember
  backBufferRender=false
  penUpPaintModeCb=nil

end