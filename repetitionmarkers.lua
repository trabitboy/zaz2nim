-- managment of repetitions markers ( for loops )


repetitions = {}

--repetitions = {
--  3={trigger=3,target=1,repetition=4} the sequence of frames 1 > 3 is played 4 times
--
--}

--returns repetition in question, or nil if not any
function isFrameInRepetition(idx)
--  print('is frame '..idx .. ' in rep ')
  for i in pairs(repetitions)
  do
    local r=repetitions[i]
    if idx <=r.trigger and idx>=r.target then
--      print(' rep found '..r.trigger.. ' ' .. r.target)
      return r
    end
  end
  
  return nil
end


function setRepetition(start,seqEnd,num)
  --TODO check no other repetition overlaps, maybe cancel it ?
  
  if start~=nil and seqEnd~=nil and seqEnd>start then
    print('setting repetition for range '..start..' '..seqEnd)
    local tmp={trigger=seqEnd,target=start,repetition=num}
    repetitions[seqEnd]=tmp
  else 
    print('repetition :one param is nil, or wrong order')
  end
  
end

function saveRepetitions()
  love.filesystem.write(conf.prjfld..'repetitions.lua',serialize(repetitions))
end

function loadRepetitions()
  repetitions = {}
  repFsInfo=love.filesystem.getInfo(conf.prjfld..'repetitions.lua')
  print('reps file ')
  print(repFsInfo)
  if repFsInfo then
    repetitions=love.filesystem.load(conf.prjfld..'repetitions.lua')()
  else
--  highscores=defaulths()
    print('no reps file')
  end



end


function maintainRepetitionsFrameDeletion(deletedIdx)
  print('maintainRepetitionsFrameDeletion('..deletedIdx ..')')
  print(repetitions)
  tmp = {}
  for i in pairs (repetitions)
  do
    r=repetitions[i]
    print('inspecting '..r.trigger .. ' repetition')
    if r.trigger>=deletedIdx then
      print('trigger lowered')
      r.trigger=r.trigger-1
    end
    if r.target>=deletedIdx then
      print('target lowered')
      r.target=r.target-1
    end
    tmp[r.trigger]=r
    print('added to filtered table')
  end
  repetitions=tmp
end

--
function maintainRepetitionsFrameAddition(addedIdx)
  print('maintainRepetitionsFrameAddition('..addedIdx..')')
  tmp = {}
  for i in pairs (repetitions)
  do
    
    r=repetitions[i]
    if r.trigger>=addedIdx then
      print('trigger increased')
      r.trigger=r.trigger+1
    end
    if r.target>=addedIdx then
      print('target increased')
      r.target=r.target+1
    end
    tmp[r.trigger]=r
  
  end
  repetitions=tmp
  
end


function removeRepetition(idx)
  
  print('remove repetition   '..idx)
  local r=isFrameInRepetition(idx)  
  print('current trigger '..r.trigger .. ' target ' ..r.target)
  
  
  if r~=nil then
    print(' reps number before '..tbllngth(repetitions))
    repetitions[r.trigger]=nil
    print(' reps number after '..tbllngth(repetitions))
  end
--  for i in pairs(repetitions)
--  do
--    rep=repetitions[i]
--    --TODO never goes there for some reason
--    print(' cur trig '..rep.trigger)
--    if rep.trigger==r.trigger then
--      print(' removing current repetition ')
--      --not possible to remove element that way
--      table.remove(repetitions,i)
--      break
--    end
--  end

  
end