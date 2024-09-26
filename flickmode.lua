
nb_flick=10

-- it is the displayed frame, and will become the new currentIdx when you releaseBon
local tgt=nil

local dragx=nil
local leftmode=nil

local flickFrames={
        -- 1,2,4,6 nb_flick numbers
      }

--ui scaled
function dragFlick(me,x,y,dx,dy)
	-- addMsg('drag flick called')
	dragx=x

end


--WIP 
--TODO add logs for range calculated 
function calculateFlickRange()
  --when starting a flick, we should ignore frames that have a tc=0, such as bg or color
  --to do that we need to precalculate the indexes of the flick frames
-- WIP TO FINISH

    if leftmode==true then
      --if to the left we count towards 0
      print('towards left mode')
      
--      lpot=currentIdx+1
      lpot=currentIdx
      --lets skip if current frame is color
      if frames[lpot].tc==0 then 
        lpot=lpot-1
        print('skipping current frame because tc=0')
      end 
      
      
      for i=1,nb_flick 
      do
          --slot 0 is current slot (before moving flick)                                                               
          local slot=i-1
          if lpot<1 then
              
              flickFrames[slot]=1
              print(' slot '..slot..' frame '..lpot)
              --TODO all slots still need to be filled with last picked up number, otherwise it will
              --crash if you flick to empty slot
--              break
          end
          
          --TODO if first one is a color or tc=0 frame, skip until first suitable
          --(otherwise instant crash)
          if lpot>0 and frames[lpot].tc>0 then 
              flickFrames[slot]=lpot
              print(' slot '..slot..' frame '..lpot)
          end
          
          
          
          lpot=lpot-1

--        tgtflick=nb
--        print('valid flick '..  )
      end
      --end of loop
      
    else
      print('right mode')
      --TODO copy do loop above
      
      --if to the right we count towards maxframe
--      lpot=currentIdx-1
      lpot=currentIdx
      
      --lets skip if current frame is color
      if frames[lpot].tc==0 then 
        lpot=lpot+1
        print('skipping current frame because tc=0')
      end 
      
      for i=1,nb_flick 
      do
          local slot=i-1
          if lpot>maxframe then
                flickFrames[slot]=maxframe
                print(' slot '..slot..' frame '..lpot)
              
              --break
          end
          
          
          if lpot<=maxframe and frames[lpot].tc>0 then 
              flickFrames[slot]=lpot
              print(' slot '..slot..' frame '..lpot)
          end
          
        lpot=lpot+1

      end
      
      
      
      
    end


end

function flickRelease()
-- for some reason this corrupts frame !!
-- seems to copy initial on target

   	 --id setting and preparing cvs go together,
	 --should be func
   if tgt~=nil then
   	 currentIdx=tgt
   end
	 print('new idx '..currentIdx)
	initCanvases(currentIdx)


  leftmode=nil
	 toPaintMode()

end


-- function tst()
	-- addMsg('tst')
-- end


function toFlick(bleft)
	 -- let s make sure we save our lates drawing
	saveCanvasToFrame(currentIdx)

	leftmode=bleft
	drawFunc=drawFlick
	updateFunc=updateFlick
  
  if bleft==true then
    dragx=uiw
  else
    dragx=0
  end
	flickNb=currentIdx
	tgt=currentIdx
  
  calculateFlickRange()
  
	registerdrag={drag=dragFlick,dragrelease=flickRelease}
	-- registerdrag={drag=tst}
end

function toLeftFlick()
	toFlick(true)
end

function toRightFlick()
	toFlick(false)
end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
  
	
	--we blit optional BG
	local key = 'f'..tgt
	if mybg[key]~=nil then
	   love.graphics.draw(frames[mybg[key]].pic,offsetcvs.x,offsetcvs.y)

	end

  if tgt~=nil then
    love.graphics.draw(frames[tgt].pic,offsetcvs.x,offsetcvs.y)
	end
	
  --WIP rdr frame num not current idx changed when flicking, look in model
	love.graphics.setColor(1.0,0.0,0.0,1.0)
  love.graphics.print(tgt,0,0,0,4,4)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	msgToCvs()
	
	love.graphics.setCanvas()

end



function drawFlick()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function updateFlick()

-- mouse drag is redefinted, it gives us a coordinate
	
	if leftmode == false then
		offset=dragx
	else	
		offset=uiw-dragx
	end
	-- addMsg('dragx '..dragx)
	slotwidth=uiw/nb_flick
	nbslot=math.floor(offset/slotwidth)
	addMsg('nbslot '..nbslot)
  
    print('nbslot '..nbslot)
		
--	if leftmode ==true then
    --TODO use lookup table ( to skip tc 0s )
    potTgt=flickFrames[nbslot]
    if potTgt~=nil then
      tgt=potTgt
    else
      --to display nothing
      tgt=nil
    end
    
		--tgt= flickNb+nbslot
--	else
--		tgt= flickNb-nbslot
--	end
	
--	if tgt<1 then tgt=1 end
--	if tgt>maxframe then 
--		tgt=maxframe
--		addMsg('tgt = maxframe')
--	end
		

end