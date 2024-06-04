





-- the box which has the focus (only one ) for text andbutton interactions
boxfocus=nil

hdlw=32
hdlh=32

local dfltzoom =1.0

--added to pass keyboard commands
bbzoomset=function(b,zoomfactor)
  b.w=math.floor(b.w*zoomfactor)
  b.h=math.floor(b.h*zoomfactor)
end

local function drag(b,tx,ty,dx,dy)
	if b.mode=="drag" then
		b.x=b.x+dx
		b.y=b.y+dy
	end
	if b.mode=="resize" then

  --TODO should behavior not be changed when 
  -- not keep aspect ratio?

	--we need to determine real dx and real dy
	--when keeping ratio
	       local tsw= (b.w+dx)/b.w
	       local tsh= (b.h+dy)/b.h

--WIP distortion so far , probably loss of precision
--TODO calculate zoom and store zoom, let width and height of pic to display func
	       if tsw>=tsh then
	       	  b.w=math.floor(b.w*tsw)
	       	  b.h=math.floor(b.h*tsw)
	       else
	       	  b.w=math.floor(b.w*tsh)
	       	  b.h=math.floor(b.h*tsh)
	       end

--TODO zoom should also be changed


--		b.w=b.w+dx
--		b.h=b.h+dy
	end
	
	
end

--if consumed returns true
local function click(b,mx,my)
	print("scan click of brushbox ")


	if boxfocus==b then
		if mx >= b.x and mx<b.x+b.w and my >= b.y and my<b.y+b.h then
		      	print('drag')
			b.mode="drag"
			registerdrag=b
			return true
		end
		if mx >= b.x-hdlw and mx<b.x and my >= b.y-hdlh and my<b.y then
			b.mode="drag"
			registerdrag=b
			return true
		end
	
	end

	if boxfocus==b then
		if mx >= b.x+b.w and mx<b.x+b.w+hdlw and my >= b.y+b.h and my<b.y+b.h+hdlh then
			b.mode="resize"
			registerdrag=b
			return true
		end
	
	end
	
		
	if mx >= b.x and mx<b.x+b.w and my >= b.y and my<b.y+b.h then
--		print("click detected on id "..b.id)
		--before taking focus let s check focus 
		
		boxfocus=b
		return true
	end
	return false
end


local function editkey(b,key)
--	if key=='down' then

--	end
	
end









local function tbrender(b)
	love.graphics.setColor(0.0,1.0,0.0,1.0)
	if b==boxfocus then
		love.graphics.setColor(1.0,0.0,0.0,1.0)
	end
	
	
	if renderdecos==true then
	   	if b.texture~=nil then
		   
       if b.texquad~=nil then
         --WIP are we going here ?
       --not sure this is used ?
          local xZoom=1.
          if b.xFlip ==true then
            --WIP never reached
            xZoom=-xZoom
            addMsg('bb xflip rdr '..xZoom)
          end
          --reached
          addMsg('bb quad rdr')
          love.graphics.draw(b.texture,b.texquad,b.x,b.y,0,xZoom)
      else
          --TODO apparently never used
          --WIP try to comment to see if this can go
       
          -- if zoom has been changed, widget w is not the same as 
          -- texture width, we align on widget w to calculate zoom
          print('bb no quad blit')
          local bzoom=1.0
          if b.w~=b.texture:getWidth() then 
              bzoom=b.w/b.texture:getWidth()
          end  
        
          local xZoom=bzoom
          --never riched
          addMsg('bb rdr ')
          --TODO use xFlip APPARENTLY NOT USED PLEASE CLEAN
          if b.xFlip ==true then
            addMsg('bb xflip rdr')
            xZoom=-xZoom
          end
          --TODO SEEMS UNUSED
          love.graphics.draw(b.texture,b.x,b.y,0,xZoom,bzoom)
      end
		end

	   	love.graphics.setLineWidth(3)
		love.graphics.rectangle("fill",b.x-hdlw,b.y-hdlh,hdlw,hdlh)
		love.graphics.rectangle("line",b.x,b.y,b.w,b.h)
		love.graphics.rectangle("fill",b.x+b.w,b.y+b.h,hdlw,hdlh)
		love.graphics.setColor(0.0,0.0,1.0,1.0)
		love.graphics.setLineWidth(1)
		--for justify center
		love.graphics.line(b.x+b.w/2,b.y,b.x+b.w/2,b.y+b.h)
	
		love.graphics.setColor(1.0,1.0,1.0,1.0)
--		love.graphics.print(b.id,b.x-hdlw,b.y-hdlh)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	

end



--component has 2 modes, if a texture is passed,
--the selection is shown, 
--then scaled scaled WIP
function bbsettexture(bb,tex,quad,xFlip)
  addMsg('bb set tex xflip '..tostring(xFlip))
	 bb.texture=tex 
   --if optional quad is passed, the blit is on the quad portion
   bb.texquad=quad
   if xFlip~=nil then
    bb.xFlip=xFLip            
   end
end



--brush box represents a bitmap, so when resizing we maintain its
-- zoom ratio
function createbrushbox(x,y,w,h,keepratio,xFlip)
	ret={}
	
	ret.type='tbox' --used to identify targets for snap
	
--	wcount=wcount+1
	
--	ret.id=wcount

  --this is the display x y
	ret.x=x
	ret.y=y
  
  
  
	ret.w=w
	ret.h=h
	ret.keepratio=keepratio

	ret.render=tbrender
	ret.click=click
	ret.drag=drag
	
	ret.buffer={}	
	table.insert(ret.buffer,"")
	ret.editkey=editkey
	--current line
	ret.line=1
	ret.char=0
	ret.tzoom=dfltzoom
	ret.justif=jleft
  if xFlip==true then
    ret.xFLip=true
  else
    ret.xFLip=false
  end
	--ret.dragrelease=applysnap
	-- ret.justif=jright


-- DBG for test
--	ret.texture=texture
	
	return ret
end
