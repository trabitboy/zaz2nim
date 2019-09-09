
--if consumed returns true
local function click(b,mx,my)
	if mx >= b.x and mx<b.x+b.coords.w and my >= b.y and my<b.y+b.coords.h then
		print("click")
		b.cb()
		return true
	end
	return false
end


local function render(b)
	if renderdecos==true then
		
		love.graphics.draw(b.pic,b.quad,b.x,b.y)
	end

end


--TODO ppass coords and create quad here 
-- coords={ox oy w h } then we blit part of the pic
function createpicbutton(x,y,pic,callback,coords)
	ret={}
	ret.pic=pic
	ret.coords=coords
	ret.quad=love.graphics.newQuad(coords.x,coords.y,coords.w,coords.h,pic:getWidth(),pic:getHeight())
	ret.x=x
	ret.y=y
	-- ret.w=quad.w
	-- ret.h=quad.h
	ret.cb=callback
	ret.render=render
	ret.click=click
	return ret
end
