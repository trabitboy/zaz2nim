displayBg=true

paintcolor={r=0.,g=0.,b=0.}


--step to change tool size with keyboard shortcuts
brushKeyStep=4

--on stylus up we do a copy to one of the undobuffers

--maximum undo
undoDepth=3
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

local widgets={}

 decoBgQuad={x=2*64, y=2*64, w=64, h=64}
	realDecoBgQuad=love.graphics.newQuad(decoBgQuad.x,decoBgQuad.y,decoBgQuad.w,decoBgQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

 decoSoundQuad={x=1*64, y=10*64, w=64, h=64}
	realDecoSoundQuad=love.graphics.newQuad(decoSoundQuad.x,decoSoundQuad.y,decoSoundQuad.w,decoSoundQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


addQuad = {x=0, y=320, w=64, h=64}
prevQuad = {x=0, y=64, w=64, h=64}
nextQuad = {x=0, y=0, w=64, h=64}
saveQuad = {x=0, y=128, w=64, h=64}
penQuad=  {x=64, y=192, w=64, h=64}
undoQuad = {x=64, y=18*64, w=64, h=64}
eraserQuad = {x=0, y=192, w=64, h=64}
settingsQuad = {x=0, y=10*64, w=64, h=64}
copyQuad = {x=0, y=8*64, w=64, h=64}
pasteQuad = {x=0, y=9*64, w=64, h=64}
lflickQuad = {x=0, y=6*64, w=64, h=64}
rflickQuad = {x=0, y=7*64, w=64, h=64}
bucketQuad = {x=64,y=0, w=64, h=64}

--index of the source frame
copySrc=nil


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
	    love.graphics.clear(0.,0.,0.,0.)
-- for test !!
--	    love.graphics.setColor(1.,0.,0.,1.)

	love.graphics.draw(undoBuf[restoreIdx])
--	    local data  =  undoBuf[restoreIdx]:newImageData()
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
	love.graphics.setCanvas(cvs)
	
	love.graphics.draw(frames[copySrc].pic)
	
	love.graphics.setCanvas()
end


--doesnt work in insertion for some reason
function addFrame()
	newid = love.image.newImageData(conf.cvsw,conf.cvsh)
	newp=love.graphics.newImage(newid)
	-- table.insert(frames,{pic=newp,data=newid})
	table.insert(frames,currentIdx+1,{pic=newp,data=newid,tc=1})
	maxframe=maxframe+1
	print('number of frames '..maxframe)

	maxFrameReached=maxFrameReached+1
	print('max frames reached at a given point '..maxFrameReached)

	maintainBgRanges()
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
		end

end

function nextFrame()
		if currentIdx<maxframe then
			addMsg("next")
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)

			currentIdx=currentIdx+1
			print("frame up")
			initCanvases(currentIdx)

			resetUndo()
		end


end

function toggleEraser()
	eraseMode= true

end
function togglePen()
	eraseMode= false

end


--TODO create widget uiw (480)

local wPrevFrame=createpicbutton(0,0,buttonsPic,prevFrame,prevQuad,buttonZoom)



local wSaveFrames=createpicbutton(uiw-64*buttonZoom,uih-64*buttonZoom,buttonsPic,initSaveScreen,saveQuad,buttonZoom)
--local wSaveFrames=createpicbutton(uiw-64*buttonZoom,uih-64*buttonZoom,buttonsPic,saveFrames,saveQuad,buttonZoom)

local wLeftFlick = createpicbutton(0,64*buttonZoom,buttonsPic,toLeftFlick,lflickQuad,buttonZoom)

--top right
local wNextFrame=createpicbutton(uiw-64*buttonZoom,0,buttonsPic,nextFrame,nextQuad,buttonZoom)
local wRightFlick = createpicbutton(uiw-64*buttonZoom,64*buttonZoom,buttonsPic,toRightFlick,rflickQuad,buttonZoom)
local wSettings=createpicbutton(uiw-64*buttonZoom,192*buttonZoom,buttonsPic,toSettings,settingsQuad,buttonZoom)

--bottom right
local wBucket=createpicbutton(uiw-64*buttonZoom,uih-192*buttonZoom,buttonsPic,bucket,bucketQuad,buttonZoom)
local wPasteFrame=createpicbutton(uiw-64*buttonZoom,uih-128*buttonZoom,buttonsPic,pasteFrame,pasteQuad,buttonZoom)


--bottom left
local wUndo=createpicbutton(0,uih-320*buttonZoom,buttonsPic,undoLastStroke,undoQuad,buttonZoom)
local wTogglePen=createpicbutton(0,uih-256*buttonZoom,buttonsPic,togglePen,penQuad,buttonZoom)
local wToggleEraser=createpicbutton(0,uih-192*buttonZoom,buttonsPic,toggleEraser,eraserQuad,buttonZoom)
local wCopyFrame=createpicbutton(0,uih-128*buttonZoom,buttonsPic,copyFrame,copyQuad,buttonZoom)
local wAddFrame=createpicbutton(0,uih-64*buttonZoom,buttonsPic,addFrame,addQuad,buttonZoom)


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
	love.graphics.draw(frames[currentIdx].pic,0,0)
	
	love.graphics.setCanvas()
	
end




local function rendertouicanvas()
	love.graphics.setCanvas(ui)
-- TODO render the light table to a separate canvas,
-- so we can blit a white bg square behind

-- this clear defines the base of the canvas, it is at the moment used
-- by inksmooth shader 
	love.graphics.clear(0.,0.,0.,.0)


	--let's blit a rectangle behind the frames so we see boundaries
	love.graphics.setColor(1.,1.,1.,1.0)
	love.graphics.rectangle('fill',offsetcvs.x,offsetcvs.y,conf.cvsw,conf.cvsh)
	--love.graphics.setColor(1.,1.,1.,1.0)


	--we blit optional BG
	local key = 'f'..currentIdx
	if mybg[key]~=nil and displayBg==true then
	   love.graphics.draw(frames[mybg[key]].pic,offsetcvs.x,offsetcvs.y)

	end



	if currentIdx-1>0 then 
		love.graphics.setColor(1.0,1.0,1.0,0.2)
		love.graphics.draw(frames[currentIdx-1].pic,offsetcvs.x,offsetcvs.y)
	end

	if frames[currentIdx+1] then 
		love.graphics.setColor(1.0,1.0,1.0,0.2)
		love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	--antialias ink of current frame
	love.graphics.setShader(inksmooth)
	love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y)
	love.graphics.setShader()
	love.graphics.draw(mybrush)

	renderWidgets(widgets)

	love.graphics.setColor(1.0,0.0,0.0,1.0)
	
	love.graphics.print('tc '..frames[currentIdx].tc,200,0,0,2,2)

	love.graphics.print("frame "..currentIdx,400,0,0,2,2)
	love.graphics.setColor(1.0,1.0,1.0,1.0)

	msgToCvs()


	--render brush for user friendliness
	if eraseMode==true then
	   love.graphics.circle('line',hoverx,hovery,eraserRadius)
	else
		love.graphics.draw(mybrush,hoverx-brshradius,hovery-brshradius)
	end


	if frames[currentIdx].bg==true then
	   --display bg dec
	   love.graphics.draw(buttonsPic,realDecoBgQuad,200,0)
	end

	if frames[currentIdx].sound~=nil then
	   --display sound dec
	   love.graphics.draw(buttonsPic,realDecoSoundQuad,300,0)
	end

	


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
     	eraserRadius=eraserRadius+brushKeyStep

     else
	print('increasing brsh size')
	brshradius=brshradius+brushKeyStep
     		mybrush=love.graphics.newImage(roundBrushWithGradient(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))

--   	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
   	mybrush:setFilter('nearest','nearest')


     end

end

smallerCurrentTool=function()
     if eraseMode==true then
     	if eraserRadius>brushKeyStep then
     	   eraserRadius=eraserRadius-brushKeyStep
     	end

     else
	print('decreasing brsh size')
	if brshradius>brushKeyStep then
	
		brshradius=brshradius-brushKeyStep
   		mybrush=love.graphics.newImage(roundBrushWithGradient(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
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

	if key=='space' then
	   displayBg=not displayBg
	end


end


function paintModeDraw()


		rendertouicanvas()
		--pane is transparent
--		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.clear(.5,.5,.5,1.0)

		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)
end


function dragPaint(cb,x, y, dx, dy, istouch)
	addMsg('drag paint called')
	print("dx,dy "..dx.." "..dy)
	blitBrushLineRemember(lastblitx+dx,lastblity+dy)
end


lastblitx=nil
lastblity=nil

-- function blitBrushRemember(x,y)
	-- print("blit x,y "..x.." "..y)
	-- love.graphics.setCanvas(cvs)

	-- if eraseMode== true then 
		-- love.graphics.setBlendMode('replace')
		-- --following is ok for square brush
		-- -- love.graphics.setShader(eraserShader)
		-- --alternative method
		-- love.graphics.setColor(0.0,0.0,0.0,0.0)
		-- love.graphics.circle('fill',x,y,32)
	-- end

	-- love.graphics.draw(mybrush,x,y)

	-- love.graphics.setShader()

	-- love.graphics.setColor(1.0,1.0,1.0,1.0)
	-- love.graphics.setBlendMode('alpha')
	-- love.graphics.setCanvas()
	-- lastblitx=x
	-- lastblity=y
	
	-- dirtycvs=true
-- end

--draws a line from last blit x last blit y to current coords
function blitBrushLineRemember(x,y)
	print("blit line x,y "..x.." "..y)
	
	local blits=calculateTraj(lastblitx,lastblity,x,y)
	
	
	love.graphics.setCanvas(cvs)

	if eraseMode== true then 
			love.graphics.setBlendMode('replace')
			--following is ok for square brush
			-- love.graphics.setShader(eraserShader)
			--alternative method
			love.graphics.setColor(0.0,0.0,0.0,0.0)

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

	if eraseMode== true then 

		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.setBlendMode('alpha')

	end

	love.graphics.setShader()

	love.graphics.setCanvas()
	

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end

-- when a stroke has been made, we maintain undo buffer
penUp= function()
       print('pen up')


       print(undoBuf[currentUndoBuf])

       --TODO defensive
       local buf=love.graphics.getCanvas()

       love.graphics.setCanvas(undoBuf[currentUndoBuf])
       --we do the backup
      love.graphics.clear(0.,0.,0.,0.)
--      love.graphics.setColor(1,0,0,1)
--      love.graphics.print('composition test ')
     love.graphics.draw(cvs)

      love.graphics.setCanvas(buf)
   	    local data  =  undoBuf[currentUndoBuf]:newImageData()
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


function paintModeUpdate()

	--TODO make reusable per screen

	if npress==true then
		-- for i,w in ipairs (widgets)
		-- do
			-- ret=w.click(w,npx,npy)
			-- if ret==true then
				-- npress=false
				-- break
			-- end

		-- end
		consumeClick(widgets)
	
		if npress==false then
			--click has been consumed
			return
		end
	
		--we compensate offset
		--TODO not sure this compensation is done in drag
		xb=npx-offsetcvs.x-brshradius
		yb=npy-offsetcvs.y-brshradius
		
		--change this ugly thing global thing HACK
		lastblitx=xb
		lastblity=yb-- this way we draw the first point , and use same function here and
		--in drag handler

		--we flag this frame for save
		frames[currentIdx].dirty=true
		blitBrushLineRemember(xb,yb)
		registerdrag={drag=dragPaint,dragrelease=penUp}
		npress=false
	end
end

--you need to init canvas before with init canvases
function toPaintMode()
	keyFunc = paintModeKey
	drawFunc=paintModeDraw
	updateFunc=paintModeUpdate

end
