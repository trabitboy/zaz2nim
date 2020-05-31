
--we maintain what frame is a bg for what
maintainBgRanges=function()
	mybg={
		--if a frame has a bg, it is stored here
		-- if frame doesn appear, no bg
		--f1=3,
		--f2=8
	}    

end


drawLoadScreen = function ()
 love.graphics.clear(1.0,1.0,1.0,1.0)

 if maxframe>0 then
    love.graphics.draw(frames[maxframe].pic)
 end
end


updateLoadScreen = function ()



	currentName=conf.prjfld..string.format("%03d",curLoadAttempt)..".png"
	print("attempting load "..currentName)
	cur=love.filesystem.getInfo(currentName)

	if curLoadAttempt<4 and cur==nil then
		currentName=conf.template
		cur=love.filesystem.getInfo(currentName)
		print('loading from template')
	end

	--at this point if cur == nil, we loaded everything,
	--we return
	if cur==nil then

	   maxFrameReached=maxframe

	   loadTxtCodes()
	   initCanvases(1)
	   toPaintMode()
	   return
	end
	

	frameTable =loadfilter(currentName)
	--please note we will add other metadatas in frameTable, such as time code and optional sound
	--we are here because cur is not nil
	frameTable.dirty=false
	--this is a save flag ( we save only modified )

	--if file preexists load sound
	   local potsound=conf.prjfld..string.format("%03d",curLoadAttempt)..".wav"
	   print('looking up pot sound '..potsound)
	   local si=love.filesystem.getInfo(potsound)
	   if si~=nil then
	      frameTable.sound=love.audio.newSource(potsound,'static')
	   end
	   print('sound loaded ')
	   print(frameTable.sound)


	table.insert(frames,frameTable)
	
	maxframe=maxframe+1
	curLoadAttempt = curLoadAttempt + 1

end


initLoadScreen = function()
       maxframe=0
	--frames are 0 based for zazanim compatibility ( tcs, etc )
       curLoadAttempt=1

       drawFunc=drawLoadScreen
       updateFunc=updateLoadScreen
end
