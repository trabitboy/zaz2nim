local exitQuad = {x=4*64, y=0, w=64, h=64}
local pasteQuad = {x=0, y=9*64, w=64, h=64}
local srcQuad = {x=6*64, y=1*64, w=64, h=64}



local function exitBS()
	 print('exit bs ')
	 toPaintMode()
end

local currentSel = createbrushbox(100,100,200,200,true)
local xFlip=false

--we stamp selection on current canvas/current frame
local stampSelection = function()
--TODO the cvs needs to be loaded with the relevant frame, then the frame needs to be saved
      initCanvases(currentIdx)
      --doesn t work, go and see code from paste button?
      love.graphics.setCanvas(cvs)

  --flip logic
  local xBlitZoom=1.
  local xBlitFlipOff=0
  
  --TODO here get zoom from brush box to paste with zoom
  
  
  
  if xFlip==true then
      xBlitZoom=-1.
      xBlitFlipOff=brushSelection.w
  end


  --lets poll if zoom changed
  brushSelection.zoom=currentSel.tzoom
  
      --lets create a quad
      local toBlit=love.graphics.newQuad(
	brushSelection.x,
	brushSelection.y,
	brushSelection.w,
	brushSelection.h,
	frames[copySrc].pic:getDimensions()
)
  --quick fix but should be done at long time
    frames[copySrc].pic:setFilter('nearest','nearest')
      
      love.graphics.draw(
        frames[copySrc].pic,
        toBlit,
        currentSel.x-offsetcvs.x+xBlitFlipOff,
        currentSel.y-offsetcvs.y,
        0.,
        xBlitZoom*brushSelection.zoom,
        -- *0.5
        
        1*brushSelection.zoom
        -- .*0.5
        )
      love.graphics.setCanvas()

      --save result to frame
 	saveCanvasToFrame(currentIdx)
	--we need to reset the texture in case we pasted on itself ( we changed frame referenced in brushbox )
  bbsettexture(
    currentSel,
    frames[copySrc].pic,
    love.graphics.newQuad(
      brushSelection.x,
      brushSelection.y,
      brushSelection.w,
      brushSelection.h,
      frames[copySrc].pic:getDimensions()
    ),
   xFlip
  )
end


local widgets={}

toggleXFlip=function()
  addMsg('toggle xflip')
  
  xFlip=not xFlip
  
  if xFlip then
    setHoverMsg('x flip')
  else
    setHoverMsg('no x flip')
  end
  --NOT WORKING
  --WIP dirty dirty, no clear sequence to communicate to widget
--  currentSel.xFLip=xFlip
end

createBSButtons=function()


  local wExitBS = createpicbutton(0,0,buttonsPic,exitBS,exitQuad,buttonZoom)
  local wToBSS = createpicbutton(uiw-64*buttonZoom,uih-64*buttonZoom,buttonsPic,toBrushSourceSelection,srcQuad,buttonZoom)
  local wStamp = createpicbutton(uiw-64*buttonZoom,0,buttonsPic,stampSelection,pasteQuad,buttonZoom)
  local wXflip = createpicbutton(uiw-64*buttonZoom,uih-128*buttonZoom,buttonsPic,toggleXFlip,exitQuad,buttonZoom)


  widgets={}
  table.insert(widgets,wExitBS)
  table.insert(widgets,wToBSS)
  table.insert(widgets,currentSel )
  table.insert(widgets,wStamp)
  table.insert(widgets,wXflip)

end


local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
  love.graphics.rectangle('fill',offsetcvs.x,offsetcvs.y,conf.cvsw*applicativezoom,conf.cvsh*applicativezoom)
  
--	let's render the picture we will render the paste on
	--we blit optional BG
	local key = 'f'..currentIdx
	if mybg[key]~=nil and displayBg==true then
	   love.graphics.draw(frames[mybg[key]].pic,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)

	end

	love.graphics.draw(frames[currentIdx].pic,offsetcvs.x,offsetcvs.y)

	renderWidgets(widgets)

		
	msgToCvs()

  displayHoverMsg()
	--love.graphics.print()
	love.graphics.setCanvas()
end


local function brushScreenDraw()
		rendertouicanvas()
		--this is the background image of our paint
--		love.graphics.clear(1.,1.,1.,1.0)
    love.graphics.clear(.5,.5,.5,1.0)

		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
		
end



local function brushScreenUpdate()
	 if npress==true then
	    print('bs click')
	    addMsg('bs click')
	    consumed=consumeClick(widgets)
	    print('consumed '..tostring(consumed))
	    if consumed==true
	    then
		return
	    end


	    npress=false
	 end

end

--WIP when returning from source selection, we might get an optional x and y to paste
--useful to replicate scenery parts opx,opy
--TODO seems already done log and test
function toBrushScreen()
  createBSButtons()
  uiResize=createBSButtons




	if copySrc==nil then
	   print('no src frame')
	   return
	end


  
  --brushSelection is just a map
  --current sel is the box widget
  
  

  -- brushselection comes from brush source selection screen
	currentSel.x=brushSelection.x+offsetcvs.x
  print('to bs current sel x y')
	print(currentSel.x  )
	currentSel.y=brushSelection.y+offsetcvs.y
	print(currentSel.y  )
	currentSel.w=brushSelection.w
	print(currentSel.w  )
	currentSel.initw=brushSelection.w
  currentSel.h=brushSelection.h
	print(currentSel.h  )
  currentSel.tzoom=brushSelection.zoom
	

 	bbsettexture(
    currentSel,
    frames[copySrc].pic,
    love.graphics.newQuad(
      brushSelection.x,
      brushSelection.y,
      brushSelection.w,
      brushSelection.h,
      frames[copySrc].pic:getDimensions()
    ),
    xFLip
  )

	drawFunc=brushScreenDraw
	updateFunc=brushScreenUpdate

end



