
local widgets={}

local stamps={}


--we build a representation of the stamps to be displayed,
--taking into account the width to fill,
--and the height of the screen
function maintainStamps()
	 --we start at line 0
	 --TODO

end


function toStoryboard()
	 print('to story board ')
	 drawFunc=drawStoryboard
	updateFunc=updateStoryboard
end



local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

	love.graphics.setColor(1.0,1.0,1.0,1.0)

--	love.graphics.draw(frames[2].pic)
	love.graphics.draw(frames[2].pic,0,0,0,0.1,0.1)

	renderWidgets(widgets)
		
	msgToCvs()
	
	love.graphics.setCanvas()
end



function drawStoryboard()
	-- love.graphics.draw(buttonsPic)
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function updateStoryboard()
	
	if npress==true then
	   print('storyboard click ')
	end
end