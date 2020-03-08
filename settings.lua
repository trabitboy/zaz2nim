
brshLineWidth=128

brshMaxRad=128

local widgets={}

local clockQuad = {x=64, y=64, w=64, h=64}

cursorQuad = {x=0, y=0, w=64, h=64}
playQuad={x=0, y=4*64, w=64, h=64}
paletteQuad={x=64, y=6*64, w=64, h=64}
pickerQuad={x=64, y=15*64, w=64, h=64}



local wPlay=createpicbutton(uiw-64,0,buttonsPic,toPlayback,playQuad)
local wPalette =createpicbutton(uiw-64,64,buttonsPic,toPaletteMode,paletteQuad)

local wPicker =createpicbutton(uiw-64,128,buttonsPic,toPickMode,pickerQuad)

local wTC =createpicbutton(uiw-64,192,buttonsPic,toTimeCode,clockQuad)


table.insert(widgets,wPlay)
table.insert(widgets,wPalette)
table.insert(widgets,wPicker)
table.insert(widgets,wTC)


function toSettings()
	drawFunc=drawSettings
	updateFunc=updateSettings
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

--TODO haha compute indexes 
	love.graphics.setColor(1.0,.0,.0,1.0)
	love.graphics.line(brshLineWidth,0,brshLineWidth,uih)
	love.graphics.print('setting',400,0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(mybrush)
	
	
	renderWidgets(widgets)
	
	
	
	-- if currentIdx-1>0 then 
		-- love.graphics.setColor(1.0,1.0,1.0,0.5)
		-- love.graphics.draw(frames[currentIdx-1].pic,offsetcvs.x,offsetcvs.y)
	-- end

	-- if frames[currentIdx+1] then 
		-- love.graphics.setColor(1.0,1.0,1.0,0.5)
		-- love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y)
	-- end
	
	-- love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	-- --antialias ink of current frame
	-- love.graphics.setShader(inksmooth)
	-- love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y)
	-- love.graphics.setShader()
	-- love.graphics.draw(mybrush,0,0)

	-- renderWidgets()
	
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
			brshradius=npy/uih * brshMaxRad
			mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,0.0,0.0,0.0))
			mybrush:setFilter('nearest','nearest')
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