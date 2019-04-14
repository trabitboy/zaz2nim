npress=false
npx=nil
npy=nil	
	
	
love.mousepressed = function(x, y, button)
	print("new touch "..x.." "..y)
	npress=true
	npx=x/scrsx
	npy=y/scrsy
	print("mousepressed scaled "..npx.." "..npy)
	
	-- paint(npx,npy)
	
end

love.mousemoved=function( x, y, dx, dy, istouch )
	if registerdrag~=nil then
			registerdrag.drag(registerdrag,x/scrsx,y/scrsy,dx/scrsx,dy/scrsy)
	end
end

love.mousereleased = function(x, y, button)

	if registerdrag~=nil then
		if registerdrag.dragrelease then
			registerdrag.dragrelease(registerdrag)
		end
	end
	
	registerdrag=nil
end

love.wheelmoved = function(x, y)
end
