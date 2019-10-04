
brshLineWidth=128

brshMaxRad=128


cursorQuad = {x=0, y=0, w=64, h=64}


function toSettings()
	drawFunc=drawSettings
	updateFunc=updateSettings
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

--TODO haha compute indexes 
	love.graphics.setColor(1.0,.0,.0,1.0)
	love.graphics.line(brshLineWidth,0,brshLineWidth,uih)
	love.graphics.print('setting',400,0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(mybrush)
	
	
	
	
	
	
	-- if currentIdx-1>0 then 
		-- love.graphics.setColor(1.0,1.0,1.0,0.5)
		-- love.graphics.draw(frames[currentIdx-1].pic,offsetcvs.x,offsetcvs.y)
	-- end

	-- if frames[currentIdx+1] then 
		-- love.graphics.setColor(1.0,1.0,1.0,0.5)
		-- love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y)
	-- end
	
	-- love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	-- --antialias ink of current frame
	-- love.graphics.setShader(inksmooth)
	-- love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y)
	-- love.graphics.setShader()
	-- love.graphics.draw(mybrush,0,0)

	-- renderWidgets()
	
	msgToCvs()
	
	
	love.graphics.setCanvas()

end



function drawSettings()
	-- love.graphics.draw(buttonsPic)
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function updateSettings()
	
	if npress==true then
		if npx<brshLineWidth then
			brshradius=npy/uih * brshMaxRad
			mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,0.0,0.0,0.0))
			mybrush:setFilter('nearest','nearest')
				
		else
	
			toPaintMode()
		end
	end
end