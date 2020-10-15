
--if consumed returns true
local function click(b,mx,my)
  for i=1,5
  do
    if mx >= b.x and mx<b.x+64*b.zoom and my >= b.y+(i-1)*64*b.zoom and my<b.y+(i)*64*b.zoom then
      print("click")
  --		b.cb()
  
      if b.store==true then
        --see brush preset (keycode hack)
        tmpSlot=i+5
        storeInSlot('f'..tmpSlot)
        b.store=false
        saveBrushes()
      else
  
        restoreSlot('f'..i)
      end
      
      return true
    end
    
  end
  
  if mx >= b.x+64*b.zoom and mx<b.x+64*2*b.zoom and my >= b.y and my<b.y+64*b.zoom then
    print('store mode')
    b.store=true
    return true
  end
  
  
	return false
end


local function render(b)
	if renderdecos==true then
    
    for i=1,5
    do
      love.graphics.setColor(0.,0.,0.,1.)
  --		love.graphics.draw(b.pic,b.quad,b.x,b.y,0,b.zoom,b.zoom)
      love.graphics.rectangle('line',b.x,b.y+64*b.zoom*(i-1),64*b.zoom,64*b.zoom)
      love.graphics.setColor(1.,1.,1.,1.)
      if brushTexes['f'..i]~=nil then
        love.graphics.draw(brushTexes['f'..i],b.x,b.y+64*b.zoom*(i-1))
        
      end
      love.graphics.setColor(0.,0.,0.,1.)
      love.graphics.rectangle('line',b.x+64*b.zoom,b.y,64*b.zoom,64*b.zoom)
      love.graphics.setColor(1.,1.,1.,1.)
      
    end
    
	end

end


--TODO ppass coords and create quad here 
-- coords={ox oy w h } then we blit part of the pic
function createbrushpicker(x,y,zoom)
	ret={}
	ret.pic=pic
--	ret.coords=coords
	ret.x=x
	ret.y=y
	-- ret.w=quad.w
	-- ret.h=quad.h
	ret.render=render
	ret.click=click

	if zoom~=nil then
	   ret.zoom=zoom
	else
	   ret.zoom=1
	end
  
  --in store mode, click on a square to store the brush
  ret.store=false
  
	return ret
end
