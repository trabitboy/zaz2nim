local exitQuad = {x=64, y=17*64, w=64, h=64}




local screenPos = createbrushbox(100,100,200,200)

local function exitZP()
	 print('exit zp ')
	 --copy offset
	 offsetcvs.x=screenPos.x
	 offsetcvs.y=screenPos.y

	 --TODO copy zoom

	 toPaintMode()
end


--local wToBSS = createpicbutton(uiw-64,uih-64,buttonsPic,toBrushSourceSelection,exitQuad)
--local wStamp = createpicbutton(uiw-64,0,buttonsPic,stampSelection,exitQuad)



local widgets={}

createZPButtons=function()
  widgets={}
  
  local wExitZP = createpicbutton(0,0,buttonsPic,exitZP,exitQuad)
 
  table.insert(widgets,wExitZP)
  table.insert(widgets,wToBSS)
  table.insert(widgets,screenPos )
  table.insert(widgets,wStamp)

end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,1.0)

	love.graphics.setColor(1.,1.,1.,1.0)
	love.graphics.rectangle('fill',screenPos.x,screenPos.y,screenPos.w,screenPos.h)
	renderWidgets(widgets)

		
	msgToCvs()

	--love.graphics.print()
	love.graphics.setCanvas()
end


local function zoomPosDraw()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(.5,.5,.5,1.0)
		--love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
		
end



local function zoomPosUpdate()
	 if npress==true then
--	    print('bs click')
--	    addMsg('bs click')
	    consumed=consumeClick(widgets)
--	    print('consumed '..tostring(consumed))brushScreenbrushScreen
	    if consumed==true
	    then
		return
	    end


	    npress=false
	 end

end


function toZoomPos()

  createZPButtons()
  uiResize=createZPButtons

	bbsettexture(screenPos,frames[currentIdx].pic)
	screenPos.x=offsetcvs.x
	screenPos.y=offsetcvs.y
	screenPos.w=conf.cvsw
	screenPos.h=conf.cvsh
	screenPos.keepratio=true

	drawFunc=zoomPosDraw
	updateFunc=zoomPosUpdate

end



