--TODO faking for now
function createBrushID(d)
	mine=love.image.newImageData(d,d)
	for j=0,d-1,1 
	do
		for i=0,d-1,1
		do
			mine:setPixel(i,j,1.0,1.0,1.0,1.0)
		
		end
	end
	
	return mine
end
