
--this function is being refactored in load screen
-- right now it is blocking and we have no progress info
function loadFrames()

	maxframe=0
	--frames are 0 based for zazanim compatibility ( tcs, etc )
	local i = 0
	currentName=conf.prjfld..string.format("%03d",i)..".png"
	print("attempting load "..currentName)
	cur=love.filesystem.getInfo(currentName)
	if cur==nil then
		print('loading from template '..conf.template)
		cur=love.filesystem.getInfo(conf.template)
		print('tmpl ')
		print(cur)
		currentName=conf.template
	end
	
    while cur do
		frameTable =loadfilter(currentName)
		--please note we will add other metadatas in frameTable, such as time code and optional sound
		--we are here because cur is not nil
		frameTable.dirty=false
		--this is a save flag ( we save only modified )

		--TODO if file preexists load sound
		if cur~=nil then
		   local potsound=conf.prjfld..string.format("%03d",i)..".wav"
		   print('looking up pot sound '..potsound)
		   local si=love.filesystem.getInfo(potsound)
		   if si~=nil then
		      frameTable.sound=love.audio.newSource(potsound,'static')
		   end
		   print('sound loaded ')
		   print(frameTable.sound)
		end


		table.insert(frames,frameTable)
		maxframe=i
		i = i + 1
		currentName=conf.prjfld..string.format("%03d",i)..".png"
		print("attempting load "..currentName)
		cur=love.filesystem.getInfo(currentName)


		if i<4 and cur==nil then
			--TODO load template and put in cur
			cur=love.filesystem.getInfo(conf.template)
			currentName=conf.template
		end
    end

end


--WIP modal doesnt work because save is blocking and display is not updated
function saveFrames()
	addMsg('before save')


	print(' target save directory : '..love.filesystem.getSaveDirectory())



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
		print("checking existence of "..prefix..fld)
		info=love.filesystem.getInfo(prefix..fld)
		print(info)
		if info == nil then
			love.filesystem.createDirectory(prefix..fld)
		else
			print ('folder exists')
			
		end
		
		prefix=prefix..fld.."/" -- done here so that first exec doesn't prepend /
		addMsg(prefix)
	end

	for i,f in ipairs(frames)
	do
		--TODO we need to track insertion / moves/ offsets / creations too
		--if f.dirty==true then 
		   name=string.format("%03d",i)
		   f.data:encode("png",conf.prjfld..name..".png")
		   print(' frame '..i..' saved ')
		--else
		--   print('frame '..i..' untouched' )
		--end
	end
	saveTxtCodes()
	addMsg('after save')

end
