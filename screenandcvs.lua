
--this is where we draw ( current frame)
-- cvsw=1920
-- cvsh=1080
--this is where we render the user interface before scaling
uiw=conf.cvsw
uih=conf.cvsh


 -- cvsw=ww
 -- cvsh=wh
 ww=854
 wh=480
 
 --TODO what happens on android ?
 love.window.setMode(ww,wh,{resizable=true})
 
 
 function determineHDUicanvasZoom(nww,nwh)
	local pscrsx=nww/conf.cvsw
	local pscrsy=nwh/conf.cvsh
	if pscrsx>pscrsy then
		scrsy=pscrsy
		scrsx=pscrsy
	else
		scrsy=pscrsx
		scrsx=pscrsx
	
	end
 
 
 end
 
 
 -- scrsx=ww/conf.cvsw
 -- scrsy=wh/conf.cvsh
 
determineHDUicanvasZoom(ww,wh) 
 
 love.window.setTitle("zaza2nim")
 --this is where the current frame is drawn
 
 --for android, otherwise dl image data is oversized
 settings={}
settings.dpiscale=1.0

-- cvs=love.graphics.newCanvas(640,480,settings)
	cvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh,settings)
	ui=love.graphics.newCanvas(uiw,uih)	
--this is where the whole ui is drawn before resize	

--typo width height (pic size)
tw=80
th=200
--meaninful area in the middle (to trim empty space)
rtw=(tw/2)

function love.resize( nw, nh )
	local npw,nph=love.window.toPixels( nw, nh )
	ww=npw
	wh=nph

	determineHDUicanvasZoom(ww,wh) 


	-- local pscrsx=ww/conf.cvsw
	-- local pscrsy=wh/conf.cvsh
	-- if pscrsx>pscrsy then
		-- scrsy=pscrsy
		-- scrsx=pscrsy
	-- else
		-- scrsy=pscrsx
		-- scrsx=pscrsx
	
	-- end
end