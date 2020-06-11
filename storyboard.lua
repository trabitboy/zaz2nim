
--TODO store stamps by line ,
-- and render whole project


local widgets={}

local stamps={}

local boardWidth=math.floor(uiw*0.8)

local defaultStampW= math.floor( boardWidth/32 )

local defaultStampH= math.floor(defaultStampW*conf.cvsw/conf.cvsh)

local stampZoom= defaultStampW/conf.cvsw

--when the algorithm below 
function allocateStamp(x,frame,line)
	 stamp={}
	 stamp.x=x
--	 stamp.y=y
	 stamp.w=frame.tc*defaultStampW
	 stamp.h=defaultStampH
	 stamp.pic=frame.pic
	 table.insert(line,stamp)

end


--we build a representation of the stamps to be displayed,
--taking into account the width to fill,
--and the height of the screen
function maintainStamps()
	 stamps={}
	 --we start at line 0
	 --TODO handle width
	 --TODO start at current idx
	 local tx=0
--	 local ty=0
--	 y not relevant, we use line info

	 currentLine={}
	 lineNumber=1
	 stamps[lineNumber]=currentLine

	 for i=1,maxframe
	 do
		frame=frames[i]
		--TODO allocation code duplicated mmmm
		if tx+(defaultStampW*frame.tc)<boardWidth then
		   --we use the space 
		   		   
		   allocateStamp(tx,frame,currentLine)		   
		   tx=tx+defaultStampW*frame.tc
		else
--			ty=ty+defaultStampH
			tx=0
			lineNumber=lineNumber+1
			currentLine={}
			stamps[lineNumber]=currentLine

--			if ty>uih then return end

			--then we use the space
			allocateStamp(tx,frame,currentLine)		   
			tx=tx+defaultStampW*frame.tc

		end
	 end


end


function toStoryboard()
	 print('to story board ')
	 maintainStamps()

	 drawFunc=drawStoryboard
	updateFunc=updateStoryboard
end

local function renderStamps()
      local ly=0

      for i,l in ipairs(stamps)
      do

	for j,s in ipairs(l)
	do
      
		love.graphics.setColor(1.0,0.0,0.0,1.0)

		love.graphics.rectangle('line',s.x,ly*defaultStampH,s.w,s.h)

		love.graphics.setColor(1.0,1.0,1.0,1.0)

		love.graphics.draw(s.pic,s.x,ly*defaultStampH,0,stampZoom,stampZoom)
	end
	ly=ly+1

      end

end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)

	love.graphics.setColor(1.0,1.0,1.0,1.0)

--	love.graphics.draw(frames[2].pic)
--	love.graphics.draw(frames[2].pic,0,0,0,0.1,0.1)

	--not sure if stamps should be widgets,
--	as selection is across stamps
	renderStamps()

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