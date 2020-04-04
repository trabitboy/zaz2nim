--new priority items
-- create new project, change project
-- save brush
-- color / paint under mode
-- undo mode



-- WIP computer gets super hot in HD mode: try to not render screen if no change
-- keep display dirty flag 

--WIP select and move area ( brush 'a la ms paint ' )
-- selection is not croped ( doesn t use quad from bss )
-- no scaling at the moment

-- menu system for opening different projects based on available templates
-- concept : locked on a project, current project is saved,
-- but you can change project or create new with template
-- needs refactor of load and reinit of some parts


-- buttons should have same placement and size in hd and sd mode

-- background different from clear color to see canvas boundaries
-- TODO render the light table to a separate canvas,
-- so we can blit a white bg square behind

--calculate offset related to ui cvs and screen size

--notion of ink color ( multiples ? )
--paint under mode
--fill mode
--clean a single color mode

-- toggle display of eraser button


-- init of save directory : might not create if folder exists in prj folder
-- use io read io write?


--zaz2nim
---- parameterize project canvas size ( 640 480 , 1920 1080 ) in config file of project 
-- require of config works






-- insert perf logs
-- palette bug > only some colors can be picked


-- screen scalling incorrectonandroid
--simpletouchwithout dragdoesn'twork dotimpossible
-- TODO script to migrate zazanim project
-- TODO copy range
-- TODO zoom mode
-- TODO queue fill mode
-- TODO shader fill mode
-- TODO bg layer
-- TODO virtual camera


-- minimum for mobile:
-- WIP settings screen with brush size
-- auto folder creation for project on android
--  scroll save TODO palette buttons
-- WORKS copy frame
-- test on android sd ( all devices )
-- NOTE 3 neo slow in hd
-- note 8 ok
-- note 4 untested
-- gtn 5110 untested
-- lenovo a310 untested
-- NOTE 8 NOK GTN5110 NOK > test again
-- 		frames are destroyed when scrolling
-- 		cvs save works in unit test on android
--		try disabling display when downloading tex 
--		try saving files when downloading
-- draw zazahead slowly then change feature = load splash
-- WIP pic button zith spritesheet


-- TODO do not use load filter for project load,
-- having drawable is not useful ( and must take up memory )
-- TODO do we need to release tex allocated all the time ?
-- brush

-- TO DECIDE ui cvs has same size and zoom as project canvas
-- BUG the brush is blit top left, not centered
-- DONE round brush 
-- DONE line interpolation
-- BUG add frame only adds at end of project, insertion should be possible
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
-- TODO virtual scroll (scene larger than screen)
-- TODO file requester


-- TODO sound capture test
--https://love2d.org/forums/viewtopic.php?t=86173


--TODO drag and drop widget for cut and paste
-- based on mtdt titler boxes
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


--global resource for all screens
buttonsPic=love.graphics.newImage("buttons.png")
require('stringutil')
require('widgetutils')
require('msg')

require('picbutton')
require('brushbox')
require('hdconf')
--require('sdconf')
require('seqselection')

require('shaders')
require('interpolateLine')
require('tblutil')
require('loadfilter')
require('touch')
require('loadsave')
require('playmode')
require('palette')
require('pickmode')
require('timecode')
require('brushsourceselection')
require('brushscreen')
require('settings')
require('flickmode')
require('paintmode')
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
	
	maxframe=0
	--frames are 0 based for zazanim compatibility ( tcs, etc )
	local i = 0
	currentName=conf.prjfld..string.format("%03d",i)..".png"
	print("attempting load "..currentName)
	cur=love.filesystem.getInfo(currentName)
	if cur==nil then
		print('loading from template '..conf.template)
		cur=love.filesystem.getInfo(conf.template)
		print('tmpl ')
		print(cur)
		currentName=conf.template
	end
	
    while cur do
		frameTable =loadfilter(currentName)
		--please note we will add other metadatas in frameTable, such as time code and optional sound
		--we are here because cur is not nil
		table.insert(frames,frameTable)
		maxframe=i
		i = i + 1
		currentName=conf.prjfld..string.format("%03d",i)..".png"
		print("attempting load "..currentName)
		cur=love.filesystem.getInfo(currentName) 
		if i<4 and cur==nil then
			--TODO load template and put in cur
			cur=love.filesystem.getInfo(conf.template)
			currentName=conf.template
		end
    end
	
	
	
	loadTxtCodes()
	
	initCanvases(currentIdx)
	
	-- mybrush=love.graphics.newImage(createBrushID(16))
	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
	mybrush:setFilter('nearest','nearest')
	
	createInkShader()
	createEraserShader()
	
end

-- 

	

	
-- default mode, could be changed

toPaintMode()


love.keypressed = function(key, code, isrepeat)
	
	keyFunc(key, code, isrepeat)
	
	
end


function love.draw()
	drawFunc()

end


function love.update()
	updateFunc()
end
