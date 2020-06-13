
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



function composeExport()
	 print('TODO export to avi start')

end


function pasteRange()
	 if cb==nil or ce==nil then
	    print(' nil marker, not possible ')
	    return
	 end

	 if ce<=cb then
	    print(' end marker before begin marker, not possible ')
	    return 
	 end

	 --todo paste range from current idx


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
local wPR =createpicbutton(uiw-384*buttonZoom,uih-64*buttonZoom,buttonsPic,pasteRange,pasteRangeQuad,buttonZoom)
local wEX =createpicbutton(uiw-512*buttonZoom,uih-64*buttonZoom,buttonsPic,composeExport,exportQuad,buttonZoom)


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

function toSettings()
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
			   
				brshradius=potradius   
			   	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
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