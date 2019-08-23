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

--WIP create round brush , targetColor
function roundBrushWithAlpha( radius) 

	round=love.image.newImageData(radius*2,radius*2)


	for j=0,radius*2-1
	do
		local line=''
		for i=0,radius*2-1
		do
			-- // //
			-- // //       /|
			-- // //   c  / | b
			-- // //     /  |
			-- // //    -----
			-- // //       a
			-- // //  lower left is circle center,
			-- // // we want to calculate c^2
			-- // //            x c  - x p
			-- // // a^2 = ( radius - i) ^2
			-- // // b^2 = ( radius - j) ^2
			-- // // c^2 = a^2 + c^2

			-- looks wrong but seems to work courtesy of the square
			local squareDistToCtr = (radius - i) * (radius - i) + (radius - j)* (radius - j)
			local squareRadius = radius * radius;
			if squareDistToCtr < squareRadius then
				--TODO first debug using prints and line breaks
				-- print("x")
				line=line.."x"
				-- *((Uint32 *) toCompose->pixels + j * toCompose->pitch / 4 + i)
						-- = color;
				round:setPixel(i,j,1.0,0.0,0.0,1.0)
						
			else
				-- print("_")
				line=line.."_"
				round:setPixel(i,j,0.0,0.0,0.0,0.0)
				--TODO first debug using prints and line breaks
			-- } else {
				-- *((Uint32 *) toCompose->pixels + j * toCompose->pitch / 4 + i)
						-- = transp;
			-- }
			end
		end
		print(line)
		-- print("\n")
-- //			printf(" %x ;", *((Uint32 *) toCompose->pixels + j
-- //					* toCompose->pitch / 4 + i));
	end
		-- }
-- //		printf("\n");

	

	return round

end