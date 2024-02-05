


npress=false

-- ui canvas coordinates system ( not screen coordinates )
npx=nil
npy=nil	
hoverx=0
hovery=0
  
  

function getTouchOnCanvas(brad)
  local xb=(npx-offsetcvs.x-brad*applicativezoom)/applicativezoom 
  local yb=(npy-offsetcvs.y-brad*applicativezoom)/applicativezoom 
  return xb,yb
end 

  
--to see if it helps in windowed mode--love.mouse.setGrabbed( true )

	
love.mousepressed = function(x, y, button)
	print("new touch "..x.." "..y)
	npress=true
	--we floor coords,integer screen coords
	--was posing pb with painting
	npx=math.floor(x/scrsx)
	npy=math.floor(y/scrsy)


	print("mousepressed scaled to ui canvas "..npx.." "..npy)
	
	-- paint(npx,npy)
	
end


love.mousemoved=function( x, y, dx, dy, istouch )
	local tx=(x/scrsx)
	local ty=(y/scrsy)
	local tdx=(dx/scrsx)
	local tdy=(dy/scrsy)

	--we maintain these to display brush
	hoverx=tx
	hovery=ty

	if registerdrag~=nil then
			addMsg('calling drag callback')
			registerdrag.drag(registerdrag,tx,ty,tdx,tdy)
	end
end

love.mousereleased = function(x, y, button)
	addMsg('mouse released')
	if registerdrag~=nil then
		if registerdrag.dragrelease then
			registerdrag.dragrelease(registerdrag)
		end
	end
	
	registerdrag=nil
end

love.wheelmoved = function(x, y)
end
