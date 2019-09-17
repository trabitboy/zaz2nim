eraseMode = false -- FOR DEBUG


local widgets={}


buttonsPic=love.graphics.newImage("buttons.png")
addQuad = {x=0, y=320, w=64, h=64}
prevQuad = {x=0, y=64, w=64, h=64}
nextQuad = {x=0, y=0, w=64, h=64}
saveQuad = {x=0, y=128, w=64, h=64}
eraserQuad = {x=0, y=192, w=64, h=64}




--disable display when saving canvas to imagedata ( android potential workaround )
--TODO remove
disableDisplay=false


--ui canvas coordinates
offsetcvs={x=200,y=0}

function addFrame()
	newid = love.image.newImageData(conf.cvsw,conf.cvsh)
	newp=love.graphics.newImage(newid)
	table.insert(frames,{pic=newp,data=newid})
	maxframe=maxframe+1
	
end

function prevFrame()
		if currentIdx>1 then
			addMsg("previous")
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)
			
			currentIdx=currentIdx-1
			print("frame down")
			initCanvases(currentIdx)
		end

end

function nextFrame()
		if currentIdx<maxframe then
			addMsg("next")
			
			--save canvas to frame
			saveCanvasToFrame(currentIdx)

			currentIdx=currentIdx+1
			print("frame up")
			initCanvases(currentIdx)
		end


end


-- local wAddFrame=createpicbutton(100,100,"bplus.png",addFrame)
-- local wNextFrame=createpicbutton(100,150,"bplus.png",nextFrame)
-- local wPrevFrame=createpicbutton(100,200,"bplus.png",prevFrame)
local wAddFrame=createpicbutton(0,100,buttonsPic,addFrame,addQuad)
local wNextFrame=createpicbutton(0,150,buttonsPic,nextFrame,nextQuad)
local wPrevFrame=createpicbutton(0,200,buttonsPic,prevFrame,prevQuad)

local wSaveFrames=createpicbutton(0,350,buttonsPic,saveFrames,saveQuad)


table.insert(widgets,wAddFrame)
table.insert(widgets,wPrevFrame)
table.insert(widgets,wNextFrame)
table.insert(widgets,wSaveFrames)


--main paint mode, paints to current canvas, displays light table and side buttons
onionDepth=1 --TODO

currentIdx=2

maxframe=3

-- flag to say if canvas in video memory contains modifications ( for save without scroll )
dirtycvs=false

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
		love.graphics.draw(frames[currentIdx-1].pic,offsetcvs.x,offsetcvs.y)
	end

	if frames[currentIdx+1] then 
		love.graphics.setColor(1.0,1.0,1.0,0.5)
		love.graphics.draw(frames[currentIdx+1].pic,offsetcvs.x,offsetcvs.y)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	
	--antialias ink of current frame
	love.graphics.setShader(inksmooth)
	love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y)
	love.graphics.setShader()
	love.graphics.draw(mybrush,0,0)

	renderWidgets()
	
	msgToCvs()
	
	
	love.graphics.setCanvas()

end

--TODO REMOVE try disable display as workaround on android 
function saveCanvasToFrame(idx)

	disableDisplay=true

	love.graphics.setCanvas()
	fromGpu=cvs:newImageData()
	frames[idx].data=fromGpu
	frames[idx].pic=love.graphics.newImage(fromGpu)
	
	disableDisplay=false
end

function paintModeKey(key, code, isrepeat)
	--simple debug for poc
	if key=="f1" then
		-- toSave=cvs:newImageData()
		-- toSave:encode("png","mycvs.png")
		addMsg('begin save')
		saveFrames()
		addMsg('save finished')		
	end
	if key=="p" then
		toPaletteMode()
		return
	end

	if key=="left" then
		-- if currentIdx>1 then
			-- addMsg("previous")
			
			-- --save canvas to frame
			-- saveCanvasToFrame(currentIdx)
			
			-- currentIdx=currentIdx-1
			-- print("frame down")
			-- initCanvases(currentIdx)
		-- end
		prevFrame()
	end
	
	if key=="right" then
		-- if currentIdx<maxframe then
			-- addMsg("next")
			
			-- --save canvas to frame
			-- saveCanvasToFrame(currentIdx)

			-- currentIdx=currentIdx+1
			-- print("frame up")
			-- initCanvases(currentIdx)
		-- end
		nextFrame()
	end
	

end


function paintModeDraw()
	if disableDisplay==true then
		-- we skip display hoping not to disturb canvas save
	else
		
		rendertouicanvas()
		-- love.graphics.setColor(0.5,0.5,0.5,1.0)
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		-- love.graphics.setShader(eraserShader)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)
		-- love.graphics.setShader()
		--dbg
		-- love.graphics.draw(buttonsPic,nextQuad,100,100)
	end
end


function dragPaint(cb,x, y, dx, dy, istouch)
	print("dx,dy "..dx.." "..dy)
	blitBrushLineRemember(lastblitx+dx,lastblity+dy)
end


lastblitx=nil
lastblity=nil

function blitBrushRemember(x,y)
	print("blit x,y "..x.." "..y)
	love.graphics.setCanvas(cvs)

	if eraseMode== true then 
		love.graphics.setBlendMode('replace')
		--following is ok for square brush
		-- love.graphics.setShader(eraserShader)
		--alternative method
		love.graphics.setColor(0.0,0.0,0.0,0.0)
		love.graphics.circle('fill',x,y,32)
	end

	love.graphics.draw(mybrush,x,y)

	love.graphics.setShader()

	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.setBlendMode('alpha')
	love.graphics.setCanvas()
	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end

--draws a line from last blit x last blit y to current coords
function blitBrushLineRemember(x,y)
	print("blit line x,y "..x.." "..y)
	
	local blits=calculateTraj(lastblitx,lastblity,x,y)
	
	
	love.graphics.setCanvas(cvs)

	if eraseMode== true then 
		love.graphics.setShader(eraserShader)
	end
	
	for i,b in ipairs(blits) do
		love.graphics.draw(mybrush,b.xbl,b.ybl)
	end

	love.graphics.setShader()

	love.graphics.setCanvas()
	

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
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
		
	
		--we compensate offset
		blitBrushRemember(npx-offsetcvs.x-brshradius,npy-offsetcvs.y-brshradius)
		registerdrag={drag=dragPaint}
		npress=false
	end
end

function toPaintMode()
	keyFunc = paintModeKey
	drawFunc=paintModeDraw
	updateFunc=paintModeUpdate

end
