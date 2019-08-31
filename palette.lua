
legacyPalettePic= loadfilter('palette.png')


function paletteModeDraw()
	love.graphics.clear()
	love.graphics.draw(legacyPalettePic.pic)
end

function paletteModeUpdate()
	if npress==true then
		--pick color
		r,g,b,a=legacyPalettePic.data:getPixel(npx,npy)
		addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
		addMsg('quit palette')
		toPaintMode()
		return
	end
end

function paletteModeKey(key, code, isrepeat)
	
end

function toPaletteMode()
	keyFunc = paletteModeKey
	drawFunc=paletteModeDraw
	updateFunc=paletteModeUpdate

end
