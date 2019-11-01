
function toPickMode()

	-- saving canvas to frame, to be sure we pick 
	--latest changes
	saveCanvasToFrame(currentIdx)


	drawFunc = pickModeDraw
	updateFunc = pickModeUpdate
	
end


local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
	
	--display canvas?
	--pick color frim cvs?
love.graphics.draw(frames[currentIdx].pic)
msgToCvs()
love.graphics.setCanvas()

end

function pickModeDraw()
	rendertouicanvas()
	love.graphics.clear(1.,1.,1.,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
end


function pickModeUpdate()
	if npress==true then
		--pick color
		r,g,b,a=frames[currentIdx].data:getPixel(npx,npy)
		addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
		addMsg('quit pick')
		-- mybrush=love.graphics.newImage(roundBrushWithAlpha(8,r*255,g*255,b*255))
		mybrush=love.graphics.newImage(roundBrushWithAlpha(8,r,g,b))
		mybrush:setFilter('nearest','nearest')
		
		
		toPaintMode()
		return
	end

end