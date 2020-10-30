
--we maintain what frame is a bg for what
maintainBgRanges=function()
	mybg={
		--if a frame has a bg, it is stored here
		-- if frame doesn appear, no bg
		--f1=3,
		--f2=8
	}    

	currentBG=nil

	for i=1,maxframe
	do
		--is frame BG ?
		if frames[i].bg==true then
		   print('current bg becomes '..i)
		   currentBG=i
		end

		if currentBG~=nil then
		   local key='f'..i
		   mybg[key]=currentBG
		end

	end
end


drawLoadScreen = function ()
 love.graphics.clear(1.0,1.0,1.0,1.0)

 if maxframe>0 then
    love.graphics.draw(frames[maxframe].pic)
 end
end


updateLoadScreen = function ()


  currentName=string.format("%03d",curLoadAttempt)
	currentPathAndName=conf.prjfld..currentName..".png"
	print("attempting load "..currentPathAndName)
	cur=love.filesystem.getInfo(currentPathAndName)

	if curLoadAttempt<4 and cur==nil then
		currentPathAndName=conf.template
		cur=love.filesystem.getInfo(currentPathAndName)
		print('loading from template')
	end

	--at this point if cur == nil, we loaded everything,
	--we return
	if cur==nil then

	   maxFrameReached=maxframe

	   loadTxtCodes()

	   loadBgRanges()
      
     loadColorFrames()
      
     loadRepetitions()
     
	   maintainBgRanges()

	   loadBrushes()

	   initCanvases(1)
	   toPaintMode()
	   return
	end
  
  --warning: create tmp folder function part  is duplicated in save in non batch form
  -- (executed in one go)
	

	frameTable =loadfilter(currentPathAndName)
	--please note we will add other metadatas in frameTable, such as time code and optional sound
	--we are here because cur is not nil
  
  --unedited shifted frames will just be copied from tmp if not dirty ( faster on mobile )
  local tmp = love.filesystem.newFileData(currentPathAndName)
  love.filesystem.write( tmpProjFld..currentName,tmp)

  
  frameTable.dirty=false
  frameTable.shifted=false --in case of shift of index, true
  frameTable.loadedFrom=currentName --useful to move frame on insert or remove frames
	--this is a save flag ( we save only modified )

	--if file preexists load sound
	   local wName=string.format("%03d",curLoadAttempt)..".wav"
	   local potsound=conf.prjfld..wName
	   print('looking up pot sound '..potsound)
	   local si=love.filesystem.getInfo(potsound)
	   if si~=nil then
	      frameTable.sound=love.audio.newSource(potsound,'static')

	      local tmp = love.filesystem.newFileData(potsound)
	      love.filesystem.write( tmpProjFld..wName,tmp)

	      frameTable.soundLoadedFrom=wName
	      --this data will be used to move the file properly on save

	      print(' tmpwav written ')
	   end
	   print('sound loaded ')
	   print(frameTable.sound)


	table.insert(frames,frameTable)
	
	maxframe=maxframe+1
	curLoadAttempt = curLoadAttempt + 1

end

removeOrCreateTmpDir=function()
  tmpProjFsInfo=love.filesystem.getInfo(conf.prjfld..'tmpproj/')
	print('tmp proj fld ')
	print(tmpProjFsInfo)
	if tmpProjFsInfo then
	       print('fld exist we need to delete')
	       love.filesystem.remove(conf.prjfld..'tmpproj/')
	else
		--  highscores=defaulths()
		    print('tmp proj doesnt exist')
	 end

	 tmpProjFld=conf.prjfld..'tmpproj/'

	 love.filesystem.createDirectory(tmpProjFld)

  
end


initLoadScreen = function()
       maxframe=0
	--frames are 0 based for zazanim compatibility ( tcs, etc )
       curLoadAttempt=1


       --we need to init tmpfolder for wav
       --it is used so we can move files easily on save
       -- on some offset operations
       --( frames insertion, deletion ) some indexes might be lost otherwise

--  tmpProjFsInfo=love.filesystem.getInfo(conf.prjfld..'tmpproj/')
--	print('tmp proj fld ')
--	print(tmpProjFsInfo)
--	if tmpProjFsInfo then
--	       print('fld exist we need to delete')
--	       love.filesystem.remove(conf.prjfld..'tmpproj/')
--	else
--		--  highscores=defaulths()
--		    print('tmp proj doesnt exist')
--	 end

--	 tmpProjFld=conf.prjfld..'tmpproj/'

--	 love.filesystem.createDirectory(tmpProjFld)
  
      removeOrCreateTmpDir()


       drawFunc=drawLoadScreen
       updateFunc=updateLoadScreen
end
