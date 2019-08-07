
--if consumed returns true
local function click(b,mx,my)
	if mx >= b.x and mx<b.x+b.w and my >= b.y and my<b.y+b.h then
		print("click")
		b.cb()
		return true
	end
	return false
end


local function render(b)
	if renderdecos==true then
		love.graphics.draw(b.pic.pic,b.x,b.y)
	end

end

function createpicbutton(x,y,picfile,callback)
	ret={}
	ret.pic=loadfilter(picfile)
	ret.x=x
	ret.y=y
	ret.w=ret.pic.data:getWidth()
	ret.h=ret.pic.data:getHeight()
	ret.cb=callback
	ret.render=render
	ret.click=click
	return ret
end
