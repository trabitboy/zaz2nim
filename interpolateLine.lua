
function calculateTraj(x1,y1,x2,y2)
-- void calculateTraj(Blit * buf,Sint16 x1,Sint16 y1,Sint16 x2,Sint16 y2){

	ret={}

	--try to floor values, and to blit even if offset  <1
	-- this solves holes in painting when canvas is zoomed ( bigger window )
	x1=math.floor(x1)
	x2=math.floor(x2)
	y1=math.floor(y1)
	y2=math.floor(y2)


  --TODO trying to patch in a single dot blit 
  --(when you just patch the mouse)
  if x1==x2 and y1==y2 then
    
      blt={}
			blt.xbl = x2
			blt.ybl =y2
			table.insert(ret,blt)
      return ret
  end

	-- if( (x1==-1 && y1==-1)
		-- ||( INTERPOLATE == false )
	-- )  {
		-- //no interpolation needed
		-- //if x1 and y1 is -1, we just put last event
		-- buf[0].xbl=x2;
		-- buf[0].ybl=y2;

		-- // to see end of buffer
		-- buf[1].xbl=-1; 
		-- buf[1].ybl=-1; 
		-- return;
	-- }

	-- //otherwise, we have work todo
	if( (x1-x2)*(x1-x2) >= (y1-y2)*(y1-y2) ) then
		-- //x projection is longer
		-- //we will draw a number of dot corresponding to x proj

		local dx = x2-x1 --//can be negative

		local dy = y2-y1

		local absdx = math.abs(dx)
		-- //goint through the points to generate
		-- int i;
		for i=1,absdx do
			-- // Point * p = new Point();
			blt={}
			blt.xbl = x1 + i*(dx)/absdx -- //trick to keep sign
			blt.ybl =math.floor( y1 + (i/absdx)*dy )
			-- // pointsToDraw.push_back(p);
			table.insert(ret,blt)
		end
		-- //signalling last slot
		-- buf[absdx].xbl = -1;
		-- buf[absdx].ybl = -1;

	else
		-- //y projection is longer
		-- //we will draw a number of dots cor. to y proj
		local dx = x2-x1 --//can be negative

		local dy = y2-y1

		local absdy = math.abs(dy)
		-- //goint through the points to generate
		-- int i;
		for i=1,absdy do
			-- // Point * p = new Point();
			blt={}
			blt.ybl  = y1 + i*dy/absdy
			blt.xbl  =math.floor( x1 + (i/absdy)*dx )
			table.insert(ret,blt)
			-- // pointsToDraw.push_back(p);
		end
		-- //signalling last slot
		-- buf[absdy].xbl = -1;
		-- buf[absdy].ybl = -1;

	end
	
	return ret


end