--parameterized to fill source layer or other layer
--cpu based impl

--we check floodability to treat later
local function floodability(fx,fy,sourcedata,toFillCol)
      local sr,sg,sb,sa = sourcedata:getPixel(fx,fy)
      if ( sr~=toFillCol.r or sg~=toFillCol.g or sb~=toFillCol.b)  then
	--should not be filled 
	return false
      end

      --should be filled
      return true
end




floodFill=function(fx,fy,paintingCol,sourceData,targetData)
	--TODO do treated piexels map
	--we have a boolean array of frame size that we navigate
	-- [y*cvsw+x]


	print('TODO flood fill '..fx..' '..fy..' with '..paintingCol.r..' '..paintingCol.g..' '..paintingCol.b )

	treatedPixels={}
	local j,i

	for j = 0,conf.cvsh
	do
		for i=0,conf.cvsw
		do
			treatedPixels[j*conf.cvsw+i]=false
		end
	end
	print('base treatment table is done')


	toTreatQueue=List.new()

	floodOrigin={x=fx,y=fy}

	List.pushRight(toTreatQueue,floodOrigin)

	while toTreatQueue.size>0
	do
		local point = List.popLeft(toTreatQueue)
		print('about to color '..point.x..' '..point.y)

		targetData:setPixel(point.x,point.y,paintingCol.r,paintingCol.g,paintingCol.b,1.0)
		treatedPixels[point.x+point.y*conf.cvsw]=true

		--TODO lets check if we can move in all 4 dirs
		if point.x>0 and treatedPixels[(point.x-1)+point.y*conf.cvsw]==false and floodability(point.x,point.y,sourceData,paintingCol)
		then
			
			List.pushRight(toTreatQueue,{x=point.x-1,y=point.y})
		end

	end



end