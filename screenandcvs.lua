--TODO uiw needs to be screen / window width
--TODO re allocate ui canvas ? dunno


function love.visible(v) --dunno work on android
    addMsg(v and "Window is visible!" or "Window is not visible!");
end

function love.focus(f)
  if f then
    addMsg("Window is focused. dpiscale "..love.graphics.getDPIScale())
    --SUCCESS this is a fix for cover clap on android 
   if love.system.getOS()=='Android' then
    ww,wh=love.window.getMode()
    dpScl=love.graphics.getDPIScale()
    ww=ww/dpiScl
    wh=wh/dpiScl
    determineHDUicanvasZoom(ww,wh)
   end
  else
    addMsg("Window is not focused.")
  end
end



--lets determine max tex size
limits=love.graphics.getSystemLimits()
print('DBG max texture size '..limits.texturesize)
maxTextureWH= math.floor(limits.texturesize/4)
print ('DBG maxTextureWH '..maxTextureWH)


--buttons designed for 640x480 height, adjustment
uilogich=480

 --TODO what happens on android ?
--works, but should clarify dpiscale on forum
dpiScl=love.window.getDPIScale()
addMsg('initial dpiscale '..dpiScl)
 
 
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
  print(" w h "..nww.. ' ' ..nwh)
   
	local pscrsx=nww/conf.cvsw
	local pscrsy=nwh/conf.cvsh
	if pscrsx>pscrsy then
		scrsy=pscrsy
		scrsx=pscrsy
	else
		scrsy=pscrsx
		scrsx=pscrsx
	
	end
	addMsg('cvs zoom ' .. scrsx)

	buttonZoom = uih /480 --button size is ok on 480 height
  
  
  --TODO uiw need to be capped related to max texture size
  uiw=math.floor(nww/scrsx)
  if uiw>maxTextureWH then
    uiw=maxTextureWH
  end
	addMsg('button zoom '..buttonZoom)
  
  
  if ui~=nil then
    ui:release()
  end
  
  --TODO does UIW need to be scaled before creation
  print('creating ui cvs uiw '..uiw .. ' uih ' ..uih)
  
	ui=love.graphics.newCanvas(uiw,uih)	--TODO this should be determined in hduizoom to have button sticking to the righ
  
  
 end
 

--ui canvas coordinates, should be centered and calculated when uiw uih calculated
offsetcvs={x=200,y=0}


 
determineHDUicanvasZoom(ww,wh) 
 
 love.window.setTitle("zaza2nim")
 --this is where the current frame is drawn
 
 --for android, otherwise dl image data is oversized
 technicalcvssettings={}
 technicalcvssettings.dpiscale=1.0


  --TODO old canvas should be released
	cvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh,technicalcvssettings)
  --backbuffer is for shader paint and compose of export frames
  backBufferCvs=love.graphics.newCanvas(conf.cvsw,conf.cvsh,technicalcvssettings)
--TODO ui canvas should be released and changed on resize


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
  if uiResize~=nil then
    uiResize()
  end

end
