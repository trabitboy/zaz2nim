local widgets={}

function addFrame()
	newid = love.image.newImageData(cvsw,cvsh)
	newp=love.graphics.newImage(newid)
	table.insert(frames,{pic=newp,data=newid})
	maxframe=maxframe+1
	
end


local wAddFrame=createpicbutton(100,100,"bplus.png",addFrame)
table.insert(widgets,wAddFrame)


--main paint mode, paints to current canvas, displays light table and side buttons
onionDepth=1 --TODO

currentIdx=2

maxframe=3


function initCanvases(idx)
	-- if idx>1 then
		
	-- end
	
	--we only init current to canvas, rest is programmatic ( different from zazanim, 
	-- to have multiple tranparency layers
	currentIdx=idx
	
	--init canvas with loaded pic
	love.graphics.setCanvas(cvs)
	love.graphics.clear(1.,1.,1.,0.)
	--DBG
	-- love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(frames[currentIdx].pic,0,0)
	
	love.graphics.setCanvas()
	
end

local function renderWidgets()
	for i,w in ipairs(widgets)
	do
		w.render(w)
	end

end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

--TODO haha compute indexes 

	love.graphics.print('zaz2nim',0,0)
	
	if currentIdx-1>0 then 
		love.graphics.setColor(1.0,1.0,1.0,0.5)
		love.graphics.draw(frames[currentIdx-1].pic,0,0)
	end

	if frames[currentIdx+1] then 
		love.graphics.setColor(1.0,1.0,1.0,0.5)
		love.graphics.draw(frames[currentIdx+1].pic,0,0)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(cvs,0,0)
	
	love.graphics.draw(mybrush,0,0)

	renderWidgets()
	
	
	love.graphics.setCanvas()

end

function saveCanvasToFrame(idx)
	fromGpu=cvs:newImageData()
	frames[idx].data=fromGpu
	frames[idx].pic=love.graphics.newImage(fromGpu)

end

function paintModeKey(key, code, isrepeat)
	--simple debug for poc
	if key=="f1" then
		-- toSave=cvs:newImageData()
		-- toSave:encode("png","mycvs.png")
		saveFrames()
	end

	if key=="left" then
		if currentIdx>1 then
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)
			
			currentIdx=currentIdx-1
			print("frame down")
			initCanvases(currentIdx)
		end
		
	end
	
	if key=="right" then
		if currentIdx<maxframe then
			--save canvas to frame
			saveCanvasToFrame(currentIdx)


			currentIdx=currentIdx+1
			print("frame up")
			initCanvases(currentIdx)
		end
	
	end
	

end


function paintModeDraw()
	 rendertouicanvas()
	-- love.graphics.setColor(0.5,0.5,0.5,1.0)
	love.graphics.clear(0.5,0.5,0.5,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)

end


function dragPaint(cb,x, y, dx, dy, istouch)
	print("dx,dy "..dx.." "..dy)
	blitBrush(lastblitx+dx,lastblity+dy)
end


lastblitx=nil
lastblity=nil

function blitBrush(x,y)
	print("blit x,y "..x.." "..y)
	love.graphics.setCanvas(cvs)
	love.graphics.draw(mybrush,x,y)
	love.graphics.setCanvas()
	lastblitx=x
	lastblity=y
end

function paintModeUpdate()
	if npress==true then
		for i,w in ipairs (widgets)
		do
			ret=w.click(w,npx,npy)
			if ret==true then
				npress=false
				break
			end

		end
		
	
		-- love.graphics.setCanvas(cvs)
		-- love.graphics.draw(mybrush,npx,npy)
		-- love.graphics.setCanvas()
		blitBrush(npx,npy)
		registerdrag={drag=dragPaint}
		npress=false
	end
end

