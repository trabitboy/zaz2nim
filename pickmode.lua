
local function commonInit()
	-- saving canvas to frame, to be sure we pick 
	--latest changes
	saveCanvasToFrame(currentIdx)


	drawFunc = pickModeDraw
	updateFunc = pickModeUpdate

end

--mode flag
local fill=false

function toFloodFill()
	 print('init flood fill')
	 fill=true
	 commonInit()

end

function toPickMode()
	 fill=false
	 commonInit()
	
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
	   if npx<conf.cvsw and npy<conf.cvsh and fill==false  then
	        print('pick color triggered')

	   	--pick color
		r,g,b,a=frames[currentIdx].data:getPixel(npx,npy)
		addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
		addMsg('quit pick')
--		mybrush=love.graphics.newImage(roundBrushWithAlpha(brshradius,r,g,b))
		mybrush=love.graphics.newImage(roundBrushWithGradient(brshradius,r,g,b))
		mybrush:setFilter('nearest','nearest')

		paintcolor.r=r
		paintcolor.g=g
		paintcolor.b=b
		
		npress=false
		
		toPaintMode()
		return
	   elseif npx<conf.cvsw and npy<conf.cvsh and fill==true  then
	   	--local r,g,b,a = frames[currentIdx].data:getPixel(npx,npy)
	   	print('calling flood fill')

	   	floodFill(npx,npy,paintcolor,frames[currentIdx].data,frames[currentIdx].data)


		--image data needs to be uploaded back to gpu mem
		frames[currentIdx].pic:release()
		frames[currentIdx].pic=love.graphics.newImage(frames[currentIdx].data)

		--TODO upload to work canvas
		initCanvases(currentIdx)

		npress=false
		
		toPaintMode()
		return

	   else
		npress=false
		print('out of boundaries')
	   end
	end

end