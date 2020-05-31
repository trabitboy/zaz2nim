


saveBgRanges=function ()

--we save all frame numbers that have are flagged bgs

local bgs={}

for i=1,maxframe
do
	if frames[i].bg==true then
	   table.insert(bgs,i)

	end

end

love.filesystem.write(conf.prjfld..'projectbgs.lua',serialize(bgs))

end


loadBgRanges=function()

 local bgs = {}
 bgsFsInfo=love.filesystem.getInfo(conf.prjfld..'projectbgs.lua')
 print('bgs file ')
 print(bgsFsInfo)
 if bgsFsInfo then
    bgs=love.filesystem.load(conf.prjfld..'projectbgs.lua')()
 else
--  highscores=defaulths()
    print('no bgs file')
 end
 print(bgs)


 for i,num in ipairs(bgs)
 do
     print('set frame  '..num..' as bg')
     frames[num].bg=true

 end

end