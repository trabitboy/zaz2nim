





-- the box which has the focus (only one ) for text andbutton interqctions
boxfocus=nil

hdlw=32
hdlh=32

dfltzoom =1.0





local function drag(b,dx,dy)
	if b.mode=="drag" then
		b.x=b.x+dx
		b.y=b.y+dy
	end
	if b.mode=="resize" then
		b.w=b.w+dx
		b.h=b.h+dy
	end
	
	
end

--if consumed returns true
local function click(b,mx,my)
	print("scan click of id "..b.id)


	if boxfocus==b then
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
		print("click detected on id "..b.id)
		--before taking focus let s check focus 
		if copywcb==true then
			if boxfocus~=nil then
				boxfocus.w=b.w
				maintainlpl(boxfocus)
				msg.postmsg(msg,"w copied")
				copywcb=nil
				return true
			end
		end
		
		boxfocus=b
		zoom.value=b.tzoom
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
		love.graphics.setLineWidth(3)
		love.graphics.rectangle("fill",b.x-hdlw,b.y-hdlh,hdlw,hdlh)
		love.graphics.rectangle("line",b.x,b.y,b.w,b.h)
		love.graphics.rectangle("fill",b.x+b.w,b.y+b.h,hdlw,hdlh)
		-- b.text.render(b.text,b.x,b.y)
		love.graphics.setColor(0.0,0.0,1.0,1.0)
		love.graphics.setLineWidth(1)
		love.graphics.line(0,b.y,cvsw,b.y)
		love.graphics.line(0,b.y+b.h,cvsw,b.y+b.h)
		love.graphics.line(b.x,0,b.x,cvsh)
		love.graphics.line(b.x+b.w,0,b.x+b.w,cvsh)
		--for justify center
		love.graphics.line(b.x+b.w/2,b.y,b.x+b.w/2,b.y+b.h)
	
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.print(b.id,b.x-hdlw,b.y-hdlh)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	

end




function createbrushbox(x,y,w,h)
	ret={}
	
	ret.type='tbox' --used to identify targets for snap
	
--	wcount=wcount+1
	
--	ret.id=wcount
	ret.x=x
	ret.y=y
	ret.w=w
	ret.h=h
	
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

	ret.dragrelease=applysnap
	-- ret.justif=jright
	
	
	return ret
end
