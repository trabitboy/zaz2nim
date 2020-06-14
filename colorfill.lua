--parameterized to fill source layer or other layer
--cpu based impl


floodFill=function(x,y,sourceCol,sourceData,targetData)
	--TODO do treated piexels map
	--we have a boolean array of frame size that we navigate
	-- [y*cvsw+x]


	print('TODO flood fill '..x..' '..y..' with '..sourceCol.r..' '..sourceCol.g..' '..sourceCol.b )

	treatedPixels={}
	local j,i

	for j = 0,conf.cvsh
	do
		for i=0,conf.cvsw
		do
			treatedPixels[j*conf.cvsw+i]=false
		end
	end
end