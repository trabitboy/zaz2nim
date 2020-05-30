--dft setting
framerate=8
cycles=60/framerate 




function toPlayback()
	drawFunc=drawPlayback
	updateFunc=updatePlayback
	npress=false
	cyclecount=0
	--we use it to throttle longer frames
	elapsedTc=0
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

-- --TODO haha compute indexes 
	-- love.graphics.setColor(1.0,.0,.0,1.0)
	-- love.graphics.line(brshLineWidth,0,brshLineWidth,uih)
	-- love.graphics.print('setting',400,0)
	-- love.graphics.setColor(1.0,1.0,1.0,1.0)
	-- love.graphics.draw(mybrush)
	
	
	love.graphics.draw(frames[currentIdx].pic)
	
	
	
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



function drawPlayback()
	-- love.graphics.draw(buttonsPic)
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function updatePlayback()
	
	cyclecount=cyclecount+1
	if cyclecount>cycles then
		cyclecount=0
		elapsedTc=elapsedTc+1

		if elapsedTc>=frames[currentIdx].tc then
			currentIdx=currentIdx+1
			elapsedTc=0
		end
	end
	
	
	if currentIdx>=maxframe then
		currentIdx=1
		toPaintMode()
		return
	end
	
	if npress==true and npx<64 and npy<64 then
		-- if npx<brshLineWidth then
			-- brshradius=npy/uih * brshMaxRad
			-- mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,0.0,0.0,0.0))
			-- mybrush:setFilter('nearest','nearest')
				
		-- else
	
			toPaintMode()
		-- end
	end
end