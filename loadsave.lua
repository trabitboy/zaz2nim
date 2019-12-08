--if the loaded frame is 
function templateFilter()
	
end


function loadFrames()
	-- files=love.filesystem.getDirectoryItems(prjfld)
	-- for i,f in ipairs(files)
	-- do
		-- suffix=f:sub(f:len()-3,f:len())
		-- print(f..' '..suffix)
		-- if suffix==".png" then
			-- table.insert(frames,loadfilter(prjfld..f))
		-- end
	-- end

	-- for i=1,3,1
	-- do
		-- name=string.format("%03d",i)
		-- table.insert(frames,loadfilter(conf.prjfld..name..".png"))	
	-- end
	
end

function saveFrames()
	addMsg('before save')
	if dirtycvs==true then
		--we need to copy current frame from rtex cvs
		saveCanvasToFrame(currentIdx)
	end
	--dbg
	-- love.filesystem.createDirectory('tst')

	--we need to check if save folder structure exist ( if new project loaded from read only template )
	folders=mysplit(conf.prjfld,"/")
	local prefix=""
	for i,fld in ipairs(folders )
	do
		print(fld)
		print(prefix..fld)
		info=love.filesystem.getInfo(prefix..fld)
		print(info)
		if info == nil then
			love.filesystem.createDirectory(prefix..fld)
		end
		
		prefix=prefix..fld.."/" -- done here so that first exec doesn't prepend /
		addMsg(prefix)
	end

	for i,f in ipairs(frames)
	do
		name=string.format("%03d",i)
		f.data:encode("png",conf.prjfld..name..".png")
	end
	addMsg('after save')

end