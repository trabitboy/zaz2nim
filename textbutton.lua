
local txtBtnBaseW=64

--if consumed returns true
local function click(b,mx,my)
	if mx >= b.x and mx<b.x+txtBtnBaseW*b.zoom and my >= b.y and my<b.y+txtBtnBaseW*b.zoom then
		print("click")
		b.cb(b.textAndKey.key)
		return true
	end
	return false
end


local function render(b)
	if renderdecos==true then
		
		--love.graphics.draw(b.pic,b.quad,b.x,b.y,0,b.zoom,b.zoom)
    love.graphics.setColor(0.,0.,0.,1.)
    love.graphics.rectangle('line',b.x,b.y,txtBtnBaseW*b.zoom,txtBtnBaseW*b.zoom)
    love.graphics.print(b.textAndKey.text,b.x+txtBtnBaseW,b.y+txtBtnBaseW/2,0,b.zoom,b.zoom)
    love.graphics.setColor(1.,1.,1.,1.)
    
	end

end


-- the text passed will be passed to the callback

function createTextButton(x,y,callback,textAndKey,zoom)
--textAndKey = {text='display',key=for_callback}

	ret={}
	ret.textAndKey=textAndKey
	ret.x=x
	ret.y=y

	ret.cb=callback
	ret.render=render
	ret.click=click

	if zoom~=nil then
	   ret.zoom=zoom
	else
	   ret.zoom=1
	end

	return ret
end
