
nb_flick=10

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
function calculateFlickRange()
  --when starting a flick, we should ignore frames that have a tc=0, such as bg or color
  --to do that we need to precalculate the indexes of the flick frames
-- WIP TO FINISH

    if leftmode~=nil then
      --if to the left we count towards 0
      
      lpot=currentIdx
      
      for i=1,nb_flick 
      do
          lpot=lpot-1
          if lpot>0 and frames[lpot].tc>0 then 
              flickFrames[i]=lpot
              
          end
          
          if lpot<1 then
              break
          end
--        tgtflick=nb
--        print('valid flick '..  )
      end
    else
      --if to the right we count towards maxframe
      lpot=lpot-1
      if lpot<=maxframe and frames[lpot].tc>0 then 
          flickFrames[i]=lpot
          
      end
      
      if lpot>=maxframe then
          break
      end
      
    end


end

function flickRelease()
-- for some reason this corrupts frame !!
-- seems to copy initial on target

   	 --id setting and preparing cvs go together,
	 --should be func
   	 currentIdx=tgt
	 print('new idx '..currentIdx)
	initCanvases(currentIdx)

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
	dragx=0
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
	
	love.graphics.draw(frames[tgt].pic)
	
	
	
	msgToCvs()
	
	love.graphics.setCanvas()

end



function drawFlick()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,offsetcvs.x,offsetcvs.y,0,scrsx,scrsy)	

end


function updateFlick()

-- mouse drag is redefinted, it gives us a coordinate


	
	
	if leftmode == true then
		offset=dragx
	else	
		offset=uiw-dragx
	end
	-- addMsg('dragx '..dragx)
	slotwidth=uiw/nb_flick
	nbslot=math.floor(offset/slotwidth)
	addMsg('nbslot '..nbslot)
	
		
	if leftmode ==true then
    --TODO use lookup table ( to skip tc 0s )
    
		tgt= flickNb+nbslot
	else
		tgt= flickNb-nbslot
	end
	
	if tgt<1 then tgt=1 end
	if tgt>maxframe then 
		tgt=maxframe
		addMsg('tgt = maxframe')
	end
		

end