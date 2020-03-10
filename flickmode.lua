
nb_flick=10

local dragx=nil
local leftmode=nil
--ui scaled
function dragFlick(me,x,y,dx,dy)
	-- addMsg('drag flick called')
	dragx=x

end


function flickRelease()
-- for some reason this corrupts frame !!
-- seems to copy initial on target
--	 currentIdx=tgt
	 toPaintMode()

end


-- function tst()
	-- addMsg('tst')
-- end


function toFlick(bleft)
	leftmode=bleft
	drawFunc=drawFlick
	updateFunc=updateFlick
	dragx=0
	flickNb=currentIdx
	tgt=currentIdx
	registerdrag={drag=dragFlick,dragrelease=flickRelease}
	-- registerdrag={drag=tst}
end

function toLeftFlick()
	toFlick(true)
end

function toRightFlick()
	toFlick(false)
end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
	
	love.graphics.draw(frames[tgt].pic)
	
	
	
	msgToCvs()
	
	love.graphics.setCanvas()

end



function drawFlick()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function updateFlick()

-- mouse drag is redefinted, it gives us a coordinate


	
	
	if leftmode == true then
		offset=dragx
	else	
		offset=uiw-dragx
	end
	-- addMsg('dragx '..dragx)
	slotwidth=uiw/nb_flick
	nbslot=math.floor(offset/slotwidth)
	addMsg('nbslot '..nbslot)
	
		
	if leftmode ==true then
		tgt= flickNb+nbslot
	else
		tgt= flickNb-nbslot
	end
	
	if tgt<1 then tgt=1 end
	if tgt>maxframe then 
		tgt=maxframe
		addMsg('tgt = maxframe')
	end
		

end