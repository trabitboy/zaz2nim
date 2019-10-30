



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
	
	--display canvas?
	--pick color frim cvs?
love.graphics.draw(frames[currentIdx].pic)
msgToCvs()
love.graphics.setCanvas()

end
