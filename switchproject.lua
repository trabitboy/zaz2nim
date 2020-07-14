--project select screen

local backQuad = {x=2*64, y=8*64, w=64, h=64}
local createQuad= {x=0, y=5*64, w=64, h=64}


local function exitSP()
	 print('exit sp ')

--	 toPaintMode(= {x=64, y=17*64, w=64, h=64})
   love.event.quit( "restart" )

end



local widgets={}
local getProjectsList=function()
  local ret={}
  for i,f in ipairs(love.filesystem.getDirectoryItems('project/'))
  do
    print ('file '..f)
    info = love.filesystem.getInfo( 'project/'..f,     'directory' )
    if info ~=nil then
      print(f..' is a dir')
      table.insert(ret,f)
    end
  end
  return ret
end

local function test()
  print('test')
end

local function changeProject (folder)
  --TODO 
  print('changeProject '..folder)
  --we need to create a currentproject.lua
  local lua="return '"..folder.."'"
  print('writing '..lua)
  love.filesystem.write('currentproject.lua',lua)
  
  
end


local createProjectButton=function(i,p)
      
    local w = createTextButton(64,i*64*buttonZoom,changeProject,{text=p,key=p},buttonZoom)
      
    return w

end



local createSPButtons=function()
  projects=getProjectsList()
  widgets={}
  
  local wExitZP = createpicbutton(0,0,buttonsPic,exitSP,backQuad,buttonZoom)
 
   local wCNS = createpicbutton(0,uih-64,buttonsPic,toCreateNewSequence,createQuad,buttonZoom)

  table.insert(widgets,wExitZP)
  table.insert(widgets,wCNS)


  --we need to create a button per project
  for i,p in ipairs(projects)
  do
      table.insert(widgets,createProjectButton(i,p))
    
  end



end

local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,1.0)

	love.graphics.setColor(1.,1.,1.,1.0)
	renderWidgets(widgets)

		
	msgToCvs()

	--love.graphics.print()
	love.graphics.setCanvas()
end


local function switchProjectDraw()
		rendertouicanvas()
		--this is the background image of our paint
		love.graphics.clear(.5,.5,.5,1.0)
		--love.graphics.clear(1.,1.,1.,1.0)
		love.graphics.setColor(1.0,1.0,1.0,1.0)
		love.graphics.draw(ui,0,0,0,scrsx,scrsy)	
		
end



local function switchProjectUpdate()
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


function toSwitchProject()

  createSPButtons()
  uiResize=createSPButtons


	drawFunc=switchProjectDraw
	updateFunc=switchProjectUpdate

end





