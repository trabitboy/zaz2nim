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
	pbIdx=currentIdx
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

	--we blit optional BG
	local key = 'f'..pbIdx
	if mybg[key]~=nil then
	   love.graphics.draw(frames[mybg[key]].pic)

	end


	
	love.graphics.draw(frames[pbIdx].pic)
	
	
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
		print('elapsed tc '..elapsedTc)
		if elapsedTc>=frames[pbIdx].tc then
			pbIdx=pbIdx+1
			elapsedTc=0
			print('next frame')

			--we trigger sound if new frame has one
			if frames[pbIdx].sound~=nil then
			   print('playing sound for frame  '..pbIdx)
			   love.audio.play(frames[pbIdx].sound)
			end

		end
	end
	
	
	if pbIdx>=maxframe then
		pbIdx=1
		toPaintMode()
		return
	end
	
	if npress==true and npy>(conf.cvsh-256) then
		-- if npx<brshLineWidth then
			-- brshradius=npy/uih * brshMaxRad
			-- mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,0.0,0.0,0.0))
			-- mybrush:setFilter('nearest','nearest')
				
		-- else
	
			toPaintMode()
		-- end
	end
end