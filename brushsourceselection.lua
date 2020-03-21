local exitQuad = {x=64, y=17*64, w=64, h=64}



local function exitBSS()
	 print('exit bss ')
	 toBrushScreen()
end

local wExitBS = createpicbutton(0,0,buttonsPic,exitBSS,exitQuad)

local currentSel = createbrushbox(100,100,200,200)

local widgets={}
table.insert(widgets,wExitBS)
table.insert(widgets,currentSel )

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

--	let's render the picture we will render the paste on
	love.graphics.draw(frames[currentIdx].pic,offsetcvs.x,offsetcvs.y)

	renderWidgets(widgets)

		
	msgToCvs()
	
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


function toBrushSourceSelection()
	drawFunc=brushScreenDraw
	updateFunc=brushScreenUpdate

end



