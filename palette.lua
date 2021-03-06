
legacyPalettePic= loadfilter('palette.png')


function paletteModeDraw()
	
	
	love.graphics.setCanvas(ui)
	love.graphics.clear()
	love.graphics.draw(legacyPalettePic.pic,0,0,0,zxpal,zypal)
	love.graphics.setCanvas()
	
	love.graphics.clear(0.,0.,0.,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)
	
end

function paletteModeUpdate()
	if npress==true and npx<rwpal and npy<rhpal then
		--pick color
		r,g,b,a=legacyPalettePic.data:getPixel(npx/zxpal,npy/zypal)
		addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
		addMsg('quit palette')
		-- mybrush=love.graphics.newImage(roundBrushWithAlpha(8,r*255,g*255,b*255))
--		mybrush=love.graphics.newImage(roundBrushWithGradient(brshradius,r,g,b))
		mybrush=love.graphics.newImage(currentBrushFunc(brshradius,r,g,b))
		mybrush:setFilter('nearest','nearest')

		paintcolor.r=r
		paintcolor.g=g
		paintcolor.b=b
		npress=false		
		toPaintMode()
		return
	end
end

function paletteModeKey(key, code, isrepeat)
	
end

function toPaletteMode()
	saveCanvasToFrame(currentIdx)

	 keyFunc = paletteModeKey
	drawFunc=paletteModeDraw
	updateFunc=paletteModeUpdate

	--let's calculate scale factor to ui canvas  ( to interprete clicks properly )
	local pw=legacyPalettePic.data:getWidth()
	local ph=legacyPalettePic.data:getHeight()

	zxpal= uiw/pw
	zypal= uih/ph
	
	
	
	if zxpal<zypal then
		zypal=zxpal
	else
		zxpal=zypal
	end

  rwpal=pw*zxpal
  rhpal=ph*zypal

	addMsg("pal ui zoom ".. zxpal)

end
