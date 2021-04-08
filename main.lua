--PRIOS


-- color marker finish
--wip end bgs markers
-- working zoom on work screen
-- hack palm rejection like zazanim

-- profiles : hide buttons on simpler profile

-- poc paint mode: dont render if display not dirty (x230t burning hot)  ON HOLD


-- on android; on undo of fill, reverted frame has antialias
-- on erase, same, canvas seems polluted or blend mode to be changed
-- you draw, erase, draw on same area, on pen up > artefacts on edge of brush
-- pb seems display only, to check on saved frames : if you switch to paint under and back,
-- corruption disappears

-- quick brutal  script  to push pull in one line project ( possibly save it auto )

-- save timestamp of last save , display it on load ( to see most recent version on multiple devices )


--bug when cb or ce nil, multi set timecodes fails on nil

--wip storyboard
--wip shift frames on save, only save dirty
--  dirty on fill
-- TODO dirty on paste brush



-- fill mode gives strange results;
-- separate hard fill and soft fill 


-- anim brush : as dpaint select a cycle and paste it while moving

-- pencil brush : pattern + flow that is less strong ( blits per sec / move ? )

--bug on android, undo puts bilinear onborders of paint
-- only happens on overlay of BG , maybe just BG rt composition

--light table on paste or default position of the sub selection ( goo example )


-- export
--TODO handle repetitions
--TODO handle BGs



-- image magick szems to fail on 1920x1080 files, fond qlternqtive


--bug : when paint under enabled you cant disable CHECK

-- emergency save and TODO button and reload on android 


--test harness for shader on multiple device:
-- program that monitors shader change on disk and restart lua program
-- could be done to work on all connected android devices through a bash script that pushes the changes,
-- or periodic automatic git pull on device


--color marker for color frame DONE
--  skip in (tc codes 0 ) playback and export and flick
-- wip calculateFlickRange()
-- composite in export 
--  overlay display of next frame on top DONE
-- mode to light table only without color frames WIP

--URGENT "bg off" marker


-- asynchronous save :
-- an alternative to full save could be to save every modification as it happens ,
-- in a background frame

--paint under classic brush ( glass pane ) DONE


-- TODO resize screen ( small button on top left )


-- WIP repetition
-- export TODO


-- incremental save and moves : first in 2nd folder, to test with diffing vs slow save


-- DEPRIO , needs setup to test multi device ( remotely launch shader prog on lin, andro , win )
-- paint under shader brush
  -- doesn't work on android, garbles outline, then on second toggle, crashes 
  -- maybe shader recreate?
  
-- replace color shader brush

-- display a brush preset widget in settings ( widget as to move on other screen later )
-- for use on mobile

--light table shader : define ink and only display ink 
-- (useful on a project that is being colored)


-- search for dpiscale in custom gradle love build to understand how when it triggers



--hard toggle : use button recreation to hide impossible button

--use bg toggle in flick/ add bg toggle in ui

--check if 0 time code is omitted in play back and export

--save wav  ( could just use wav.lua and patch path )

--turn project screen in generic file requester ( could be used to select wav )



-- TODO could be replaced by a small button next to previous (quarter size ) that resets zoom
-- TODO track left resize/dpi scale bugs on android

--WIP uiw that scales to ratio, now part of resize hook
-- WIP right buttons need to be recreated on each resize and screen nav




--improve project change ,  save pic previews and play them on menu screen

--incremental save


--WIP  zoom pos,
-- BUG keep ratio resize kills ratio
-- BUG keep ratio resize also present on frame copy / paste

--brush selection paste :
-- put correct images
-- display light table
-- scale the brush linked to selection 

--strange bug when colorfilling then undoing on soft brush outline : afterwards the alpha is versus black
--even after normal stroke undo,
-- outline of grass antialias changes
-- TENTATIVE FIX m also fixed behavior of color fill after undo



--TODO toggle soft/hard brush
-- WITH BUBBLE MESSAGE TOGGLE ON BRUSH PRESS

--note 8 android, on switch back and forth from app,
-- not all the time ?
--zoom is f#cked up
--needs an app restart
--app seems to be functioning ok otherwise


--POC  color fill
-- PLUG UNDO FOR IT WIP, fill with clear color doesn t play nice with alpha
-- undo works first time for color fill, then color fill ignores borders CRITICAL
--undo needs to be stacked on next and previous buttons

--display of brush presets, clickable for android
--test sd on 640 480

--export with frame composition and frame multi
--export to avi script
--	 export frames correctly ( bg color, bg )
--	 multiply frames
--	 generate scripts WORKS

--palm rejection: ( workaround on x230t, disable touch with xsetwacom )
-- if multitouch detected on zazanim cpp, last paint is undoed ( canceling palmtouch )
-- could be good workaround 

--create new seq putting unknown name in current project > should work (crashes)
--display different deco on 'covered with sound '
--bg color set 
-- buttons that are hidden on right for select ratios
--frame number display bigger DONE
--brush shortcuts on 1 2 3 4 5 6 7 8 9 0 ( function keys not on mac )
--on BG frame, eraser doesn t work TOGGLE WORKAROUND
--deco BG  DONE
--deco SON DONE
--shortcut to display bg or not DONE space
--desactiver paint on save KEYS disabled ? is it enough ?
--play from first frame shortcut DONE f key

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



--perf and HEAT : freeze display if no change

-- paint under
--stamp preview for sound adjust (story board screen)


-- cb ce aussi pour frame set
-- preview screen vignettes +sounc


--bug: copy part broken
--save should only save dirty frames

--default 8fps
--dflt timecode 1

--URGENT change project select template

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
print (os.date())

--global resource for all screens
buttonsPic=love.graphics.newImage("buttons.png")
require('list')
require('stringutil')
require('widgetutils')
require('msg')
require('zznerrorhandler')


require('picbutton')
require('textbutton')
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
--uiw=conf.uiw --TODO this should be determined in hduizoom to have button sticking to the righ
uih=conf.uih

require('colorfill')
serialize=require('ser')
require('bgranges')
require('colorframes')
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
require('export')
require('createnewsequence')
require('switchproject')
require('repetitionmarkers')
require('brushpicker')
require('settings')
require('flickmode')
require('brushpresets')
require('shaderpaintundermode')
require('basicpaintundermode')
require('basicpaintmode')
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
currentBrushFunc=roundBrushWithGradient
--	mybrush=love.graphics.newImage(roundBrushWithAlpha(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
	mybrush=love.graphics.newImage(currentBrushFunc(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
--	mybrush=love.graphics.newImage(roundBrushWithGradient(	brshradius,paintcolor.r,paintcolor.g,paintcolor.b))
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
