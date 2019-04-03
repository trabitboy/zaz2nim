
ck={}
ck.r=130
ck.g=130
ck.b=130

function loadfilter(fname)
	tofilter=love.image.newImageData( fname )

	-- lw=
	
	-- print
	

	print("loaded im dat format "..tofilter:getFormat())
	
	todisp=love.image.newImageData(
						tofilter:getWidth(),
						tofilter:getHeight())

	print("created im dat format "..tofilter:getFormat())
						
						
	for j=0,tofilter:getHeight()-1
	do
		for i=0,tofilter:getWidth()-1		
		do
			local r,g,b,a=tofilter:getPixel(i,j)
			-- print(r.." "..g.." "..b.." "..a)
			if r*255==ck.r and g*255==ck.g and b*255==ck.b then
				todisp:setPixel(i,j,0,0,0,0)
				-- print("found blank pixel")
			else
				-- print("not blanck pixel")
				todisp:setPixel(i,j,r,g,b,255)
			end
		end
	end
	
	--in love 11 we can not get back image data from created pic
	return {pic = love.graphics.newImage(todisp),data = todisp}
	
end