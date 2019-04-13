
--this is where we draw ( current frame)
cvsw=1920
cvsh=1080
--this is where we render the user interface before scaling
uiw=1920
uih=1080


 -- cvsw=ww
 -- cvsh=wh
 ww=854
 wh=480
 love.window.setMode(ww,wh,{resizable=true})
 
 scrsx=ww/cvsw
 scrsy=wh/cvsh
  
 
 love.window.setTitle("zaza2nim")
 --this is where the current frame is drawn
	cvs=love.graphics.newCanvas(cvsw,cvsh)
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
	local pscrsx=ww/cvsw
	local pscrsy=wh/cvsh
	if pscrsx>pscrsy then
		scrsy=pscrsy
		scrsx=pscrsy
	else
		scrsy=pscrsx
		scrsx=pscrsx
	
	end
end
