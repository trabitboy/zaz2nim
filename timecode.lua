local clockQuad = {x=64, y=64, w=64, h=64}
realCQuad=love.graphics.newQuad(clockQuad.x,clockQuad.y,clockQuad.w,clockQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


--utility
function loadTxtCodes()
--TODO load zazanim style tcs ( for interop )
local tcf=love.filesystem.getInfo(conf.prjfld.."timecodes.txt")
	if tcf ~= nil then
		for sTc  in love.filesystem.lines(conf.prjfld.."timecodes.txt")
		do
			addMsg(sTc)
			addMsg(string.byte(sTc,1,3))
			addMsg(string.sub(sTc,1,3))
			local frmNum=tonumber(string.sub(sTc,1,3))
			addMsg(string.sub(sTc,5,7))
			local frmTc=tonumber(string.sub(sTc,5,7))
			--TODO be careful zazanim has different indexes
			frames[frmNum].tc=frmTc
			
		end
	end
end

function saveTxtCodes()
--TODO save zzn txt codes for interop


end


function toTimeCode()
	drawFunc=timeCodeDraw
	updateFunc=timeCodeUpdate

end



function timeCodeDraw()
		-- //'frames"  row
		-- int maxcol;
		
		-- //should be define
		maxcol=(uiw-64) / ( 64 );
		
		-- int i,col,row;
		-- col=0;row=0;
		col=0
		row=0
		-- for(i=0;i<timecode;i++){
		for i=1,frames[currentIdx].tc 
		do
			love.graphics.draw(buttonsPic,realCQuad,col*64,row*64) 
			
		   -- clipRect.x = TOFF_TCODE_X;
		   -- clipRect.y = TOFF_TCODE_Y;
		   -- clipRect.w = 64;
		   -- clipRect.h = 64;
			-- dispRect.x=TC_CLICK_UL_X+(BTN_BASE_W/2)*col;
			-- dispRect.y=TC_CLICK_UL_Y+(BTN_BASE_W/2)*row;
			-- dispRect.w=BTN_BASE_W/2;
			-- dispRect.h=BTN_BASE_W/2;

			-- SDL_RenderCopy(renderer,
			-- buttons, 
			-- &clipRect,
			-- &dispRect
			-- );
				
			-- col++;
			col=col+1
			-- //if we are further than max col,
			-- // we need to go below
			if col>=(maxcol-1)then
				col=0
				row=row+1
			end
			
		-- }
		end
end

function timeCodeUpdate()
		-- if(polled.newpress){
			-- if( 
				-- polled.x < (TC_CANCEL_UL_X+BTN_BASE_W)
				-- && polled.x > TC_CANCEL_UL_X
				-- &&	polled.y < (TC_CANCEL_UL_Y+BTN_BASE_W)
				-- && polled.y > TC_CANCEL_UL_Y
			   
			-- ){
				-- project[nb_edit_slot].timecode=timecode;
				-- //DEBUG going bac to settings for the mo
				-- mode=settings;
				-- return;
			-- }else
			-- if( 
				-- polled.x < (TC_MULTIPLE_UL_X+BTN_BASE_W)
				-- && polled.x > TC_MULTIPLE_UL_X
				-- &&	polled.y < (TC_MULTIPLE_UL_Y+BTN_BASE_W)
				-- && polled.y > TC_MULTIPLE_UL_Y
			   
			-- ){
				-- int i;
				-- for( i=cb;i<=ce;i++){
					-- project[i].timecode=timecode;
				-- }
				-- //DEBUG going bac to settings for the mo
				-- mode=settings;
				-- return;
			-- // }else
			-- // if( 
				-- // polled.x < (TC_DEFAULT_UL_X+BTN_BASE_W)
				-- // && polled.x > TC_DEFAULT_UL_X
				-- // &&	polled.y < (TC_DEFAULT_UL_Y+BTN_BASE_W)
				-- // && polled.y > TC_DEFAULT_UL_Y			   
			-- // ){
				-- // //TODO put back default
			-- }else if(
				-- polled.x < (TC_CLICK_UL_X+TC_CLICK_W)
				-- && polled.x > TC_CLICK_UL_X
			-- ){
				-- //compute row and col of the click to set tc
				-- Uint16 tx=polled.x - TC_CLICK_UL_X;
				-- Uint16 ty=polled.y - TC_CLICK_UL_Y;
				-- Uint16 computedCol= tx / (BTN_BASE_W/2);
				-- Uint16 computedRow= ty / (BTN_BASE_W/2);
				-- Uint16 computedTC=computedCol+computedRow*maxcol;
				-- LOGD("computed click TC %d \n",computedTC);
				-- timecode=computedTC;
				-- //project[nb_edit_slot].timecode=computedTC;
			-- }
				
		-- }

end