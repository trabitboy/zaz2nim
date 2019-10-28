
nb_flick=10

local dragx=nil
local leftmode=nil
--ui scaled
function dragFlick(me,x,y,dx,dy)
	addMsg('drag flick called')
	-- dragx=x

end

function tst()
	addMsg('tst')
end


function toFlick(bleft)
	leftmode=bleft
	drawFunc=drawFlick
	updateFunc=updateFlick
	dragx=0
	-- registerdrag={drag=dragFlick}
	registerdrag={drag=tst}
end

function toLeftFlick()
	toFlick(true)
end


local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
	
	love.graphics.draw(frames[currentIdx].pic)
	
	
	
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


-- c version to port

		-- // //WIP we determine offset from the right 
		-- int offset;
		-- int flx=polled.x;
	-- flx=np.x

	-- flx=
	
	
	-- if leftmode == true then
		-- offset=dragx
		
	-- end
	-- addMsg('dragx '..dragx)
	-- slotwidth=uiw/nb_flick
	-- nbslot=offset/slotwidth
	-- addMsg('nbslot '..nbslot)
	
		-- if(leftMode ){
			-- offset=flx;
		-- }else{
			-- offset = SCRWDTH-flx;
		-- }
		-- int slotwidth= SCRWDTH/NB_FLICK ;
		-- //screen represents NB_FLICK slots ( last to the right is current )
		-- int nbslot= offset/slotwidth;
	
		-- int tgt;
		
		-- if(leftMode){
			-- tgt= flick_nb+nbslot;
		-- }else{
			-- tgt= flick_nb-nbslot;
		-- }
		
		-- if( tgt<0){tgt=0;}
		-- if(tgt>(lfn-1)){tgt=lfn-1;}
		
		-- LOGD("flx %d offset %d nb slot %d  computed tgt %d\n",flx,offset,nbslot,tgt);
		-- // LOGD("computed tgt %d\n",tgt);

		-- //is it too slow to do it all the time ?
		-- setEditSlot(tgt);
		-- nb_edit_slot=tgt;

	--we need to track mouse up 

	
	-- cyclecount=cyclecount+1
	-- if cyclecount>cycles then
		-- cyclecount=0
		-- currentIdx=currentIdx+1
	-- end
	
	
	-- if currentIdx>=maxframe then
		-- currentIdx=1
		-- toPaintMode()
		-- return
	-- end


	
	-- if npress==true and npx<64 and npy<64 then
			-- toPaintMode()
	-- end
end