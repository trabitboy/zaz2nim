



drawSaveScreen = function ()
 love.graphics.clear(1.0,1.0,1.0,1.0)

 if justSaved>0 then
    love.graphics.draw(frames[justSaved].pic)
 end
end

--by adding and deleting frames, we might have lowered the max number of frames since last save
cleanMaxFrameReached = function()
	for i=(maxframe+1),maxFrameReached
	do
		print('cleaning obsolete frame '..i)
		--TODO actually delete file
		name=string.format("%03d",i)
		local path=conf.prjfld..name..".png"
		love.filesystem.remove(path)
	end
end

--when a project is created by dflt,
-- this should be saved
writeTemplateInfo=function()
	local tmp="return '".. conf.key  .."' "
	love.filesystem.write(conf.prjfld.."template.lua",tmp)

end


saveSoundFromTmpForFrame=function(f,name,spath,cleanLoaded)


		if f.sound~=nil then
		   --cleaning loaded file
		   --todo debug
      print('saving sound for '..name)
			if cleanLoaded==true then
				local toclean =conf.prjfld .. f.soundloadedfrom
				print('about to clean '..toclean )
				love.filesystem.remove(toclean)
			end
		   --saving tmp file to new location
		   local tmp = love.filesystem.newFileData(tmpWavFld..f.soundLoadedFrom)
		   local newname = name..'.wav'
		   local tgtpath=spath..newname
		   print('writing sound '..tgtpath)
		   love.filesystem.write(tgtpath,tmp)		   

		end
		
end




updateSaveScreen = function ()

--files are saved here one by one

		if justSaved==maxframe then
			saveTxtCodes()
			saveBgRanges()
			saveBrushes()
			--clean extra frames on disk
			cleanMaxFrameReached()


			writeTemplateInfo()

			addMsg('after save')
			toPaintMode()
		   -- for critical save that calls function directly
		   return 'finished'
		end

		--if so far we still have a frame to save
		local curSaveIdx=justSaved+1
		local f=frames[curSaveIdx]
		name=string.format("%03d",curSaveIdx)
		f.data:encode("png",conf.prjfld..name..".png")
		   print(' frame '..curSaveIdx..' saved ')


		--if a sound is attached, we need to delete previous wav and rewrite it at correct index
		saveSoundFromTmpForFrame(f,name,conf.prjfld,true)
		
		
		-- if f.sound~=nil then
		   -- --cleaning loaded file
		   -- --todo debug
		   -- local toclean =conf.prjfld .. f.soundloadedfrom
		   -- print('about to clean '..toclean )
		   -- love.filesystem.remove(toclean)

		   -- --saving tmp file to new location
		   -- local tmp = love.filesystem.newfiledata(tmpwavfld..f.soundloadedfrom)
		   -- local newname = name..'.wav'
		   -- local tgtpath=conf.prjfld..newname
		   -- print('writing sound '..tgtpath)
		   -- love.filesystem.write(tgtpath,tmp)		   

		-- end


		--else
		--   print('frame '..i..' untouched' )
		--end

		justSaved=curSaveIdx

	


end


initSaveScreen = function()

	addMsg('before save')


	print(' target save directory : '..love.filesystem.getSaveDirectory())



	if dirtycvs==true then
		--we need to copy current frame from rtex cvs
		saveCanvasToFrame(currentIdx)
	end

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

       justSaved=0
       keyFunc=nil
       drawFunc=drawSaveScreen
       updateFunc=updateSaveScreen
end
