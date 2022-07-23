--dft setting
framerate=8
cycles=60/framerate 


local function playFrom (param)
	drawFunc=drawPlayback
	updateFunc=updatePlayback
	npress=false
	cyclecount=0
	--we use it to throttle longer frames
	elapsedTc=0
	pbIdx=param



end


function playFromFirst()
	 playFrom(1)
end


function toPlayback()
	 playFrom(currentIdx)
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,0.5)

	love.graphics.setColor(1.,1.,1.,1.0)
	love.graphics.rectangle('fill',offsetcvs.x,offsetcvs.y,conf.cvsw*applicativezoom,conf.cvsh*applicativezoom)



	--we blit optional BG
	local key = 'f'..pbIdx
	if mybg[key]~=nil then
	   love.graphics.draw(frames[mybg[key]].pic,offsetcvs.x,offsetcvs.y)

	end

--TO TEST display color frame 
	lprevidx=pbIdx-1
  if lprevidx>0 and frames[lprevidx].cf==true then
    love.graphics.draw(frames[lprevidx].pic,offsetcvs.x,offsetcvs.y)
    
  end
	love.graphics.draw(frames[pbIdx].pic,offsetcvs.x,offsetcvs.y)
	
	
	msgToCvs()
	
	
	love.graphics.setCanvas()

end



function drawPlayback()
	-- love.graphics.draw(buttonsPic)
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,0.0)--
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end

--data structure where we put a current repetition marker
currentRepetition=nil
-- contains the source repetition structure, including a transient data for the numer of run
--= {trigger=3,target=1,repetition=4, iteration= 1 -- 3 more to go, then we cancel  }

function updatePlayback()
	
	cyclecount=cyclecount+1
	if cyclecount>cycles then
		cyclecount=0
		elapsedTc=elapsedTc+1
		print('elapsed tc '..elapsedTc)
		if elapsedTc>=frames[pbIdx].tc then
      --TODO check if next frame is a trigger, let a marker to say once finished,
      -- you go to loop
      
			pbIdx=pbIdx+1
      --only work for one tc 0
      if (frames[pbIdx].tc<1 and pbIdx<maxframe)then
        print('skipping 0tc frame')
        pbIdx=pbIdx+1
      end
      
      
      --TODO should be mutualized with export
      
      --if we are already in a repetition, we do not look
      -- (overlap forbidden )
      if currentRepetition~=nil then
        print('in a repetition , we do not look for more')
        
        --if we are in a repetition and new frame number is higher than trigger,
        if pbIdx>currentRepetition.trigger then
        --either we jump back ( still valid )
          if currentRepetition.iteration<currentRepetition.repetition then
            pbIdx=currentRepetition.target
            currentRepetition.iteration=currentRepetition.iteration+1
          else
        --or we cancel repetition ( it is other )
            currentRepetition.iteration=nil
            currentRepetition=nil
          end
        end
        
        
      else
        --we look for apotential new one
        local pot =repetitions[pbIdx]
        if pot~=nil then 
          print(' repetition pointer on frame '..pbIdx)
          print(' repetitions for new idx,tgt: '..pot.target )
          
          --TODO setup
          currentRepetition=pot
          currentRepetition.iteration=0 --we jump on frame end
        else 
          print('no repetition for frame '..pbIdx)
        end
      
      end
      
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
      currentIdx=pbIdx
      initCanvases(currentIdx)

			resetUndo()
			toPaintMode()
		-- end
	end
end