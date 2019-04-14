

--main paint mode, paints to current canvas, displays light table and side buttons
onionDepth=1

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
	love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.draw(frames[currentIdx].pic,0,0)
	
	love.graphics.setCanvas()
	
end





local function rendertouicanvas()
		love.graphics.setCanvas(ui)
		love.graphics.clear(1.0,1.0,1.0,0.0)


	love.graphics.print('zaz2nim',0,0)
	love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.draw(frames[1].pic,0,0)
	love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.draw(frames[3].pic,0,0)
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(cvs,0,0)
	
	love.graphics.draw(mybrush,0,0)

		love.graphics.setCanvas()

end

function paintModeKey(key, code, isrepeat)
	--simple debug for poc
	if key=="f1" then
		toSave=cvs:newImageData()
		toSave:encode("png","mycvs.png")
	end

	if key=="left" then
		if currentIdx>1 then
			currentIdx=currentIdx-1
			print("frame down")
		end
		initCanvases(currentIdx)
		
	end
	
	if key=="right" then
		if currentIdx<maxframe then
			currentIdx=currentIdx+1
			print("frame up")
		end
		initCanvases(currentIdx)
	
	end
	

end


function paintModeDraw()
	 rendertouicanvas()
	-- love.graphics.setColor(0.5,0.5,0.5,1.0)
	love.graphics.clear(0.5,0.5,0.5,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)

end

function paintModeUpdate()
	if npress==true then
	love.graphics.setCanvas(cvs)
	love.graphics.draw(mybrush,npx,npy)
	
	love.graphics.setCanvas()
	end

end

