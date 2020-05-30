--TODO change names, no need for filtering in zaz2nim

function loadfilter(fname)
	tofilter=love.image.newImageData( fname )

	

	print("loaded im dat format "..tofilter:getFormat())
	
	-- todisp=love.image.newImageData(
						-- tofilter:getWidth(),
						-- tofilter:getHeight())

	-- print("created im dat format "..tofilter:getFormat())
						
						
	-- for j=0,tofilter:getHeight()-1
	-- do
		-- for i=0,tofilter:getWidth()-1		
		-- do
			-- local r,g,b,a=tofilter:getPixel(i,j)
			-- todisp:setPixel(i,j,r,g,b,a)
		-- end
	-- end
	
	--in love 11 we can not get back image data from created pic
	return {pic = love.graphics.newImage(tofilter),data = tofilter,tc=1} -- we put sensible default time code
	
end