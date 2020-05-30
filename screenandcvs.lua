
--buttons designed for 640x480 height, adjustment
uilogich=480

 --TODO what happens on android ?
--works, but should clarify dpiscale on forum
dpiScl=love.window.getDPIScale()
 
 if love.system.getOS()=='Android' then
	ww,wh=love.window.getMode()
	ww=ww/dpiScl
	wh=wh/dpiScl
 else
 
 ww=854
 wh=480
 love.window.setMode(ww,wh,{resizable=true})
 end
 
 addMsg(" w h "..ww.. ' ' ..wh)
addMsg(" dpi scl "..dpiScl)
  
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
	addMsg('zoom ' .. scrsx)

	buttonZoom = uih /480 --button size is ok on 480 height
	addMsg('button zoom '..buttonZoom)
 end
 

--ui canvas coordinates, should be centered and calculated when uiw uih calculated
offsetcvs={x=200,y=0}


 
determineHDUicanvasZoom(ww,wh) 
 
 love.window.setTitle("zaza2nim")
 --this is where the current frame is drawn
 
 --for android, otherwise dl image data is oversized
 technicalcvssettings={}
 technicalcvssettings.dpiscale=1.0

	cvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh,technicalcvssettings)
	ui=love.graphics.newCanvas(uiw,uih)	

--probably settings are used just for texture download ?
function initUndoBuffers()
	 print ('undo buffers init')
	 for i=1,undoDepth
	 do
		--we allocate backup canvases
--		local undocvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh,technicalcvssettings)
		local undocvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh)
		undoBuf[i]=undocvs
	 end

end


function love.resize( nw, nh )
	local npw,nph=love.window.toPixels( nw, nh )
	ww=npw
	wh=nph

	determineHDUicanvasZoom(ww,wh) 


end
