--zaz2nim

require('loadfilter')

prjfld="project/"

function love.load()

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
	love.graphics.draw(frames[1].pic,0,0)
end
