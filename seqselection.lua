--we load the current project from a file in data folder
--if not present, we use a default location

 local currentFsInfo=love.filesystem.getInfo('currentproject.lua')
 print('current project file  ')
 print(currentFsInfo)
 if currentFsInfo then
    --we found a project config
    local tmp=love.filesystem.load('currentproject.lua')()
    print(' setting project to ' .. tmp  )

    print('trying to load template for project ')
    local template=love.filesystem.load('project/'..tmp..'/template.lua')()
    
    conf=prjTemplates[template]  

    --TODO conf should be ref to the template,
    -- project path should be put somewhere else
    conf.prjfld="project/"..tmp.."/"
 else
--  highscores=defaulths()
    print('no config file , TODO set default project')

    conf=prjTemplates[hd43conf.key]

    conf.prjfld='project/dflt/'

    

 end



