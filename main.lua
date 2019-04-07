--zaz2nim

require('loadfilter')

prjfld="project/"


--TODO faking for now
function createBrush(d)
	mine=love.image.newImageData(d,d)
	for j=0,d-1,1 
	do
		for i=0,d-1,1
		do
			mine:setPixel(i,j,1.0,1.0,1.0,1.0)
		
		end
	end
	
	return mine
end


function love.load()

	mybrush=love.graphics.newImage(createBrush(16))
	

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


function love.draw()
	love.graphics.print('zaz2nim',0,0)
	love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.draw(frames[1].pic,0,0)
	love.graphics.setColor(1.0,1.0,1.0,0.5)
	love.graphics.draw(frames[3].pic,0,0)
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(frames[2].pic,0,0)
	
	love.graphics.draw(mybrush,0,0)
end
