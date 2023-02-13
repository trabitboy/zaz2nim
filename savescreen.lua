--default callback
local callback=toPaintMode

--we flag when frame index has been changed by suppression or insertion
flagShiftedFrames=function(afterIdx)
  for i=1,maxframe 
  do 
    frames[i].shifted=true
    print('frame '..i..' flagged as shifted')
  end
  
  
end

drawSaveScreen = function ()
 if justSaved>0 then
    if frames[justSaved].dirty == true then
      love.graphics.clear(0.0,0.0,1.0,1.0)
    elseif frames[justSaved].shifted == true then
    
      love.graphics.clear(0.0,1.0,0.0,1.0)
    
    else
      love.graphics.clear(1.0,1.0,1.0,1.0)
    end
    
    love.graphics.draw(frames[justSaved].pic)
    displayHoverMsg()
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


saveFrameFromTmpForFrame=function(newName,loadedFromName)
  loadedFromPathAndName= tmpProjFld..loadedFromName..'.png'
  targetPathAndName=conf.prjfld..newName..'.png'
  print('copying '.. loadedFromPathAndName.. ' to '..targetPathAndName)
--  local files = love.filesystem.getDirectoryItems(tmpProjFld)
--  for k, file in ipairs(files) do
--    print(k .. ". " .. file) --outputs something like "1. main.lua"
--  end
  tmp,err = love.filesystem.newFileData(loadedFromPathAndName)
  print('pot error')
  print(err)
  print(' src file data ')
  print(tmp)
  love.filesystem.write( targetPathAndName,tmp)

  
end


saveSoundFromTmpForFrame=function(f,name,spath,cleanLoaded)


		if f.sound~=nil then
		   --cleaning file that it represents on disk AT LAST LOAD/BEFORE SHIFT
		   --todo debug
      print('saving sound for '..name)
      
      --TODO what does clean loaded means ?
			if cleanLoaded==true then
		   --cleaning file that it represents on disk AT LAST LOAD/BEFORE SHIFT
				local toclean =conf.prjfld .. f.soundLoadedFrom
				print('about to clean '..toclean )
				love.filesystem.remove(toclean)
			end
		   --saving tmp file to new location
		   local tmp = love.filesystem.newFileData(tmpProjFld..f.soundLoadedFrom)
		   local newname = name..'.wav'
		   local tgtpath=spath..newname
		   print('writing sound '..tgtpath)
		   love.filesystem.write(tgtpath,tmp)		   

		end
		
end
  
--WIP in each project folder we save a 640x480 preview pic that has thumbnails of the first project frames
savePreviewPic= function()
  --probably I should look at how resource is released love.graphics.newCanvas()
  --TODO using a snapshot of story board screen looks ideal
  
  local curCvs=love.graphics.getCanvas()
  
  love.graphics.setCanvas(ui)
  love.graphics.clear(1.,1.,1.,1.)
  renderProjectPreviewToCurrentCvs()
  love.graphics.setCanvas()
  
 	local fromGpu=ui:newImageData()
  fromGpu:encode(
  "png",conf.prjfld.."preview1.png")
  love.graphics.setCanvas(curCvs)
  
end

updateSaveScreen = function ()

--files are saved here one by one

		if justSaved==maxframe then
			saveTxtCodes()
			saveBgRanges()
      saveColorFrames()
			saveBrushes()
      saveRepetitions()
			--clean extra frames on disk
			cleanMaxFrameReached()

      
			writeTemplateInfo()

      savePreviewPic()


      --we need to regenerate tmp folder with pngs and wavs at current indices
      --so that it works on next save
      --TODO DELETE TMP FOLDER DOESNT SEEM TO WORK ON LINUX

      removeOrCreateTmpDir()

      --save frames and waves in tmp
      for j=1,maxframe 
      do
        --preemptively we clean
        frames[j].soundLoadedFrom=nil
        frames[j].dirty=false
        frames[j].shifted=false --in case of shift of index, true
        
        currentName=string.format("%03d",j)
        currentPathAndName=conf.prjfld..currentName..".png"
        print("attempting load "..currentPathAndName)
        cur=love.filesystem.getInfo(currentPathAndName)
        local tmp = love.filesystem.newFileData(currentPathAndName)
        love.filesystem.write( tmpProjFld..currentName..".png",tmp)
        frames[j].loadedFrom=currentName --useful to move frame on insert or remove frames
    --this is a save flag ( we save only modified )

    --if file preexists load sound
        local wName=string.format("%03d",currentName)..".wav"
        local potsound=conf.prjfld..wName
        print('looking up pot sound '..potsound)
        local si=love.filesystem.getInfo(potsound)
        if si~=nil then
--          frameTable.sound=love.audio.newSource(potsound,'static')

          local tmp = love.filesystem.newFileData(potsound)
          love.filesystem.write( tmpProjFld..wName,tmp)

          frames[j].soundLoadedFrom=wName
          
          print('metadata updated, f '..j..' sound loaded from now '..frames[j].soundLoadedFrom)
          --this data will be used to move the file properly on save

          print(' tmpwav written ')
        end

        if f.sound~=nil and f.soundLoadedFrom==nil then
          print ('ERROR metadata missing for sound in memory '..j)
          
        end

      end


      --we save a time stamp, so that if you work on multiple machines its easier to see
      -- which project is more recent
      tstamp=os.date()
      love.filesystem.write(conf.prjfld..'lastsave.txt',tstamp)
      
			addMsg('after save')
--			toPaintMode()
      callback()
		   -- for critical save that calls function directly
		   return 'finished'
		end

		--if so far we still have a frame to save
		local curSaveIdx=justSaved+1
    
		f=frames[curSaveIdx]
		name=string.format("%03d",curSaveIdx)
    
    if f.dirty ==true then
		f.data:encode("png",conf.prjfld..name..".png")
		  print(' frame '..curSaveIdx..' dirty saved ')
    elseif f.shifted==true then
      print( ' frame '..curSaveIdx .. ' is a shift from '..f.loadedFrom )
      saveFrameFromTmpForFrame(name,f.loadedFrom)
      
    end



		--if a sound is attached, we need to delete previous wav and rewrite it at correct index
    --we don t need to clean as we regenerate whole tmp dir 
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


initSaveScreen = function(cb)

	addMsg('before save')
  setHoverMsg('saving project')
  callback=cb


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

initSaveScreenFromPaintMode =function ()
  initSaveScreen(toPaintMode)
  
end

toSwitchProjectThroughSave=function()
  initSaveScreen(toSwitchProject)
  
  
end