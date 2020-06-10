
local widgets={}

local stamps={}

local boardWidth=math.floor(uiw*0.8)

local defaultStampW= math.floor( boardWidth/32 )

local defaultStampH= math.floor(defaultStampW*conf.cvsw/conf.cvsh)

--when the algorithm below 
function allocateStamp()


end


--we build a representation of the stamps to be displayed,
--taking into account the width to fill,
--and the height of the screen
function maintainStamps()
	 --we start at line 0
	 --TODO handle width
	 --TODO start at current idx
	 local tx=0
	 local ty=0

	 for i=1,maxframe
	 do

		--TODO allocation code duplicated mmmm
		if tx+(defaultStampW*frames[i].tc)<boardWidth then
		   --we use the space 
		   
		   

		else
			ty=ty+defaultStampH

			if ty>uih then return end

			--then we use the space

		end
	 end


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