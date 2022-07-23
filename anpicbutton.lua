
--if consumed returns true
local function click(b,mx,my)
	if mx >= b.x and mx<b.x+b.coords.w*b.zoom and my >= b.y and my<b.y+b.coords.h*b.zoom then
		print("click")
    b.clickZoom=1.5
		b.cb()
		return true
	end
	return false
end


local function render(b)
	if renderdecos==true then
		if b.clickZoom>1. then 
      b.clickZoom=b.clickZoom-0.1
    elseif b.clickZoom<1. then
      b.clickZoom=1.
    end
    
    xCorrection=(1.-b.clickZoom)*b.zoom*64
    
		love.graphics.draw(b.pic,b.quad,b.x+xCorrection,b.y,0,b.zoom*b.clickZoom,b.zoom*b.clickZoom)
  
    --for debug
    love.graphics.setColor(0.,0.,0.)
    love.graphics.rectangle('line',b.x+xCorrection,b.y,b.zoom*64*b.clickZoom,b.zoom*64*b.clickZoom)
    love.graphics.setColor(1.,1.,1.)
  
	end

end


--TODO ppass coords and create quad here 
-- coords={ox oy w h } then we blit part of the pic
function createanpicbutton(x,y,pic,callback,coords,zoom)
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

	if zoom~=nil then
	   ret.zoom=zoom
	else
	   ret.zoom=1
	end

  ret.clickZoom=1.

	return ret
end
