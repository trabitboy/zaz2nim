--zaz2nim

--poc paint to canvs 
-- poc save to file and scroll with ul and dl of image data


require('screenandcvs')
require('loadfilter')
require('touch')

prjfld="project/"

require('brush')


-- function paint(x,y)
	-- love.graphics.setCanvas(ui)
	-- love.graphics.draw(mybrush,x,y)
	-- love.graphics.setCanvas()
-- end


function love.load()

	mybrush=love.graphics.newImage(createBrushID(16))
	

	frames={}
	files=love.filesystem.getDirectoryItems(prjfld)
	for i,f in ipairs(files)
	do
		suffix=f:sub(f:len()-3,f:len())
		print(f..' '..suffix)
		if suffix==".png" then
			table.insert(frames,loadfilter(prjfld..f))
		end
	end
	
end

function rendertocanvas()
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

function love.draw()
	 rendertocanvas()
	-- love.graphics.setColor(0.5,0.5,0.5,1.0)
	love.graphics.clear(0.5,0.5,0.5,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)


end


function love.update()

	if npress==true then
	love.graphics.setCanvas(cvs)
	love.graphics.draw(mybrush,npx,npy)
	
	love.graphics.setCanvas()
	end
end