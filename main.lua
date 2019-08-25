--zaz2nim
---- parameterize project canvas size ( 640 480 , 1920 1080 ) in config file of project 
-- require of config works
-- ui still blitted on 1080 canvas is it appropriate ?
-- insert perf logs


-- DONE round brush 
-- DONE line interpolation
-- WIP smooth ink shader
-- 		chosen ink color should be alphaed on neighboring pixels ( fireman ben style )
-- 		TODO the notion of canvas is not the same in zaz2nim
--		probably the canvas should be reblitted on a canvas of the same size, then scaled up?
--		otherwise the result will look different than target res?
-- try unit test in subfolder of project with main.lua
-- TODO interpolate unit test
-- TODO performance logs
-- DONE save modified buf even if no scroll
-- TODO save with smooth shader
-- TODO message system
-- TODO virtual scroll (scene larger than screen)
-- TODO file requester
-- TODO palette

--poc paint to canvs 
-- poc save to file and scroll with ul and dl of image data
--TASKS 
-- add pic button
-- note 3 neo test
-- note 8 tab test
-- perf logs on ul dl of tex
-- make resolution a variable
-- instead of blitting alpha brush (which modifies color because blends with bg even at alpha 0)
--   use canvas to store what is done on the canvas (keep brush color with some alpha)


require('msg')

require('picbutton')
-- require('hdconf')
require('sdconf')

require('shaders')
require('interpolateLine')

require('loadfilter')
require('touch')
require('paintmode')
require('loadsave')

require('screenandcvs')



require('brush')


-- function paint(x,y)
	-- love.graphics.setCanvas(ui)
	-- love.graphics.draw(mybrush,x,y)
	-- love.graphics.setCanvas()
-- end

renderdecos=true

--project structure
	frames={}
--end project globals
function love.load()
	--incorrect because the files are not ordered
	-- files=love.filesystem.getDirectoryItems(prjfld)
	-- for i,f in ipairs(files)
	-- do
		-- suffix=f:sub(f:len()-3,f:len())
		-- print(f..' '..suffix)
		-- if suffix==".png" then
			-- table.insert(frames,loadfilter(prjfld..f))
		-- end
	-- end
	
	maxframe=0
	local i = 1
	currentName=string.format("%03d",i)..".png"
	print("attempting load "..currentName)
	cur=love.filesystem.getInfo(conf.prjfld..currentName)
    while cur do
		table.insert(frames,loadfilter(conf.prjfld..currentName))
		maxframe=i
		i = i + 1
		currentName=string.format("%03d",i)..".png"
		print("attempting load "..currentName)
		cur=love.filesystem.getInfo(conf.prjfld..currentName)
    end
	
	
	initCanvases(currentIdx)
	
	-- mybrush=love.graphics.newImage(createBrushID(16))
	mybrush=love.graphics.newImage(roundBrushWithAlpha(16))
	mybrush:setFilter('nearest','nearest')
	
	createInkShader()
	
	
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