
-- we store range for range operations
-- set time code for range
-- copy range
rangeBeginIdx=nil
rangeEndIdx=nil

brshLineWidth=128

brshMaxRad=128

local widgets={}

local clockQuad = {x=64, y=64, w=64, h=64}

cursorQuad = {x=0, y=0, w=64, h=64}
playQuad={x=0, y=4*64, w=64, h=64}
paletteQuad={x=64, y=6*64, w=64, h=64}
pickerQuad={x=0, y=15*64, w=64, h=64}
local brushQuad={x=0, y=16*64, w=64, h=64}
local zoomQuad={x=128, y=0, w=64, h=64}
local deleteQuad={x=0, y=11*64, w=64, h=64}
local bgQuad={x=2*64, y=2*64, w=64, h=64}
local rangeBeginQuad={x=0*64, y=12*64, w=64, h=64}
local rangeEndQuad={x=0*64, y=13*64, w=64, h=64}
local pasteRangeQuad={x=0*64, y=14*64, w=64, h=64}
local exportQuad={x=2*64, y=4*64, w=64, h=64}
local pasteRangeReverseQuad={x=2*64, y=5*64, w=64, h=64}
local switchProjectQuad={x=2*64, y=6*64, w=64, h=64}
local hardBrushQuad={x=2*64, y=9*64, w=64, h=64}
local softBrushQuad={x=2*64, y=10*64, w=64, h=64}
local underBrushQuad={x=2*64, y=11*64, w=64, h=64}


local toggleHardBrush = function()
  print('setting hard brush')
  currentBrushFunc=roundBrushWithAlpha
  blitBrushLineRemember=basicBlitBrushLineRemember
  --TODO recreate
end

local toggleSoftBrush = function()
  print('setting soft brush')
  currentBrushFunc=roundBrushWithGradient
  blitBrushLineRemember=basicBlitBrushLineRemember
  --TODO recreate
end


--shader brush needs extra init
local toggleUnderBrush = function()
  print('setting under brush')
  currentBrushFunc=roundBrushWithAlpha 
  --works only with hard brush
  initPaintUnderBlitMode()
end



function composeExport()
	 print('TODO export to avi start')
    batch=createExportBatch()
    print(batch)
    
    local finished =false
    while not finished 
    do
      finished=batch:execute()
    
    end
    
end

--TODO make it multiply when pressed multiple times
function repeatSeq()
  print('repetition set  ')
  setRepetition(rangeBeginIdx,rangeEndIdx,1)  
  
end


function pasteRange(directOrder)
	 if rangeBeginIdx==nil or rangeEndIdx==nil then
	    print(' nil marker, not possible ')
	    return
	 end

	 if rangeEndIdx<=rangeBeginIdx then
	    print(' end marker before begin marker, not possible ')
	    return 
	 end


  --paste position, we paste at current +1 , current +2 .. etc
  local pasteOffset=1

	 --paste range from current idx
  for i=rangeBeginIdx,rangeEndIdx 
  do
    --create frame 
    --TODO we can use add frame here
    --paste source frame to created frame
    --TODO we need custom code here
    newid = love.image.newImageData(conf.cvsw,conf.cvsh)
    newid:paste(frames[i].data,0,0,0,0,conf.cvsw,conf.cvsh)
    
    newp=love.graphics.newImage(newid)
    -- table.insert(frames,{pic=newp,data=newid})
    
    local newFrameIdx=currentIdx+pasteOffset
    table.insert(frames,newFrameIdx,{pic=newp,data=newid,tc=frames[i].tc})
    maxframe=maxframe+1
    print('number of frames '..maxframe)

    maxFrameReached=maxFrameReached+1
    maintainRepetitionsFrameAddition(newFrameIdx)    
    
    print('max frames reached at a given point '..maxFrameReached)

    --just omitting this implements paste reverse
    if directOrder==true then
      pasteOffset=pasteOffset+1
    end
  end


  maintainBgRanges()
  saveCanvasToUndo()


end

function pasteRangeDirect()
  pasteRange(true)
end

function pasteRangeReverse()
    pasteRange(false)
end


function toggleBg()
	 print ('toggle frame '..currentIdx..'as bg')
	 if frames[currentIdx].bg==true then
	    frames[currentIdx].bg=nil
	 else
	    frames[currentIdx].bg=true

	 end

	 maintainBgRanges()
end



function deleteCurrentFrame()
	 print('deletingFrame '..currentIdx)

	 if maxframe<4 then
	    print('not enough frames to delete')
	    return
	 end

	 toDel=frames[currentIdx]
	 toDel.data:release()
	 toDel.pic:release()


	 table.remove(frames,currentIdx)
	 maxframe=maxframe-1

   maintainRepetitionsFrameDeletion(currentIdx)

	 if currentIdx>maxframe then
	    currentIdx=maxframe
	 end


	 maintainBgRanges()

	 initCanvases(currentIdx)
end

function setRangeBegin()
	 print('setRangeBegin '..currentIdx)
	 rangeBeginIdx=currentIdx
end

function setRangeEnd()
	 print('setRangeEnd '..currentIdx)
	 rangeEndIdx=currentIdx
end

function switchProject()
  print ('TODO got to switch screen')
  
  print('TODO change currentproject.lua')
  toSwitchProject()
--  love.event.quit( "restart" )
end


local settings={}

createSettingsButtons=function()
  widgets = {}
  
  local wPlay=createpicbutton(uiw-64*buttonZoom,0,buttonsPic,toPlayback,playQuad,buttonZoom)
  local wPalette =createpicbutton(uiw-64*buttonZoom,64*buttonZoom,buttonsPic,toPaletteMode,paletteQuad,buttonZoom)

  local wPicker =createpicbutton(uiw-64*buttonZoom,128*buttonZoom,buttonsPic,toPickMode,pickerQuad,buttonZoom)


  local wTC =createpicbutton(uiw-64*buttonZoom,192*buttonZoom,buttonsPic,toTimeCode,clockQuad,buttonZoom)
  local wBS =createpicbutton(uiw-64*buttonZoom,256*buttonZoom,buttonsPic,toBrushScreen,brushQuad,buttonZoom)
  local wZP =createpicbutton(uiw-128*buttonZoom,0*buttonZoom,buttonsPic,toZoomPos,zoomQuad,buttonZoom)
  local wDF =createpicbutton(uiw-192*buttonZoom,0*buttonZoom,buttonsPic,deleteCurrentFrame,deleteQuad,buttonZoom)
  local wBG =createpicbutton(uiw-256*buttonZoom,0*buttonZoom,buttonsPic,toggleBg,bgQuad,buttonZoom)
  local wRB =createpicbutton(uiw-320*buttonZoom,0*buttonZoom,buttonsPic,setRangeBegin,rangeBeginQuad,buttonZoom)
  local wRE =createpicbutton(uiw-384*buttonZoom,0*buttonZoom,buttonsPic,setRangeEnd,rangeEndQuad,buttonZoom)
  local wPR =createpicbutton(uiw-384*buttonZoom,uih-64*buttonZoom,buttonsPic,pasteRangeDirect,pasteRangeQuad,buttonZoom)
  local wEX =createpicbutton(uiw-512*buttonZoom,uih-64*buttonZoom,buttonsPic,composeExport,exportQuad,buttonZoom)
  local wPRR =createpicbutton(uiw-384*buttonZoom,uih-128*buttonZoom,buttonsPic,pasteRangeReverse,pasteRangeReverseQuad,buttonZoom)
  local wSP =createpicbutton(uiw-512*buttonZoom,uih-128*buttonZoom,buttonsPic,switchProject,switchProjectQuad,buttonZoom)
  local wTHB =createpicbutton(uiw-576*buttonZoom,uih-256*buttonZoom,buttonsPic,toggleHardBrush,hardBrushQuad,buttonZoom)
  local wTSB =createpicbutton(uiw-512*buttonZoom,uih-256*buttonZoom,buttonsPic,toggleSoftBrush,softBrushQuad,buttonZoom)
  local wTUB =createpicbutton(uiw-576*buttonZoom,uih-320*buttonZoom,buttonsPic,toggleUnderBrush,underBrushQuad,buttonZoom)

  local wSR =createpicbutton(uiw-512*buttonZoom,uih-320*buttonZoom,buttonsPic,repeatSeq,softBrushQuad,buttonZoom)


  table.insert(widgets,wPlay)
  table.insert(widgets,wPalette)
  table.insert(widgets,wPicker)
  table.insert(widgets,wTC)
  table.insert(widgets,wBS)
  table.insert(widgets,wZP)
  table.insert(widgets,wDF)
  table.insert(widgets,wBG)
  table.insert(widgets,wRB)
  table.insert(widgets,wRE)
  table.insert(widgets,wPR)
  table.insert(widgets,wEX)
  table.insert(widgets,wPRR)
  table.insert(widgets,wSP)
  table.insert(widgets,wTHB)
  table.insert(widgets,wTSB)
  table.insert(widgets,wTUB)
  table.insert(widgets,wSR)
  
end


function toSettings()
  createSettingsButtons()
  uiResize=createSettingsButtons
  
	drawFunc=drawSettings
	updateFunc=updateSettings
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

	love.graphics.setColor(1.0,.0,.0,1.0)
	love.graphics.line(brshLineWidth,0,brshLineWidth,uih)
	love.graphics.print('setting',400,0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)

	if eraseMode==false then
	   love.graphics.draw(mybrush)
	else
	--outline of eraser
	   love.graphics.setColor(0.0,0.0,0.0,1.0)
	   love.graphics.circle('line',eraserRadius,eraserRadius,eraserRadius)
	   love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	end

	renderWidgets(widgets)
		
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
			

			potradius=math.floor(npy/uih * brshMaxRad)
			if potradius>1 then


			   if eraseMode==true then
			       eraserRadius=potradius
			       print('eraserRadius '..potradius)
			   else

				--TODO for test
				brshradius=potradius   
			   	mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
--			   	mybrush=love.graphics.newImage(roundBrushWithGradient(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))

				--normal
			--	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
			
			   	mybrush:setFilter('nearest','nearest')
			   end
			else
				print('brsh less than 1 impossible')
			end
			npress=false				
		else

			consumeClick(widgets)
	
	
			--if newpress still not consumed
			if npress==true then
				toPaintMode()
			end
		end
	end
end