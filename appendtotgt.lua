
--tgtfld : full path of tgt cpy folder, with trailing /
function appendToOtherProject(tgtfld,nbstart,nbend)
  
  tgtnb=1
  
  currentName=string.format("%03d",tgtnb)
	currentPathAndName=tgtfld..currentName..".png"
	print("attempting load "..currentPathAndName)
	cur=love.filesystem.getInfo(currentPathAndName)

	while cur~=nil do
    print(' frame '..tgtnb..' exists in tgt')
    tgtnb=tgtnb+1
    currentName=string.format("%03d",tgtnb)
    currentPathAndName=tgtfld..currentName..".png"
    print("attempting load "..currentPathAndName)
    cur=love.filesystem.getInfo(currentPathAndName)
  
	end
  
  --cur is nil, we reached point of append
  print(' frames will be appended from'..tgtnb)
  
  --TODO save frames using in memory version (quickest)
  for i=nbstart,nbend 
  do
    saveName=string.format("%03d",tgtnb)
    savePathAndName=tgtfld..saveName..".png"
    print("attempting to save "..savePathAndName)
    --TODO WIP frames should be ok
--    saveCanvasToFrame(i)
    frames[i].data:encode("png",savePathAndName)
    tgtnb=tgtnb+1
  end
  
end