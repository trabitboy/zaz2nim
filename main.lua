--export with frame composition and frame multi
--export to avi script
--	 export frames correctly ( bg color, bg )
--	 multiply frames
--	 generate scripts ?
--


--display different deco on 'covered with sound '
--bg color set 
-- buttons that are hidden on right for select ratios
--Paste range seems broken TODO
--Multi TC seems broken DONE ?
--frame number display bigger DONE
--brush shortcuts on 1 2 3 4 5 6 7 8 9 0
--on BG frame, eraser doesn t work TOGGLE WORKAROUND
--deco BG  DONE
--deco SON DONE
--undo seems unreliable, only 1x
--shortcut to display bg or not DONE space
--undo doesnt seem to work on back from settings
--desactiver paint on save KEYS disabled ? is it enough ?
--play from first frame shortcut DONE f key

--color fill
--color destroy


--emergency save
--level 1
--current frame with other name/ current frame name
--level 2
-- option to resave all projects DONE
--level 3
-- diff save


--diffsave
--will improve android perf
--tracke moves
--track dirty
--use tmp folder

--palette crash if you click out of palette

--event pb on pc , with wacom : on window exit pen is blocked on down


--storyboard display and selection ( easy at first , scroll buttons and cb ce mimicking settings )
-- fill tool pour lucien
--paint under
-- palm rejection
-- export -- generation video
--brosses zaza


-- changer projet depuis interface
-- color layer

--debit de peinture ( pressure and velocity ) ,
-- trying to create smooth anime ink brush


-- WIP  move wavs on save
-- 	since project can contract or expand,
--	most secure way is copying the wavs in a tmpwav folders
-- 	when saving projects, we erase originals and copy the ones from the temp folder in the right place
-- TODO move wavs while editing



--change project easily :
--put all the confs in a map,
-- activate one conf
-- seqselection is a folder name, loaded from projects root
-- inside of project folder, additional file to load : profile.lua
-- contains key of projectconfig ( hd,hd43,sd )



--paste range to do
--save load brushes
--brush display  TODO
--disable background shortcut
--perf : freeze display if no change

-- paint under
--stamp preview for sound adjust (story board screen)
--fill mode



-- cb ce aussi pour frame set
-- preview screen vignettes +sounc


--bug: copy part broken



--save should only save dirty frames

--default 8fps
--dflt timecode 1
--WIP pencil button and separate setting

--URGENT change project select template

--WIP  zoom pos,
-- BUG keep ratio resize kills ratio
-- BUG keep ratio resize also present on frame copy / paste
--bg color behind canvas

--WIP load/play waves

-- slow erase

-- fill mode

-- paint behind

--bg layer

--new priority items
-- create new project, change project
-- save brush preset
-- color / paint under mode
-- undo mode

--virtual camera movements

--WIP sound load (wav with frame number )
-- not tested

-- WIP computer gets super hot in HD mode: try to not render screen if no change
-- keep display dirty flag 

--WIP select and move area ( brush 'a la ms paint ' )
-- selection is not croped ( doesn t use quad from bss )
-- TODO no scaling at the moment

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
--works on linux

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
require('zznerrorhandler')


require('picbutton')
require('brushbox')

--project templates
prjTemplates={}
require('hdconf')
require('hd43conf')
require('sdconf')



--TODO change to load of config file
require('seqselection')
--WIP we hardcode profile for now
--conf=prjTemplates['hd43']
uiw=conf.uiw
uih=conf.uih

require('colorfill')

serialize=require('ser')
require('bgranges')
require('modal')
require('shaders')
require('interpolateLine')
require('tblutil')
require('loadfilter')
require('touch')
require('loadsave')
require('loadscreen')
require('savescreen')
require('screenandcvs')
require('storyboard')
require('playmode')
require('palette')
require('pickmode')
require('timecode')
require('zoompos')
require('brushsourceselection')
require('brushscreen')
require('settings')
require('flickmode')
require('brushpresets')
require('paintmode')



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

--default
	brshradius=8

	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
	mybrush:setFilter('nearest','nearest')
	
	createInkShader()
	createEraserShader()


	-- TODO wire to load screen
	initLoadScreen()

   	--to comment if load screen in place
--	loadFrames()	
--	loadTxtCodes()	
--	initCanvases(currentIdx)
   	--to comment if load screen in place
	
	
end

-- 

	

	
-- default mode, could be changed

--toPaintMode()


love.keypressed = function(key, code, isrepeat)
	if keyFunc~=nil then	
		keyFunc(key, code, isrepeat)
	end
	
end


function love.draw()
	drawFunc()

end


function love.update()
	updateFunc()
end
