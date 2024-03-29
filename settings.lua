
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
local hardBrushEnabledQuad={x=3*64, y=9*64, w=64, h=64}
local softBrushQuad={x=2*64, y=10*64, w=64, h=64}
local softBrushQuadEnabled={x=3*64, y=10*64, w=64, h=64}
local underBrushQuad={x=2*64, y=11*64, w=64, h=64}
local underBrushQuadEnabled={x=2*64, y=11*64, w=64, h=64}
local toggleRepQuad={x=2*64, y=12*64, w=64, h=64}
local untoggleRepQuad={x=2*64, y=13*64, w=64, h=64}
local toggleColorFrameQuad={x=2*64, y=16*64, w=64, h=64}
local untoggleColorFrameQuad={x=6*64, y=0, w=64, h=64}
local toggleLightTableQuad = {x=3*64, y=2*64, w=64, h=64}
local copyToOtherProjectQuad = {x=3*64, y=3*64, w=64, h=64}

--check mark to say if paint modes are enabled?
--local selectedQuad = {x=4*64, y=1*64, w=64, h=64}


toggleLightTable=function ()
  lightTable= not lightTable
  setHoverMsg('light table '..tostring(lightTable) )
end


local enableColorFrame=function()
  frames[currentIdx].cf=true
  frames[currentIdx].tc=0
  createSettingsButtons()
  
  
end

local disableColorFrame=function()
  frames[currentIdx].cf=nil
  createSettingsButtons()
  
  
end





local toggleHardBrush = function()
  print('setting hard brush')
  currentBrushFunc=roundBrushWithAlpha
  
  initBasicPaintMode()
 	mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
 	mybrush:setFilter('nearest','nearest')
 
   --we maintain this for UI
--  isHardPaintEnabled=true

  
--  blitBrushLineRemember=basicBlitBrushLineRemember
--  backBufferRender=false
--  penUpPaintModeCb=nil
  --TODO recreate
end

local toggleSoftBrush = function()
  print('setting soft brush')
  currentBrushFunc=roundBrushWithGradient
  
  initBasicPaintMode()
 	mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
 	mybrush:setFilter('nearest','nearest')

  --we maintain this for UI
--  isHardPaintEnabled=false
  
end


--DISABLED IN UI, NOT WORKING ON ANDROID
--shader brush needs extra init
local toggleShaderUnderBrush = function()
  print('setting under brush')
  currentBrushFunc=roundBrushWithAlpha 
  --works only with hard brush
  initPaintUnderBlitMode()
  backBufferRender=false
  penUpPaintModeCb=nil
end

local toggleUnderBrush = function()
    --we maintain this for UI
--  isHardPaintEnabled=true

  if basicPaintUnderMode==true then
    initBasicPaintMode()
    basicPaintUnderMode=nil  
    
  else
    print('setting basic under brush')
    addMsg('under brush')
    --currentBrushFunc=roundBrushWithAlpha 
    --works only with hard brush
    initBasicPaintUnderBlitMode()
  end
end


function composeExport()
	 print('TODO export to avi start')
   addMsg('start export to folder')
    batch=createExportBatch()
    print(batch)
    
    local finished =false
    while not finished 
    do
      finished=batch:execute()
    
    end
    
end


function disableRepeatSeq()
  
  removeRepetition(currentIdx)
  
--  print('repetition unset  ')
--  local r=isFrameInRepetition(idx)  
--  print('current trigger '..r.trigger .. ' target ' ..r.target)
  
--  for i,rep in ipairs(repetitions)
--  do
--    --TODO never goes there for some reason
--    print(' cur trig '..rep.trigger)
--    if rep.trigger==r.trigger then
--      table.remove(repetitions,i)
--      break
--    end
--  end
  createSettingsButtons()
  
end

function repeatSeq()
  print('repetition set  ')
  addMsg('repetition set  ')
  setRepetition(rangeBeginIdx,rangeEndIdx,1)  
  createSettingsButtons()
  
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
    --WIP we choose that cb ce frames are saved from id
    table.insert(frames,newFrameIdx,{pic=newp,data=newid,tc=frames[i].tc,dirty=true})
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

  flagShiftedFrames(maxFrameReached)
  
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
      frames[currentIdx].tc=0
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

   --new current idx has been shifted due to removal
   flagShiftedFrames(currentIdx-1)

	 if currentIdx>maxframe then
	    currentIdx=maxframe
	 end


	 maintainBgRanges()

	 initCanvases(currentIdx)
   setHoverMsg('frame '..currentIdx..' deleted ')
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


function copyFramesToOtherPrj(folder)
  setHoverMsg('WIPcopy '..rangeBeginIdx ..' to '..rangeEndIdx.. ' to '..folder,600)
  
  print('DBG APPEND '..folder)
  local tgtfld="project/"..folder.."/"
  appendToOtherProject(tgtfld,rangeBeginIdx,rangeEndIdx)

  --is following necessary?
  toSettings()
end

function copyToOtherProject()
--  setHoverMsg('WIP copy to other prj')
  
  if rangeBeginIdx~=nil and rangeEndIdx~=nil then
    setHoverMsg('WIP copy to other prj')
    --TODO select other project (prj selection callback?)
    --TODO do the copy and show report
    toSelectProject(copyFramesToOtherPrj)
  else 
    setHoverMsg('CB CE not set')

  end
  
end


local settings={}

createSettingsButtons=function()
  widgets = {}
  
  local wBrushPicker = createbrushpicker(64*buttonZoom,64*buttonZoom,buttonZoom)
  
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
  local wSP =createpicbutton(uiw-512*buttonZoom,uih-128*buttonZoom,buttonsPic,toSwitchProjectThroughSave,switchProjectQuad,buttonZoom)
  --WIP
--  if isHardBrushEnabled==true then
    local wTHB =createpicbutton(uiw-576*buttonZoom,uih-256*buttonZoom,buttonsPic,toggleHardBrush,hardBrushEnabledQuad,buttonZoom)
    table.insert(widgets,wTHB)
--  else 
--    local wTHB =createpicbutton(uiw-576*buttonZoom,uih-256*buttonZoom,buttonsPic,toggleHardBrush,hardBrushQuad, buttonZoom)
--    table.insert(widgets,wTHB)
--  end
  local wTSB =createpicbutton(uiw-512*buttonZoom,uih-256*buttonZoom,buttonsPic,toggleSoftBrush,softBrushQuad,buttonZoom)
  
  local wTUB =createpicbutton(uiw-576*buttonZoom,uih-320*buttonZoom,buttonsPic,toggleUnderBrush,underBrushQuad,buttonZoom)
  

  --set rep or unset rep button displayed depending on state 
  --(TODO should be widget, note here)
  local r=isFrameInRepetition(currentIdx)
	if r~=nil then 
    local wUSR =createpicbutton(uiw-512*buttonZoom,uih-320*buttonZoom,buttonsPic,disableRepeatSeq,untoggleRepQuad,buttonZoom)
    table.insert(widgets,wUSR)
  else
    local wSR =createpicbutton(uiw-512*buttonZoom,uih-320*buttonZoom,buttonsPic,repeatSeq,toggleRepQuad,buttonZoom)
    table.insert(widgets,wSR)
  end

	if frames[currentIdx].cf==nil then 
--    local wECF =createpicbutton(uiw-512*buttonZoom,uih-256*buttonZoom,buttonsPic,enableColorFrame,toggleColorFrameQuad,buttonZoom)
    local wECF =createpicbutton(64*buttonZoom,0*buttonZoom,buttonsPic,enableColorFrame,toggleColorFrameQuad,buttonZoom)
    table.insert(widgets,wECF)
  else
    local wDCF =createpicbutton(64*buttonZoom,0*buttonZoom,buttonsPic,disableColorFrame,untoggleColorFrameQuad,buttonZoom)
    table.insert(widgets,wDCF)
  end

  
  local wTLT =createpicbutton(uiw-384*buttonZoom,uih-192*buttonZoom,buttonsPic,toggleLightTable,toggleLightTableQuad,buttonZoom)  

  local wCTAP =createpicbutton(uiw-384*buttonZoom,uih-256*buttonZoom,buttonsPic,copyToOtherProject,copyToOtherProjectQuad,buttonZoom)  


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
  table.insert(widgets,wTSB)
  table.insert(widgets,wTUB)
  table.insert(widgets,wTLT)
  table.insert(widgets,wBrushPicker)
  table.insert(widgets,wCTAP)
  
end


function toSettings()
  createSettingsButtons()
  uiResize=createSettingsButtons
  keyFunc=nil
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
	displayHoverMsg()
  
	love.graphics.setCanvas()
end



function drawSettings()
	-- love.graphics.draw(buttonsPic)
		rendertouicanvas()
		--this is the background image of our paint
--		love.graphics.clear(1.,1.,1.,1.0)
    love.graphics.clear(.5,.5,.5,1.0)

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