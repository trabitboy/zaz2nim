--project select screen

-- preview to see projects story boards when you click around ( tex )
local preview = nil

local backQuad = {x=2*64, y=8*64, w=64, h=64}
local createQuad= {x=0, y=5*64, w=64, h=64}


local createProjectButton=function(i,p)
      
    local w = createTextButton(64*buttonZoom,i*64*buttonZoom,changeProjectOnStart,{text=p,key=p},buttonZoom)
      
    return w

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


local function exitSP()
	 print('exit sp ')

--	 toPaintMode(= {x=64, y=17*64, w=64, h=64})
   love.event.quit( "restart" )

end


local pageBack=function()
  if pageNumber>1 then
    pageNumber=pageNumber-1  
    createSPButtons()
  end  
end

local pageNext=function()
  if pageNumber<pageMax   then
    pageNumber=pageNumber+1  
    createSPButtons()
  end
end


createSPButtons=function()
  projects=getProjectsList()
  widgets={}
  
  local wExitZP = createpicbutton(0,0,buttonsPic,exitSP,backQuad,buttonZoom)
 
   local wCNS = createpicbutton(0,uih-192,buttonsPic,toCreateNewSequence,createQuad,buttonZoom)


  local wPrevPage=createpicbutton(uiw-64*buttonZoom,0,buttonsPic,pageBack,prevQuad,buttonZoom)
  local wNextPage=createpicbutton(uiw-64*buttonZoom,uih-192,buttonsPic,pageNext,nextQuad,buttonZoom)

  table.insert(widgets,wExitZP)
  table.insert(widgets,wCNS)
  table.insert(widgets,wPrevPage)
  table.insert(widgets,wNextPage)


  --TODO  create only widgets for current page, widgets will be recreated for other pages
  --we need to create a button per project
  local firstIndex=(pageNumber-1)*itemsByPage+1
  local nbAdded=0
  
  for i,p in ipairs(projects)
  do
      if i>=firstIndex and nbAdded<itemsByPage then 
        table.insert(widgets,createProjectButton(i-firstIndex,p))
        nbAdded=nbAdded+1
      end
  end



end





local function test()
  print('test')
end

--shared with create new seq
function changeProjectOnStart (folder)
  print('changeProject '..folder)
  --we need to save a currentproject.lua
  local lua="return '"..folder.."'"
  print('writing '..lua)
  love.filesystem.write('currentproject.lua',lua)
  
  --WIP if preview available, load it
  if love.filesystem.getInfo('project/'..folder..'/preview1.png') then
    print('preview found and loaded')
    preview=love.graphics.newImage('project/'..folder..'/preview1.png')
  end
  
end





local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(0.5,0.5,0.5,1.0)

	love.graphics.setColor(1.,1.,1.,1.0)
  
  if preview~=nil then
    love.graphics.draw(preview)
  end  
  
  
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

switchProjectKey=function(key, code, isrepeat)
	if key=='down' then
    pageBack()
--    if pageNumber>1 then
--      pageNumber=pageNumber-1  
--      createSPButtons()
--    end
	end

	if key =='up' then
    pageNext()
--      if pageNumber<pageMax   then
--        pageNumber=pageNumber+1  
--        createSPButtons()
--      end
	end 
  
end


function toSwitchProject()

  pageNumber=1 --default
  --TODO calculate number of items by page
  itemsByPage=6 --TODO make dynamic ? is it necessary?
  local nbProjects=#getProjectsList()
  pageMax=math.floor(nbProjects/itemsByPage)+1
  print(' page max: '..pageMax )

  createSPButtons()
  uiResize=createSPButtons

 	keyFunc = switchProjectKey
	drawFunc=switchProjectDraw
	updateFunc=switchProjectUpdate

end





