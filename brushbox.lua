





-- the box which has the focus (only one ) for text andbutton interactions
boxfocus=nil

hdlw=32
hdlh=32

local dfltzoom =1.0






local function drag(b,tx,ty,dx,dy)
	if b.mode=="drag" then
		b.x=b.x+dx
		b.y=b.y+dy
	end
	if b.mode=="resize" then

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
		brushSelQuad=   love.graphics.newQuad(brushSelection.x,brushSelection.y,brushSelection.w,brushSelection.h,b.texture:getDimensions())
		   
		   love.graphics.draw(b.texture,brushSelQuad,b.x,b.y)
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
--the selection is shown, then scaled scaled
function bbsettexture(bb,tex)
	 bb.texture=tex 
end



--brush box represents a bitmap, so when resizing we maintain its
-- zoom ratio
function createbrushbox(x,y,w,h,keepratio)
	ret={}
	
	ret.type='tbox' --used to identify targets for snap
	
--	wcount=wcount+1
	
--	ret.id=wcount
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

	--ret.dragrelease=applysnap
	-- ret.justif=jright

	ret.texture=texture
	
	return ret
end
