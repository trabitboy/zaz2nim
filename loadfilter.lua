--TODO change names, no need for filtering in zaz2nim

function loadfilter(fname)
	tofilter=love.image.newImageData( fname )

	

	print("loaded im dat format "..tofilter:getFormat())
	
	
	--in love 11 we can not get back image data from created pic
	return {pic = love.graphics.newImage(tofilter),data = tofilter,tc=1} -- we put sensible default time code
	
end