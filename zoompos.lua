local exitQuad = {x=4*64, y=1*64, w=64, h=64}
local unzoom8Quad = {x=3*64, y=1*64, w=64, h=64}
local zoom8Quad = {x=0, y=320, w=64, h=64}


--there is a technical zoom (scrsx, scrsy) that scales ui canvas to screen,
--but when blitting to ui canvas, sometimes we want to zoom in out the canvas ( result of this screen )
applicativezoom=1.0
--dbg
--applicativezoom=0.5


local screenPos = createbrushbox(100,100,200,200,true)

local function exitZP()
	 print('exit zp ')
	 --copy offset
	 offsetcvs.x=screenPos.x
	 offsetcvs.y=screenPos.y

	 --copy zoom

   applicativezoom=1.0
   --why only change app zoom in this case?
   if screenPos.w~=screenPos.texture:getWidth() then 
              applicativezoom=screenPos.w/screenPos.texture:getWidth()
   end  


	 toPaintMode()
end

function resetZoom()
	print('reset zoom')
	bbresetzoom(screenPos)
	screenPos.x=offsetcvs.x
	screenPos.y=offsetcvs.y

end
  

function zoom8()
  bbzoomset(screenPos,2.)
end

function unzoom8()
  
  bbzoomset(screenPos,0.5)
end

--local wToBSS = createpicbutton(uiw-64,uih-64,buttonsPic,toBrushSourceSelection,exitQuad)
--local wStamp = createpicbutton(uiw-64,0,buttonsPic,stampSelection,exitQuad)



local widgets={}

createZPButtons=function()
  widgets={}
  
  local wExitZP = createpicbutton(0,0,buttonsPic,exitZP,exitQuad,buttonZoom)
  local wZoom8 = createpicbutton(0,uih-64*buttonZoom,buttonsPic,zoom8,zoom8Quad,buttonZoom)
  local wreset = createpicbutton(uiw-64*buttonZoom,uih-128*buttonZoom,buttonsPic,resetZoom,unzoom8Quad,buttonZoom)
  local wUnzoom8 = createpicbutton(uiw-64*buttonZoom,uih-64*buttonZoom,buttonsPic,unzoom8,unzoom8Quad,buttonZoom)
 
  table.insert(widgets,wExitZP)
  table.insert(widgets,wUnzoom8)
  table.insert(widgets,wZoom8)
--   table.insert(widgets,wToBSS)
  table.insert(widgets,wreset)
--   table.insert(widgets,wStamp)
  table.insert(widgets,screenPos )

end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,1.0)

	love.graphics.setColor(1.,1.,1.,1.0)
	love.graphics.rectangle('fill',screenPos.x,screenPos.y,screenPos.w,screenPos.h)
	renderWidgets(widgets)

		
	msgToCvs()
  displayHoverMsg()
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

--zoom dezoom with keyboard
zoomPosKey=function(key, code, isrepeat)
	if key=='up' then
    bbzoomset(screenPos,0.5)
	end

	if key =='down' then
    bbzoomset(screenPos,2.)
	end 
  
end

function toZoomPos()

  createZPButtons()
  uiResize=createZPButtons

	bbsettexture(screenPos,frames[currentIdx].pic)
  
  
  --TODO zoom should be copied from global
	screenPos.x=offsetcvs.x
	screenPos.y=offsetcvs.y
	
  --this should be done auto in bbsettexture, if no quad passed
  screenPos.w=conf.cvsw
  screenPos.initw=conf.cvsw
	screenPos.h=conf.cvsh
	screenPos.inith=conf.cvsh

--WIP to check and update
--   bbzoomset(screenPos,applicativezoom)


 	keyFunc = zoomPosKey
	drawFunc=zoomPosDraw
	updateFunc=zoomPosUpdate

end



