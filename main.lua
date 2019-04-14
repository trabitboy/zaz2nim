--zaz2nim

--poc paint to canvs 
-- poc save to file and scroll with ul and dl of image data


require('screenandcvs')
require('loadfilter')
require('touch')
require('paintmode')


prjfld="project/"

require('brush')


-- function paint(x,y)
	-- love.graphics.setCanvas(ui)
	-- love.graphics.draw(mybrush,x,y)
	-- love.graphics.setCanvas()
-- end



--project structure
	frames={}
--end project globals
function love.load()
	files=love.filesystem.getDirectoryItems(prjfld)
	for i,f in ipairs(files)
	do
		suffix=f:sub(f:len()-3,f:len())
		print(f..' '..suffix)
		if suffix==".png" then
			table.insert(frames,loadfilter(prjfld..f))
		end
	end
	mybrush=love.graphics.newImage(createBrushID(16))
end

-- 

	

	
-- end



keyFunc = paintModeKey

love.keypressed = function(key, code, isrepeat)
	
	keyFunc(key, code, isrepeat)
	
	
end




drawFunc=paintModeDraw

function love.draw()
	drawFunc()

end

updateFunc=paintModeUpdate

function love.update()
	updateFunc()
end