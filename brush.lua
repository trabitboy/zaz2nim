--TODO faking for now
function createBrushID(d)
	mine=love.image.newImageData(d,d)
	for j=0,d-1,1 
	do
		for i=0,d-1,1
		do
			a=1.0
			if i<4 or i>d-4 or j<4 or j>d-4
			then
				a=0.5
			end
				
			mine:setPixel(i,j,1.0,0.0,0.0,a)
		
		end
	end
	
	return mine
end
