
--WIP, not working to try to stop heat problems on laptop idling:
--we render to screen only on new event
--local renderScreen=false

--disable light table
lightTable=true

--canvas coordinates
lastblitx=nil
lastblity=nil

--back buffer render : some paint mode need the backbuffer to be displayed
--TODO probably having a encapsulated render function by paint mode would be better
backBufferRender=false

--some modes like basic paint under need a cb
penUpPaintModeCb=nil

--this function varies greatly depending on paint mode
-- it stores previous paint coords for next call 
--default when starting app
blitBrushLineRemember=  basicBlitBrushLineRemember


--alternatePaintmode
--BAD not a good approach as when shader painting , you pass cvs and bursh through shader, not just brush
--WIP REFACTOR 
brushShader=nil



--used when creating brush when resizing and changing color
--defined in load because crash ?
--currentBrushFunc=roundBrushWithGradient

displayBg=true

paintcolor={r=0.,g=0.,b=0.}


--step to change tool size with keyboard shortcuts
brushKeyStep=4

--on stylus up we do a copy to one of the undobuffers

--maximum undo
undoDepth=7
--this is a circular buffer of cvs we overwrite
undoBuf={} --table with undodepth canvases, we cycle the frame we paint on
currentUndoBuf=1-- this changes as we paint,next target buffer
currentUndoDepth=0 -- how many steps undo can go back

initUndoBuffers()

eraseMode = false -- FOR DEBUG
eraserRadius=16 --dflt

--dirtyDisplay
-- idea : render to a temp canvas,
-- do this whole render only when screen changes
-- ( paint , etc ) because x230t gets pretty hot in hd


 decoBgQuad={x=2*64, y=2*64, w=64, h=64}
	realDecoBgQuad=love.graphics.newQuad(decoBgQuad.x,decoBgQuad.y,decoBgQuad.w,decoBgQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

 decoSoundQuad={x=1*64, y=10*64, w=64, h=64}
	realDecoSoundQuad=love.graphics.newQuad(decoSoundQuad.x,decoSoundQuad.y,decoSoundQuad.w,decoSoundQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


 decoHardBrushQuad={x=2*64, y=9*64, w=64, h=64}
	realHardBrushQuad=love.graphics.newQuad(decoHardBrushQuad.x,decoHardBrushQuad.y,decoHardBrushQuad.w,decoHardBrushQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

 decoSoftBrushQuad={x=2*64, y=10*64, w=64, h=64}
	realSoftBrushQuad=love.graphics.newQuad(decoSoftBrushQuad.x,decoSoftBrushQuad.y,decoSoftBrushQuad.w,decoSoftBrushQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


repDecoQuad = {x=2*64, y=12*64, w=64, h=64}
	realRepDecoQuad=love.graphics.newQuad(repDecoQuad.x,repDecoQuad.y,repDecoQuad.w,repDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

beginRangeDecoQuad = {x=0*64, y=12*64, w=64, h=64}
realDecoBeginRangeQuad=love.graphics.newQuad(beginRangeDecoQuad.x,beginRangeDecoQuad.y,beginRangeDecoQuad.w,beginRangeDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


endRangeDecoQuad = {x=0*64, y=13*64, w=64, h=64}
realDecoEndRangeQuad=love.graphics.newQuad(endRangeDecoQuad.x,endRangeDecoQuad.y,endRangeDecoQuad.w,endRangeDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


decoColorFrameQuad = {x=2*64, y=16*64, w=64, h=64}
realDecoColorFrameQuad=love.graphics.newQuad(decoColorFrameQuad.x,decoColorFrameQuad.y,decoColorFrameQuad.w,decoColorFrameQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

--TODO 
underPMDecoQuad = {x=2*64, y=11*64, w=64, h=64}
realUnderPMDecoQuad=love.graphics.newQuad(underPMDecoQuad.x,underPMDecoQuad.y,underPMDecoQuad.w,underPMDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

addQuad = {x=0, y=320, w=64, h=64}
prevQuad = {x=0, y=64, w=64, h=64}
nextQuad = {x=0, y=0, w=64, h=64}
saveQuad = {x=0, y=128, w=64, h=64}
penQuad=  {x=64, y=192, w=64, h=64}
undoQuad = {x=64*5, y=64, w=64, h=64}
eraserQuad = {x=0, y=192, w=64, h=64}
settingsQuad = {x=0, y=10*64, w=64, h=64}
copyQuad = {x=0, y=8*64, w=64, h=64}
pasteQuad = {x=0, y=9*64, w=64, h=64}
lflickQuad = {x=0, y=6*64, w=64, h=64}
rflickQuad = {x=0, y=7*64, w=64, h=64}
bucketQuad = {x=64,y=0, w=64, h=64}

local incRepQuad={x=2*64, y=15*64, w=32, h=32}
local decRepQuad={x=2*64+32, y=15*64, w=32, h=32}



--index of the source frame
copySrc=nil


function incRep()
  print('inc rep')
  --TODO
  local r=isFrameInRepetition(currentIdx)
-- recreate buttons if changing frame, meh?
	if r~=nil then 
    r.repetition=r.repetition+1
  end
end

function decRep()
  print('dec rep')
  --TODO
  local r=isFrameInRepetition(currentIdx)
-- recreate buttons if changing frame, meh?
	if r~=nil and r.repetition>1 then 
    r.repetition=r.repetition-1
  end
end



function bucket()
	 --sends to pick mode in alternate state
	 toFloodFill()
end


--when moving frames
function resetUndo()
	 print('undo reset')
	 currentUndoDepth=0

end

--WIP WE NEED TO RESTORE PREVIOUS FRAME, NOT THE ONE WE JUST SAVED
--WIP adds anti alias on TAB A 16
function undoLastStroke()
	 print('###############')
	 print('undo pressed')
	 --we need undo depth > 1 to restore
	 if currentUndoDepth>1 then
	    print('undo depth '..currentUndoDepth)

	    --next undo target will be the last backed up version
	    --which is identical to current cvs
	    local targetIdx = currentUndoBuf-1
	    if targetIdx<1 then
	       targetIdx=undoDepth
	    end

	    local restoreIdx= targetIdx-1
	    if restoreIdx<1 then
	       restoreIdx=undoDepth
	    end

	    print('restoring undo idx  '..restoreIdx)
	    print(undoBuf[restoreIdx])

	    

	    love.graphics.setCanvas(cvs)
	    love.graphics.clear(1.,1.,1.,0.)
-- for test !!
--	    love.graphics.setColor(1.,0.,0.,1.)

      --tentative fix for undo that blurs the screen
      --WIP BUG not working on taba , maybe on store undo buf?
      undoBuf[restoreIdx]:setFilter('nearest','nearest')
      
      love.graphics.draw(undoBuf[restoreIdx])
  -- we need to also restore data for flood fill to work
      --doesnt help
      --frames[currentIdx].data:release()
      --frames[currentIdx].data= undoBuf[restoreIdx]:newImageData()
        
	    --local data  =  
      
--	    data:encode("png",conf.prjfld.."undotest.png")


--	    love.graphics.print('debug',400,400)
	    --for some reason breaks display other wise
	    --TODO prints everywhere to follow state changes
	    love.graphics.setCanvas()

	    currentUndoBuf=targetIdx -- we just freed it, new target
	    currentUndoDepth=currentUndoDepth-1
	    print('new undo depth '..currentUndoDepth ..' new target '..currentUndoBuf)
	    else
		print('no undo possible')
	    end


end

function copyFrame()
	copySrc=currentIdx
end

function pasteFrame()
  if copySrc~=nil then
    love.graphics.setCanvas(cvs)
    frames[copySrc].pic:setFilter('nearest','nearest')
    love.graphics.draw(frames[copySrc].pic)
    
    love.graphics.setCanvas()
  end
end


--doesnt work in insertion for some reason
function addFrame()
	newid = love.image.newImageData(conf.cvsw,conf.cvsh)
	newp=love.graphics.newImage(newid)
	-- table.insert(frames,{pic=newp,data=newid})
  newFrameIdx=currentIdx+1
	table.insert(frames,newFrameIdx,{pic=newp,data=newid,tc=1,dirty=true})
  
	maxframe=maxframe+1
	print('number of frames '..maxframe)
  
  print('all frames after '..newFrameIdx..'shifted ')
  flagShiftedFrames(newFrameIdx)

	maxFrameReached=maxFrameReached+1
	print('max frames reached at a given point '..maxFrameReached)

	maintainBgRanges()
  maintainRepetitionsFrameAddition(newFrameIdx)
  saveCanvasToUndo()
  
  --reuse
  nextFrame()
end

function prevFrame()
		if currentIdx>1 then
			addMsg("previous")
			print('previous, saving canvas')
			--save canvas to frame
			saveCanvasToFrame(currentIdx)
			
			currentIdx=currentIdx-1
			print("frame down")
			initCanvases(currentIdx)

			resetUndo()
      createPaintButtons()
    


    --loop to end of project
		elseif currentIdx==1 then
			addMsg("end prj")
			--save canvas to frame
			saveCanvasToFrame(currentIdx)
			
			currentIdx=maxframe
			initCanvases(currentIdx)

			resetUndo()
      createPaintButtons()
		end

end

function nextFrame()
    print('max frame '..maxframe)
		if currentIdx<maxframe then
			addMsg("next")
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)

			currentIdx=currentIdx+1
			print("frame up")
			initCanvases(currentIdx)

			resetUndo()
      saveCanvasToUndo()
      createPaintButtons()
		elseif currentIdx>=maxframe then
			addMsg("looping")
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)

			currentIdx=1
			initCanvases(currentIdx)

			resetUndo()
      saveCanvasToUndo()
      createPaintButtons()
		end


end

function toggleEraser()
	eraseMode= true

end
function togglePen()
	eraseMode= false

end


local widgets={}

--tables to store button creation configurations
--all buttons on the left,2 columns
--all buttons on the right, 2 columns
--1 column left and 1 column right (default)

--WIP

togglePaintButtons=function ()
	if currentConfButtons==confButtonsDefault then
		currentConfButtons=confButtonsRight
	else
		currentConfButtons=confButtonsDefault
	end
	createPaintButtons()
end


confButtonsDefault={
	--left
	{x=0,y=0,call=prevFrame,quad=prevQuad},
	{x=0,y=64*buttonZoom,call=toRightFlick,quad=rflickQuad},
	{x=0,y=uih-320*buttonZoom,call=undoLastStroke,quad=undoQuad},
	{x=0,y=uih-256*buttonZoom,call=togglePen,quad=penQuad},
	{x=0,y=uih-192*buttonZoom,call=toggleEraser,quad=eraserQuad},
	{x=0,y=uih-128*buttonZoom,call=copyFrame,quad=copyQuad},
	{x=0,y=uih-64*buttonZoom,call=addFrame,quad=addQuad},

	--right
	{x=uiw-64*buttonZoom,y=0,call=nextFrame,quad=nextQuad},
	{x=uiw-64*buttonZoom,y=64*buttonZoom,call=toLeftFlick,quad=lflickQuad},
	{x=uiw-64*buttonZoom,y=128*buttonZoom,call=togglePaintButtons,quad=undoQuad},
	{x=uiw-64*buttonZoom,y=192*buttonZoom,call=toSettings,quad=settingsQuad},
	{x=uiw-64*buttonZoom,y=uih-192*buttonZoom,call=bucket,quad=bucketQuad},
	{x=uiw-64*buttonZoom,y=uih-128*buttonZoom,call=pasteFrame,quad=pasteQuad},


	{x=uiw-64*buttonZoom,y=uih-64*buttonZoom,call=initSaveScreenFromPaintMode,quad=saveQuad},

}



--conf buttons 2 columns right
confButtonsRight={
	--left
	{x=uiw-128*buttonZoom,y=0,call=prevFrame,quad=prevQuad},
	{x=uiw-128*buttonZoom,y=64*buttonZoom,call=toRightFlick,quad=rflickQuad},
	{x=uiw-128*buttonZoom,y=uih-320*buttonZoom,call=undoLastStroke,quad=undoQuad},
	{x=uiw-128*buttonZoom,y=uih-256*buttonZoom,call=togglePen,quad=penQuad},
	{x=uiw-128*buttonZoom,y=uih-192*buttonZoom,call=toggleEraser,quad=eraserQuad},
	{x=uiw-128*buttonZoom,y=uih-128*buttonZoom,call=copyFrame,quad=copyQuad},
	{x=uiw-128*buttonZoom,y=uih-64*buttonZoom,call=addFrame,quad=addQuad},

	--right
	{x=uiw-64*buttonZoom,y=0,call=nextFrame,quad=nextQuad},
	{x=uiw-64*buttonZoom,y=64*buttonZoom,call=toLeftFlick,quad=lflickQuad},
	{x=uiw-64*buttonZoom,y=128*buttonZoom,call=togglePaintButtons,quad=undoQuad},
	{x=uiw-64*buttonZoom,y=192*buttonZoom,call=toSettings,quad=settingsQuad},
	{x=uiw-64*buttonZoom,y=uih-192*buttonZoom,call=bucket,quad=bucketQuad},
	{x=uiw-64*buttonZoom,y=uih-128*buttonZoom,call=pasteFrame,quad=pasteQuad},
	{x=uiw-64*buttonZoom,y=uih-64*buttonZoom,call=initSaveScreenFromPaintMode,quad=saveQuad},
}

currentConfButtons=
confButtonsDefault
-- confButtonsRight

createPaintButtons=function()
  widgets={}

  createfromconf=true


  if createfromconf==true then
	print('NEW creating paint buttons from conf')
	for k,v in ipairs(
		currentConfButtons
		-- confButtonsDefault
		-- confButtonsRight
	)
	do
	  local w=createpicbutton(v.x,v.y,buttonsPic,v.call,v.quad,buttonZoom)
	  table.insert(widgets,w)
	end
	return
  end
  print('LEGACY creating paint buttons')
  local wPrevFrame=createanpicbutton(0,0,buttonsPic,prevFrame,prevQuad,buttonZoom)


  local wSaveFrames=createpicbutton(uiw-64*buttonZoom,uih-64*buttonZoom,buttonsPic,initSaveScreenFromPaintMode,saveQuad,buttonZoom)

  local wLeftFlick = createpicbutton(uiw-64*buttonZoom,64*buttonZoom,buttonsPic,toLeftFlick,lflickQuad,buttonZoom)

  --top right
  local wNextFrame=createanpicbutton(uiw-64*buttonZoom,0,buttonsPic,nextFrame,nextQuad,buttonZoom)
  local wRightFlick = createpicbutton(0,64*buttonZoom,buttonsPic,toRightFlick,rflickQuad,buttonZoom)
  local wSettings=createpicbutton(uiw-64*buttonZoom,192*buttonZoom,buttonsPic,toSettings,settingsQuad,buttonZoom)
  local r=isFrameInRepetition(currentIdx)
-- recreate buttons if changing frame, meh?
	if r~=nil then 
    local wIR =createpicbutton(uiw-64*buttonZoom,144*buttonZoom,buttonsPic,incRep,incRepQuad,buttonZoom)
    table.insert(widgets,wIR)
    local wDR =createpicbutton(uiw-32*buttonZoom,144*buttonZoom,buttonsPic,decRep,decRepQuad,buttonZoom)
    table.insert(widgets,wDR)
  end



  --bottom right
  local wBucket=createpicbutton(uiw-64*buttonZoom,uih-192*buttonZoom,buttonsPic,bucket,bucketQuad,buttonZoom)
  local wPasteFrame=createanpicbutton(uiw-64*buttonZoom,uih-128*buttonZoom,buttonsPic,pasteFrame,pasteQuad,buttonZoom)


  --bottom left
  local wUndo=createanpicbutton(0,uih-320*buttonZoom,buttonsPic,undoLastStroke,undoQuad,buttonZoom)
  local wTogglePen=createanpicbutton(0,uih-256*buttonZoom,buttonsPic,togglePen,penQuad,buttonZoom)
  local wToggleEraser=createanpicbutton(0,uih-192*buttonZoom,buttonsPic,toggleEraser,eraserQuad,buttonZoom)
  local wCopyFrame=createanpicbutton(0,uih-128*buttonZoom,buttonsPic,copyFrame,copyQuad,buttonZoom)
  local wAddFrame=createanpicbutton(0,uih-64*buttonZoom,buttonsPic,addFrame,addQuad,buttonZoom)





  table.insert(widgets,wAddFrame)
  table.insert(widgets,wPrevFrame)
  table.insert(widgets,wNextFrame)
  table.insert(widgets,wSaveFrames)
  table.insert(widgets,wTogglePen)
  table.insert(widgets,wToggleEraser)
  table.insert(widgets,wCopyFrame)
  table.insert(widgets,wPasteFrame)
  table.insert(widgets,wSettings)
  table.insert(widgets,wLeftFlick)
  table.insert(widgets,wRightFlick)
  table.insert(widgets,wUndo)
  table.insert(widgets,wBucket)

end


--main paint mode, paints to current canvas, displays light table and side buttons
onionDepth=1 --TODO

currentIdx=2


function initCanvases(idx)
	--we only init current to canvas, rest is programmatic ( different from zazanim, 
	-- to have multiple tranparency layers
	currentIdx=idx
	
	--init canvas with loaded pic
	love.graphics.setCanvas(cvs)
	love.graphics.clear(1.,1.,1.,0.)
	--DBG
	-- love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
  frames[currentIdx].pic:setFilter('nearest','nearest')
	love.graphics.draw(frames[currentIdx].pic,0,0)
	
	love.graphics.setCanvas()
	
end




local function rendertouicanvas()
	love.graphics.setCanvas(ui)

-- this clear defines the base of the canvas, it is at the moment used
-- by inksmooth shader 
	love.graphics.clear(0.,0.,0.,.0)


	--let's blit a rectangle behind the frames so we see boundaries
	love.graphics.setColor(1.,1.,1.,1.0)
  
  
	love.graphics.rectangle('fill',offsetcvs.x,offsetcvs.y,conf.cvsw*applicativezoom,conf.cvsh*applicativezoom)
  
  if checkerboardAlpha==true then
    --if we want alpha display ^^ (hack)
    love.graphics.setColor(.5,.5,.5,1.0)
    local nsqw=conf.cvsw*applicativezoom/32
    nsqw=math.floor(nsqw)
    local nsqh=conf.cvsh*applicativezoom/32
    nsqh=math.floor(nsqh)
    local dsq=false
    for j =1,nsqh 
    do
      for i=1,nsqw 
      do
        dsq= not dsq
        if dsq==true then
          love.graphics.rectangle('fill',offsetcvs.x+i*32,offsetcvs.y+j*32,32,32)
        end
      end
    end
  love.graphics.setColor(1.,1.,1.,1.0)
  end
  
	--we blit optional BG
	local key = 'f'..currentIdx
	if mybg[key]~=nil and displayBg==true then
	   love.graphics.draw(frames[mybg[key]].pic,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)

	end


--we dont blit light table for color frame
	if lightTable==true and currentIdx-1>0 and frames[currentIdx].cf==nil then 
		love.graphics.setColor(1.0,1.0,1.0,0.2)
		love.graphics.draw(frames[currentIdx-1].pic,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)
	end

	if lightTable==true and frames[currentIdx+1] and frames[currentIdx].cf==nil then 
		love.graphics.setColor(1.0,1.0,1.0,0.2)
		love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	--antialias ink of current frame
--	love.graphics.setShader(inksmooth)
  if backBufferRender==true then
    
    love.graphics.draw(backBufferCvs,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)
    
  end
	love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)

  --if frame is color frame, we display the line art on top
	if frames[currentIdx].cf==true then 
		love.graphics.setColor(1.0,1.0,1.0,1.)
		love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)
	end
  

--	love.graphics.setShader()
  
	love.graphics.draw(mybrush)

	renderWidgets(widgets)

	love.graphics.setColor(1.0,0.0,0.0,1.0)
	
	love.graphics.print('tc '..frames[currentIdx].tc,200,0,0,2,2)

	love.graphics.print("frame "..currentIdx,400,0,0,2,2)
	love.graphics.setColor(1.0,1.0,1.0,1.0)

	msgToCvs()


	--render brush for user friendliness
	if eraseMode==true then
    --TODO should be done with a negative shader
    love.graphics.setColor(1.0,0.0,1.0,1.0)
	  love.graphics.circle('line',hoverx,hovery,eraserRadius/applicativezoom)
    love.graphics.setColor(1.0,1.0,1.0,1.0)
	else
		love.graphics.draw(mybrush,hoverx-brshradius*applicativezoom,hovery-brshradius*applicativezoom,0,applicativezoom,applicativezoom)
	end


	if frames[currentIdx].bg==true then
	   --display bg dec
	   love.graphics.draw(buttonsPic,realDecoBgQuad,200,0)
	end

	if frames[currentIdx].sound~=nil then
	   --display sound dec
	   love.graphics.draw(buttonsPic,realDecoSoundQuad,300,0)
	end

  local r=isFrameInRepetition(currentIdx)
	if r~=nil then
    local rx=400
	   --display rep dec
     for i=1,r.repetition 
     do
	   love.graphics.draw(buttonsPic,realRepDecoQuad,rx,0)
     rx=rx+64
     end
	end
    
	if currentIdx==rangeBeginIdx then
	   --display bg dec
	   love.graphics.draw(buttonsPic,realDecoBeginRangeQuad,500,0)
	end
	if currentIdx==rangeEndIdx then
	   --display bg dec
	   love.graphics.draw(buttonsPic,realDecoEndRangeQuad,500,0)
	end

  if frames[currentIdx].cf==true then
	   --display color frame dec
	   love.graphics.draw(buttonsPic,realDecoColorFrameQuad,550,0)
	end

  if basicPaintUnderMode==true then
	   --display under paint dec
--     print('paint under')
	   love.graphics.draw(buttonsPic,realUnderPMDecoQuad,600,0)
	end

	if currentBrushFunc==roundBrushWithAlpha then
	   --display sound dec
	   love.graphics.draw(buttonsPic,realHardBrushQuad,650,0)
	elseif currentBrushFunc==roundBrushWithGradient then
	   --display sound dec
	   love.graphics.draw(buttonsPic,realSoftBrushQuad,650,0)
  
  end

  if currentConfButtons==confButtonsRight then
	--draw line rectangle on left third of screen to show no paint zone
	love.graphics.setColor(1.0,0.0,0.0,1.0)
	love.graphics.rectangle('line',0,0,uiw/3,uih)
  end

  displayHoverMsg()

	love.graphics.setCanvas()

	--TODO dunno think if used ( tentative save and load )
--	displayModal()

end

function saveCanvasToFrame(idx)

	print('save cvs to frame '..idx)
	love.graphics.setCanvas()
	fromGpu=cvs:newImageData()
	
	--gpu mem needs to be freed asap
	frames[idx].data:release()
	frames[idx].pic:release()
	
	frames[idx].data=fromGpu
	frames[idx].pic=love.graphics.newImage(fromGpu)
	
end


biggerCurrentTool=function()
     if eraseMode==true then
      if eraserRadius<brushKeyStep then
        einc=1
      else
        einc=brushKeyStep
      end
     	eraserRadius=eraserRadius+einc

     else
      print('increasing brsh size')
      if brshradius<brushKeyStep then
        binc=1
      else
        binc=brushKeyStep
      end
      brshradius=brshradius+binc
      mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
      mybrush:setFilter('nearest','nearest')


     end

end

smallerCurrentTool=function()
     if eraseMode==true then
      if eraserRadius>1 then
        if eraserRadius>brushKeyStep then
          bdec=brushKeyStep
          
        else
          bdec=1
        end
     	   eraserRadius=eraserRadius-bdec
     	end

     else
      print('decreasing brsh size')
      if brshradius>1 then
        if brshradius>brushKeyStep then
          bdec=brushKeyStep
          
        else
          bdec=1
        end
      
        brshradius=brshradius-bdec
          mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
    --   		mybrush=love.graphics.newImage(roundBrushWithGradient(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
    --   		mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
          mybrush:setFilter('nearest','nearest')
      end

     end

end



function paintModeKey(key, code, isrepeat)
	--simple debug for poc
--	if key=="enter" then
--		addMsg('begin save')
--		saveFrames()
--		addMsg('save finished')		
--	end
	if key=="p" then
		toPaletteMode()
		return
	end
	if key=="s" then
		toStoryboard()
		return
	end

  if key=="u" then
    toPickMode()
    return
  end

  if key=="b" then
    bucket()
    return
  end

	if key=="left" then
		prevFrame()
	end
	
	if key=="right" then
		nextFrame()
	end

	if key=='up' then
	   biggerCurrentTool()
	end

	if key =='down' then
	   smallerCurrentTool()
	end

	if key=='f6' or key=='f7' or key=='f8' or key=='f9' or key=='f10' then
	   print('storing brush or eraser ')
	   storeInSlot(key)
	end

	if key=='f1' or key=='f2' or key=='f3' or key=='f4' or key=='f5' then
	   print('restoring brush or eraser ')
	   restoreSlot(key)
	end


	if key=='f' then
	   playFromFirst()
	end


	if key=='k' then
		togglePaintButtons()
	
	end
 

	if key=='space' then
	   displayBg=not displayBg
	end

  if key=='return' then
    
    if love.window.getFullscreen()==true then
      love.window.setFullscreen(false)
    else
      love.window.setFullscreen(true)
    end
  end

end


function paintModeDraw()

--    if renderScreen==true then
      rendertouicanvas()
		--pane is transparent
--		love.graphics.clear(1.,1.,1.,1.0)
      love.graphics.clear(.5,.5,.5,1.0)

      love.graphics.setColor(1.0,1.0,1.0,1.0)
      love.graphics.draw(ui,0,0,0,scrsx,scrsy)
      
--      renderScreen=false
--    end
end


function dragPaint(cb,x, y, dx, dy, istouch)
	addMsg('drag paint called')
  --dx is ui cvs coordinates, we transform to painting canvas coordinates
  dx=dx/applicativezoom
  dy=dy/applicativezoom
	print("dx,dy "..dx.." "..dy)
	blitBrushLineRemember(lastblitx+dx,lastblity+dy)
  
--  renderScreen=true
end




--everything stacked there can be reverted to
saveCanvasToUndo = function()
       print(undoBuf[currentUndoBuf])

       --TODO defensive
       local buf=love.graphics.getCanvas()

       love.graphics.setCanvas(undoBuf[currentUndoBuf])
       --we do the backup
      love.graphics.clear(0.,0.,0.,0.)
--      love.graphics.setColor(1,0,0,1)
--      love.graphics.print('composition test ')

    --WIP tentative fix for antialias on tab a 16 love 11.3a
    cvs:setFilter('nearest','nearest')

     love.graphics.draw(cvs)

      love.graphics.setCanvas(buf)
--   	    local data  =  undoBuf[currentUndoBuf]:newImageData()
--	    data:encode("png",conf.prjfld.."undotest.png")



      --love.graphics.draw(cvs)

      print('buffer '..currentUndoBuf .. ' will be poped next time')

      currentUndoBuf=currentUndoBuf+1
      if currentUndoBuf>undoDepth then
      	 currentUndoBuf=1
      end
      currentUndoDepth=currentUndoDepth+1
      if currentUndoDepth>undoDepth then
      	 currentUndoDepth=undoDepth
      end
      print('new target undo buf '..currentUndoBuf..' new undo depth '..currentUndoDepth)


      print('copied to undo buf')

end

-- when a stroke has been made, we maintain undo buffer
penUp= function()
       print('pen up')

      --some modes like basic paint under do something on paint up 
      if penUpPaintModeCb~=nil then
        penUpPaintModeCb()
      else
        print('penUpPaintModeCb nil')
        
      end

      saveCanvasToUndo()
  
--      renderScreen=true

end


function paintModeUpdate()


	if npress==true then
    
    
--    renderScreen=true
    
		consumeClick(widgets)
	
		if npress==false then
			--click has been consumed
			return
		end

		--if we are with all buttons on right we want to avoid paint
		if npx<uiw/3 and currentConfButtons==confButtonsRight then
			return
		end


		--we compensate offset
		--and applicative zoom
    --and brush radius 
    --to transform click in ui canvas coordinate to paint canvas coords

		xb,yb=getTouchOnCanvas(brshradius)
		
	
	--global
		lastblitx=xb
		lastblity=yb
    -- this way we draw the first point , and use same function here and
		--in drag handler

		--we flag this frame for save
		frames[currentIdx].dirty=true
    
    -- this is a function pointer to a function that is different depending on paint mode
		blitBrushLineRemember(xb,yb)
		registerdrag={drag=dragPaint,dragrelease=penUp}
		npress=false
    
	end
end

--you need to init canvas before with init canvases
function toPaintMode()
  --DEBUG
--  createPaintUnderShader(1.,1.,0.)
--  brushShader=paintUnderShader
--END BAD DEBUG  
  
  --WIP:
  
  -- TO WIRE TO BUTTON AND INIT TO 
--  initPaintUnderBlitMode()
  
  createPaintButtons()
  
  uiResize=createPaintButtons
  --that way even first paint can be undoed
  saveCanvasToUndo()
  
	keyFunc = paintModeKey
	drawFunc=paintModeDraw
	updateFunc=paintModeUpdate

end
