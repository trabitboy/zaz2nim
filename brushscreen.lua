local exitQuad = {x=4*64, y=0, w=64, h=64}
local pasteQuad = {x=0, y=9*64, w=64, h=64}
local srcQuad = {x=6*64, y=1*64, w=64, h=64}



local function exitBS()
	 print('exit bs ')
	 toPaintMode()
end

local currentSel = createbrushbox(100,100,200,200)


--we stamp selection on current canvas/current frame
local stampSelection = function()
--TODO the cvs needs to be loaded with the relevant frame, then the frame needs to be saved
      initCanvases(currentIdx)
      --doesn t work, go and see code from paste button?
      love.graphics.setCanvas(cvs)

      --lets create a quad
      local toBlit=love.graphics.newQuad(
	brushSelection.x,
	brushSelection.y,
	brushSelection.w,
	brushSelection.h,
	frames[copySrc].pic:getDimensions()
	)
      love.graphics.draw(
        frames[copySrc].pic,
        toBlit,
        currentSel.x-offsetcvs.x,
        currentSel.y-offsetcvs.y
--        currentSel.x,
--        currentSel.y
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
    )
  )
end


local widgets={}


createBSButtons=function()


  local wExitBS = createpicbutton(0,0,buttonsPic,exitBS,exitQuad)
  local wToBSS = createpicbutton(uiw-64,uih-64,buttonsPic,toBrushSourceSelection,srcQuad)
  local wStamp = createpicbutton(uiw-64,0,buttonsPic,stampSelection,pasteQuad)


  widgets={}
  table.insert(widgets,wExitBS)
  table.insert(widgets,wToBSS)
  table.insert(widgets,currentSel )
  table.insert(widgets,wStamp)

end


local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

--	let's render the picture we will render the paste on
	love.graphics.draw(frames[currentIdx].pic,offsetcvs.x,offsetcvs.y)

	renderWidgets(widgets)

		
	msgToCvs()

	--love.graphics.print()
	love.graphics.setCanvas()
end


local function brushScreenDraw()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
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
  
  
  --we need to add offset, in case we work not from 0 0 
	currentSel.x=brushSelection.x+offsetcvs.x
  print('to bs current sel x y')
	print(currentSel.x  )
	currentSel.y=brushSelection.y+offsetcvs.y
	print(currentSel.y  )
	currentSel.w=brushSelection.w
	print(currentSel.w  )
	currentSel.h=brushSelection.h
	print(currentSel.h  )

	

	bbsettexture(
    currentSel,
    frames[copySrc].pic,
    love.graphics.newQuad(
      brushSelection.x,
      brushSelection.y,
      brushSelection.w,
      brushSelection.h,
      frames[copySrc].pic:getDimensions()
    )
  )

	drawFunc=brushScreenDraw
	updateFunc=brushScreenUpdate

end



