
local backQuad = {x=2*64, y=8*64, w=64, h=64}
local createQuad = {x=0, y=5*64, w=64, h=64}

--called on button click
local function createNewProjectFolder()
  
      if string.len(newSeqName)==0 then
          screenMsg='enter a project name'
          return
      end
  
  
  
      tgt='project/'..newSeqName
      pot=love.filesystem.getInfo(tgt)

      if pot~=nil then
      	 screenMsg='project already exists'
         return
      end


      love.filesystem.createDirectory(tgt)
--    		   local tmp = love.filesystem.newFileData('template/'..newT

--		   local newname = name..'.wav'
--		   local tgtpath=spath..newname
--		   print('writing sound '..tgtpath)
--		   love.filesystem.write(tgtpath,tmp)		   
      love.filesystem.write(tgt..'/template.lua',"return '".. newTemplate .."'")		  
	--TODO create currentproject.lua
  
  --TODO reboot
  
  
end


local newSeqTextInput=function(t)
 if t==' ' then return end

 newSeqName=newSeqName..t

end





-- if t=='w' then
-- love.keyboard.setTextInput(false)
-- createNewProjectFolder()
-- return
-- end




local function exitCNS()
	 print('exit CNS ')

	 toPaintMode()

end



local widgets={}

local getTemplatesList=function()
  local ret={}
  for i,f in ipairs(love.filesystem.getDirectoryItems('template/'))
  do
    print ('file '..f)
    info = love.filesystem.getInfo( 'template/'..f,     'directory' )
    if info ~=nil then
      print(f..' is a dir')
      table.insert(ret,f)
    end
  end
  return ret
end

local function changetemplate (folder)
  --TODO 
  print('changetemplate '..folder)
  newTemplate=folder
  --we need to create a currenttemplate.lua
  screenMsg=' type unused seq name then press create' 
  newSeqName=''
  love.keyboard.setTextInput(true)
  love.textinput=newSeqTextInput
end





local createtemplateButton=function(i,p)
      
    local w = createTextButton(i*128*buttonZoom,64*buttonZoom,changetemplate,{text=p,key=p},buttonZoom)
      
    return w

end



local createCNSButtons=function()
  Templates=getTemplatesList()
  widgets={}
  
  local wExitZP = createpicbutton(0,0,buttonsPic,exitCNS,backQuad,buttonZoom)
  local wCreate = createpicbutton(0,128*buttonZoom,buttonsPic,createNewProjectFolder,createQuad,buttonZoom)
 

  table.insert(widgets,wExitZP)
  table.insert(widgets,wCreate)


  --we need to create a button per template
  for i,p in ipairs(Templates)
  do
      table.insert(widgets,createtemplateButton(i,p))
    
  end



end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,1.0)


	love.graphics.setColor(0.,0.,0.,1.0)
  love.graphics.print(screenMsg,100,200,0,4,4)
  love.graphics.print('new seq : '..newSeqName,100,300,0,4,4)

	love.graphics.setColor(1.,1.,1.,1.0)
	renderWidgets(widgets)

		
	msgToCvs()

	--love.graphics.print()
	love.graphics.setCanvas()
end


local function createNewSequenceDraw()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(.5,.5,.5,1.0)
		--love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
		
end



local function createNewSequenceUpdate()
	 if npress==true then
--	    print('bs click')
--	    addMsg('bs click')
	    consumed=consumeClick(widgets)
--	    print('consumed '..tostring(consumed))brushScreenbrushScreen
	    if consumed==true
	    then
		return
	    end


	    npress=false
	 end

end




function toCreateNewSequence()

  love.keyboard.setTextInput(false)
  
  
  screenMsg='select template'
  
  newSeqName=''
  
  createCNSButtons()
  uiResize=createCNSButtons

	keyFunc = nil

	drawFunc=createNewSequenceDraw
	updateFunc=createNewSequenceUpdate

end





