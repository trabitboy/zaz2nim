
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
	love.graphics.rectangle('fill',0,0,conf.cvsw,conf.cvsh)
love.graphics.draw(frames[currentIdx].pic)
msgToCvs()
love.graphics.setCanvas()

end

function pickModeDraw()

	rendertouicanvas()
	love.graphics.clear(.5,.5,.5,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function pickModeUpdate()
	if npress==true then
	   if npx<conf.cvsw and npy<conf.cvsh then
	   	--pick color
		r,g,b,a=frames[currentIdx].data:getPixel(npx,npy)
		addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
		addMsg('quit pick')
		-- mybrush=love.graphics.newImage(roundBrushWithAlpha(8,r*255,g*255,b*255))
		mybrush=love.graphics.newImage(roundBrushWithAlpha(brshradius,r,g,b))
		mybrush:setFilter('nearest','nearest')

		paintcolor.r=r
		paintcolor.g=g
		paintcolor.b=b
		
		npress=false
		
		toPaintMode()
		return
	   else
		npress=false
		print('out of boundaries')
	   end
	end

end