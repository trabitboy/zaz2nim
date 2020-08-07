


saveColorFrames=function ()

--we save all frame numbers that have are flagged cfs

local cfs={}

for i=1,maxframe
do
	if frames[i].cf==true then
	   table.insert(cfs,i)

	end

end

love.filesystem.write(conf.prjfld..'projectcfs.lua',serialize(cfs))

end


loadColorFrames=function()

 local cfs = {}
 cfsFsInfo=love.filesystem.getInfo(conf.prjfld..'projectcfs.lua')
 print('cfs file ')
 print(cfsFsInfo)
 if cfsFsInfo then
    cfs=love.filesystem.load(conf.prjfld..'projectcfs.lua')()
 else
--  highscores=defaulths()
    print('no cfs file')
 end
 print(cfs)


 for i,num in ipairs(cfs)
 do
     print('set frame  '..num..' as cf')
     frames[num].cf=true

 end

end