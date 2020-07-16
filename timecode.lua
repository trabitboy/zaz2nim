local clockQuad = {x=64, y=64, w=64, h=64}
realCQuad=love.graphics.newQuad(clockQuad.x,clockQuad.y,clockQuad.w,clockQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

local exitQuad = {x=0, y=18*64, w=64, h=64}
realExitQuad=love.graphics.newQuad(clockQuad.x,clockQuad.y,clockQuad.w,clockQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

local applyToRangeQuad = {x=64, y=9*64, w=64, h=64}




function exitTC()
	 print('exit tc '..frames[currentIdx].tc)
	 toPaintMode()
end

function applyToRange()
	 --applying current time code to selected range
	 if rangeBeginIdx==nil or rangeEndIdx==nil then
	    print(' nil marker, not possible , cb '..cb.. ' ce ' .. ce)
	    return
	 end

	 if rangeEndIdx<=rangeBeginIdx then
	    print(' end marker before begin marker, not possible ')
	    return 
	 end

	 for i=rangeBeginIdx,rangeEndIdx
	 do
		print('frame '..i..' tc set '..frames[currentIdx].tc)
		frames[i].tc=frames[currentIdx].tc

	 end
	 toPaintMode()
end


local widgets={}

createTCButtons=function()
  widgets={}
  wExitTc = createpicbutton(uiw-64,0,buttonsPic,exitTC,exitQuad)
  wATRTc = createpicbutton(uiw-64,64*buttonZoom,buttonsPic,applyToRange,applyToRangeQuad)
  table.insert(widgets,wExitTc)
  table.insert(widgets,wATRTc)
end

--utility
function loadTxtCodes()



	 --TODO load zazanim style tcs ( for interop )
       local tcf=love.filesystem.getInfo(conf.prjfld.."timecodes.txt")
	if tcf ~= nil then
		for sTc  in love.filesystem.lines(conf.prjfld.."timecodes.txt")
		do
			addMsg(sTc)
			addMsg(string.byte(sTc,1,3))
			addMsg(string.sub(sTc,1,3))
			local frmNum=tonumber(string.sub(sTc,1,3))
			addMsg(string.sub(sTc,5,7))
			local frmTc=tonumber(string.sub(sTc,5,7))
			--TODO be careful zazanim has different indexes
			frames[frmNum].tc=frmTc
			
		end
	end
end

function saveTxtCodes()
-- save zzn txt codes for interop
-- first frame 001:0tc ( 3 chars tc )
	timecodestring=""
	for i=1,maxframe 
	do
		timecodestring=timecodestring..string.format("%03d",i)..":"..string.format("%03d",frames[i].tc).."\n"
	end
	love.filesystem.write(conf.prjfld.."timecodes.txt",timecodestring)
end


function toTimeCode()
	print ('initial time code '..frames[currentIdx].tc )
  
  createTCButtons()
  uiResize=createTCButtons
  
  
	drawFunc=timeCodeDraw
	updateFunc=timeCodeUpdate

end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

	
	renderWidgets(widgets)

-- //should be define
	maxcol=(uiw-64) / ( 64 );
		
	col=0
	row=0

	for i=1,frames[currentIdx].tc 
	do
		love.graphics.draw(buttonsPic,realCQuad,col*64,row*64) 
		col=col+1	
		if col>=(maxcol-1) then
			col=0
			row=row+1
		end
	end
		
	msgToCvs()
	
	love.graphics.setCanvas()
end


function timeCodeDraw()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
		
end



function timeCodeUpdate()
	 if npress==true then
	    print('tc click')
	    consumed=consumeClick(widgets)
	    print('consumed '..tostring(consumed))
	    if consumed==true
	    then
		return
	    end

	    --we calculate the timecode 
	    local xtc=math.floor(npx/64)	    
	    local ytc=math.floor(npy/64)
	    local tmp=(ytc*uiw/64 -1 )+xtc
	    print('updating tc '..tmp)
      
      if tmp<0 then tmp=0 end
	    frames[currentIdx].tc = tmp
	    
	    npress=false
	 end

end
