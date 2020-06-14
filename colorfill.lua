--TODO color fill, works on some areas of screen, not on some other?
--maybe test on blank project ?



--parameterized to fill source layer or other layer
--cpu based impl

--we check floodability to treat later
-- we only fill target pixel is it has the fillColl
--( we only fill areas of same color )
local function floodability(fx,fy,sourcedata,toFillColl)

-- TODO big algorithm mistake
-- to fill coll is the picked color to fill, we fill only if new pixel is equal to picked col


      print('floodability for '..fx..' '..fy)
      local sr,sg,sb,sa = sourcedata:getPixel(fx,fy)
      print('tgt color r g b '..sr..' '..sg..' '..sb)
     print('fill color r g b '..toFillColl.r..' '..toFillColl.g..' '..toFillColl.b)


      if ( sr==toFillColl.r and sg==toFillColl.g and sb==toFillColl.b)  then
	--should be filled
	print('floodability true')
	return true
      end

      --should be not filled
	print('floodability false')
      return false
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

	--we fill this color, and this color only
	local fr,fg,fb,fa = sourceData:getPixel(fx,fy)

	local toFillCol = {}
	toFillCol.r=fr
	toFillCol.g=fg
	toFillCol.b=fb


	List.pushRight(toTreatQueue,floodOrigin)

	while toTreatQueue.size>0
	do
		local point = List.popLeft(toTreatQueue)
		print('about to color '..point.x..' '..point.y..' with r '..paintingCol.r..' ' ..paintingCol.g..' b '..paintingCol.g)

		targetData:setPixel(point.x,point.y,paintingCol.r,paintingCol.g,paintingCol.b,1.0)
		treatedPixels[point.x+point.y*conf.cvsw]=true

		-- lets check if we can move in all 4 dirs
		-- left
		--TODO fix , works with incorretct x, DUNNO with x-1
		print('checking left pixel x '..(point.x-1) ..'y  '..point.y)
		if (point.x-1)>=0 and treatedPixels[(point.x-1)+point.y*conf.cvsw]==false and floodability((point.x-1),point.y,sourceData,toFillCol)
		then
			print('left pixel treatable ')
			List.pushRight(toTreatQueue,{x=point.x-1,y=point.y})
		else
			print('left pixel NOT treatable ')
		
		end


		--right
--		if point.x<(conf.cvsw) and treatedPixels[(point.x+1)+point.y*conf.cvsw]==false and floodability((point.x+1),point.y,sourceData,toFillCol)
--		then
			
--			List.pushRight(toTreatQueue,{x=point.x+1,y=point.y})
--		end

		



	end



end