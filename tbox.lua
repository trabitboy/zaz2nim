

snapmargin=64

--justification
jleft='l'
jright='r'
jcenter='c'

registerdrag=nil


-- the box which has the focus (only one ) for text andbutton interqctions
boxfocus=nil

hdlw=32
hdlh=32

--for text
dfltzoom =0.3

local function applysnap(b)
	if b.snap then
		if b.snap.x then 
			b.x=b.snap.x
		else
			--left and right snap mutually exclusive
			if b.snap.right then
				b.x=b.snap.right-b.w
			
			end
		end
	
		if b.snap.y then 
			b.y=b.snap.y
		else
			--left and right snap mutually exclusive
			if b.snap.down then
				b.y=b.snap.down-b.h
			
			end
		end
	end
end


local function checkforsnap(b,w)
	local pot=false
	ret={}
	if b.x < w.x+snapmargin and b.x>w.x-snapmargin and b.x~=w.x then
		pot=true
		ret.x=w.x
	elseif b.x+b.w < w.x+w.w+snapmargin and b.x+b.w > w.x+w.w-snapmargin and b.x+b.w~=w.x+w.w then
		pot=true
		ret.right=w.x+w.w
	end


	if b.y < w.y+snapmargin and b.y>w.y-snapmargin and b.y~=w.y then
		pot=true
		ret.y=w.y
	elseif b.y+b.h < w.y+w.h+snapmargin and b.y+b.h > w.y+w.h-snapmargin and b.x+b.w~=w.y+w.h then
		pot=true
		ret.down=w.y+w.h
	end


	if pot==true then
		b.snap=ret
		return true
	else
		b.snap=nil
	end
end

-- each time we resize or move we check if there is a snap possibility within
-- margin , when mouse released, we use it if not nil
-- TODO if equals = already snapped, skip detected snap (false positive)
local function detectsnap(b)
	for i,w in ipairs(widgets)
	do
		if w~=b and w.type=='tbox' then
			found=checkforsnap(b,w)
			if found==true then
				break
			end
		end
	
	end
	
end

local function drag(b,dx,dy)
	if b.mode=="drag" then
		b.x=b.x+dx
		b.y=b.y+dy
	end
	if b.mode=="resize" then
		b.w=b.w+dx
		b.h=b.h+dy
		maintainlpl(b)
	end
	
	detectsnap(b)
	
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

local function addtext(b,txt)
	b.buffer[b.line]=b.buffer[b.line]:sub(1,b.char)..txt..b.buffer[b.line]:sub(b.char+1)
	-- b.char=b.char+string.len(txt)
	b.char=b.char+1
		print("char "..b.char)
	-- b.char=string.len(b.buffer[b.line])
end

local function editkey(b,key)
	if key=='return' then
	
		--TODO 
		--split current buffer in 2 !
		
		local cur = b.buffer[b.line]
		first=cur:sub(1,b.char)
		second=cur:sub(b.char+1)
		b.buffer[b.line]=first
		table.insert(b.buffer,b.line+1,second)
		
		-- print('ed k')
		-- table.insert(b.buffer,"")
		b.line=b.line+1
		b.char=0
		print("char "..b.char)
	end
	if key=='backspace' then
	
		if b.buffer[b.line]:len()==1 then 
			b.buffer[b.line]=""
			b.char=1
		elseif b.buffer[b.line]:len()==0 then
			table.remove(b.buffer,b.line)
			b.line=b.line-1
		elseif b.line ==1 and b.char==0 then
			--do nothing 
			return
		elseif b.char==0 then -- begin of line, we need to merge buffer with previous
			b.buffer[b.line-1]=b.buffer[b.line-1]..b.buffer[b.line]
			table.remove(b.buffer,b.line)
			b.line=b.line-1
			
		else
			-- b.buffer[b.line]=b.buffer[b.line]:sub(1, -2)
			print("before "..b.buffer[b.line])
			print("removing "..b.buffer[b.line]:sub(b.char,b.char))
			nbeg=b.buffer[b.line]:sub(1,b.char-1)
			print("nbeg "..nbeg)
			nend=b.buffer[b.line]:sub(b.char+1)
			print("nend "..nend)
			b.buffer[b.line]=nbeg..nend
			print("after "..b.buffer[b.line])
			b.char=b.char-1
		end
	end
	if key=='left' then
		if b.char>0 then
			b.char=b.char-1
		print("char "..b.char)
		msg.postmsg(msg,"char "..b.char)
		
		end
	end
	if key=='right' then
		if b.char<string.len(b.buffer[b.line]) then
			b.char=b.char+1
			msg.postmsg(msg,"char "..b.char)
		end
	end
	if key=='up' then
		print ("line before "..b.line)

		if b.line>1 then
			b.line=b.line-1
			print ("line after "..b.line)
			
			if b.char> string.len(b.buffer[b.line]) then
				--end of line
				b.char=string.len(b.buffer[b.line]) 
			end
		end

	end
	if key=='down' then
		print ("line before "..b.line)
		if b.line<tbllngth(b.buffer) then
			b.line=b.line+1
			print ("line after "..b.line)
			
			if b.char> string.len(b.buffer[b.line]) then
				--end of line
				b.char=string.len(b.buffer[b.line]) 
			end
		end

	end
	
end

-- function removeLastChar (string)
  -- return string:sub(1, -2)
-- end




-- ONLY FROM LEFT
local function writeseg(seg,b,x,linetotal)
	--there is an offset since we only want to draw "rtw"
	-- local xof = (tw-rtw/2)

	
	for i = 1, #(seg.val) do
		
		local c = seg.val:sub(i,i)
		if renderdecos==true then
			--box of real img data
			love.graphics.setColor(0.0,1.0,0.0,1.0)
			
			love.graphics.rectangle("line",b.x+x,b.y+y,b.tzoom*tw,b.tzoom*th)

			--box that we consider 'real'
			love.graphics.setColor(1.0,0.0,0.0,1.0)
			love.graphics.rectangle("line",b.x+x+((tw-rtw)*b.tzoom),b.y+y,b.tzoom*(tw-rtw),b.tzoom*th)

			
			love.graphics.setColor(1.0,1.0,1.0,1.0)
		end
		
		
		if typo[c]~=nil then
			love.graphics.draw(typo[c].pic,b.x+x,b.y+y,0,b.tzoom,b.tzoom)
		elseif c==' ' then
			
		else
			love.graphics.draw(typo['unknown'].pic,b.x+x,b.y+y,0,b.tzoom,b.tzoom)			
		end
		-- draw a cursor like square
		if curline==b.line and linetotal==b.char and renderdecos==true then
			love.graphics.setColor(1.0,1.0,1.0,0.2)
			love.graphics.rectangle("fill",b.x+x+(tw-rtw)*b.tzoom/2,b.y+y,rtw*b.tzoom,th*b.tzoom)
			love.graphics.setColor(1.0,1.0,1.0,1.0)
		end

		x=x+rtw*b.tzoom
		
		linetotal=linetotal+1

		
	end
	return x,linetotal
end

--used for justif
function getrllength(b,rl)
	local ret=0

	for i,seg in ipairs(rl)
	do
		ret=ret+#(seg.val)
	end
	
	
	ret=ret*rtw*b.tzoom
	
	return ret
end


local function justifiedtextrender(b)
	y=0
	curline=0
	for i,l in ipairs(b.buffer)
	do
		curline=curline+1
		--total of already written line on buffer line
		local linetotal=0

		--we get real lines
		local rls=simplecprlfl(b.lpl,l)
		
		if tbllngth(rls)==0 then
			x=0
			
			
			if renderdecos==true then
				--we still need to blit cursor and active line ( this is an empty line )
				love.graphics.polygon('fill',b.x+x,b.y+y+th*b.tzoom, b.x+x+rtw*b.tzoom,b.y+y+th*b.tzoom*0.75,b.x+x+rtw*b.tzoom,b.y+y+th*b.tzoom)
				if curline == b.line then
					love.graphics.line(b.x,b.y+y+th*b.tzoom,b.x+b.w,b.y+y+th*b.tzoom)
				end
				
				if curline==b.line then --edge case, we are on line begin
					love.graphics.setColor(1.0,1.0,1.0,0.2)
					love.graphics.rectangle("fill",b.x+x,b.y+y,rtw*b.tzoom,th*b.tzoom)
					love.graphics.setColor(1.0,1.0,1.0,1.0)
				end
			end
			
			--even if line empty of rls, we need to go down
			y=y+th*b.tzoom
			
			
		end
		
		
		for j,rl in ipairs(rls)
		do
			--draw a line under current line
			if curline == b.line and renderdecos==true then
				love.graphics.line(b.x,b.y+y+th*b.tzoom,b.x+b.w,b.y+y+th*b.tzoom)
			end
			
			x=0

			
			-- TODO calculation incorrect for more than one seg ?
			--TODO for justify center calculate a different x begin
			if (b.justif==jcenter)then
				x=b.w/2-getrllength(b,rl)/2
			end
			
			-- TODO calculation incorrect for more than one seg ?
			--TODO for justify right calculate x begin in offset from right border
			if (b.justif==jright)then
				x=b.w - getrllength(b,rl)
			end
	
			--we adjust first pos for real blit
				--we need to start offset x to remove 'blank' on left of first pic
			x=x-((tw-rtw)/2)*b.tzoom

	
			for k,seg in ipairs(rl)
			do
				x,linetotal=writeseg(seg,b,x,linetotal)

			end

			
			if renderdecos==true then
				if j==tbllngth(rls) then
					--draw marker on real carriage return, all seg have been drawn
					-- love.graphics.line(b.x+x+tw*b.tzoom,b.y+y,b.x+x+tw*b.tzoom,b.y+y+th*b.tzoom)
					x=x+(tw-rtw)/2
					love.graphics.polygon('fill',b.x+x,b.y+y+th*b.tzoom, b.x+x+rtw*b.tzoom,b.y+y+th*b.tzoom*0.75,b.x+x+rtw*b.tzoom,b.y+y+th*b.tzoom)
					
					
					--edge case : need also to display cursor here (out of any seg)
					if curline==b.line and linetotal==b.char then
						love.graphics.setColor(1.0,1.0,1.0,0.2)
						love.graphics.rectangle("fill",b.x+x,b.y+y,rtw*b.tzoom,th*b.tzoom)
						love.graphics.setColor(1.0,1.0,1.0,1.0)
					end
					
				end
			
			end
			
			--real line finished ! automatic cr
			x=0
			-- y=y+th*b.tzoom
			y=y+th*b.tzoom
				
		end

		
		
	end

end


local function simpletextrender(b)

	y=0
	curline=1
	for  i,l in ipairs(b.buffer)
	do
		x=0
	
		--draw a line under current line
		if curline == b.line then
			love.graphics.line(b.x,b.y+y+th*b.tzoom,b.x+b.w,b.y+y+th*b.tzoom)
		end
	
		for i = 1, #l do
		
		
			--TODO justification calculation : what is the line width,
			--how many words do fit
			--return segments of word {word} and render them
		
			local c = l:sub(i,i)
			-- do something with c

			--draw a cursor like line
			if curline==b.line and i==b.char then
				love.graphics.line(b.x+x+tw*b.tzoom,b.y+y,b.x+x+tw*b.tzoom,b.y+y+th*b.tzoom)
			end

			if typo[c]~=nil then
				love.graphics.draw(typo[c].pic,b.x+x,b.y+y,0,b.tzoom,b.tzoom)
			elseif c==' ' then
				
			else
				love.graphics.draw(typo['unknown'].pic,b.x+x,b.y+y,0,b.tzoom,b.tzoom)			
			end

			--draw marker on real carriage return
			if i==string.len(l) then			
				love.graphics.line(b.x+x+tw*b.tzoom,b.y+y,b.x+x+tw*b.tzoom,b.y+y+th*b.tzoom)
			end

			-- prepare coords for next char in line
			x=x+rtw*b.tzoom
			-- if x>(b.w-(tw/2)*b.tzoom) then
			if x>b.w-((tw/2)*b.tzoom) then
				x=0
				-- y=y+th*b.tzoom
				y=y+th*b.tzoom
			end
	
			
			
		end
		y=y+th*b.tzoom
		curline=curline+1
	
	
		-- love.graphics.print(l,b.x,b.y+b.fh*i)
		-- love.graphics.print(x,y,l)
	end

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
	
		--render potential snap
		if b.snap then
			love.graphics.setLineWidth(4)
			if b.snap.x then
				love.graphics.setColor(0.0,1.0,1.0,1.0)
				love.graphics.line(b.snap.x,0,b.snap.x,cvsh)				
			end
			if b.snap.right then
				love.graphics.setColor(0.0,1.0,1.0,1.0)
				love.graphics.line(b.snap.right,0,b.snap.right,cvsh)				
			end
			if b.snap.y then
				love.graphics.setColor(0.0,1.0,1.0,1.0)
				love.graphics.line(0,b.snap.y,cvsw,b.snap.y)				
			end
			if b.snap.down then
				love.graphics.setColor(0.0,1.0,1.0,1.0)
				love.graphics.line(0,b.snap.down,cvsw,b.snap.down)				
			end
			love.graphics.setLineWidth(1)
			
		end
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.print(b.id,b.x-hdlw,b.y-hdlh)
	end
	
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	-- simpletextrender(b)
	justifiedtextrender(b)
	

end


--after modifying zoom
-- prerequisite to justify text
function maintainlpl(b)
	--calulate char per line
	b.lpl=math.floor(b.w/(rtw*b.tzoom))
	print("lpl "..b.lpl)
end


function createtbox(x,y,w,h)
	ret={}
	
	ret.type='tbox' --used to identify targets for snap
	
	wcount=wcount+1
	
	ret.id=wcount
	ret.x=x
	ret.y=y
	ret.w=w
	ret.h=h
	ret.fh=16-- seems unused ?
	
	ret.render=tbrender
	ret.click=click
	ret.drag=drag
	
	ret.buffer={}	
	table.insert(ret.buffer,"")
	ret.addtext=addtext
	ret.editkey=editkey
	--current line
	ret.line=1
	ret.char=0
	ret.tzoom=dfltzoom
	ret.justif=jleft

	ret.snap=nil
	ret.dragrelease=applysnap
	-- ret.justif=jright
	maintainlpl(ret)
	
	
	return ret
end
