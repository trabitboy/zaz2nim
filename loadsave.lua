


function saveFrames()
	for i,f in ipairs(frames)
	do
		name=string.format("%03d",i)
		f.data:encode("png",name..".png")

	end

end