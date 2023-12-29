local clearColor={r=0.,g=0.,b=0.,a=0.}


local function commonInit()
	-- saving canvas to frame, to be sure we pick 
	--latest changes
	saveCanvasToFrame(currentIdx)


	drawFunc = pickModeDraw
	updateFunc = pickModeUpdate

end

--mode flag
local fill=false

function toFloodFill()
	 print('init flood fill')
	 fill=true
	 commonInit()

end

function toPickMode()
	 fill=false
	 commonInit()
	
end


local function rendertouicanvas()
	love.graphics.setCanvas(ui)
	love.graphics.clear(1.0,1.0,1.0,0.0)
	
	love.graphics.rectangle('fill',
--    0,0,
    offsetcvs.x,offsetcvs.y,
    conf.cvsw*applicativezoom,conf.cvsh*applicativezoom)
--	love.graphics.draw(frames[currentIdx].pic)
  --to mutualize with other screens that use canvas and offset
 	love.graphics.draw(cvs,offsetcvs.x,offsetcvs.y,0,applicativezoom,applicativezoom)

  
	msgToCvs()
	love.graphics.setCanvas()

end

function pickModeDraw()

	rendertouicanvas()
	love.graphics.clear(.5,.5,.5,1.0)
	love.graphics.setColor(1.0,1.0,1.0,1.0)
	love.graphics.draw(ui,0,0,0,scrsx,scrsy)	

end


function pickModeUpdate()
	if npress==true then
    
    --offsetcvs.x,offsetcvs.y,0,applicativezoom
--    addMsg('pick m u, npx '..npx..' npy '..npy )
--    addMsg(' offset '+offsetcvs.x+' '+offsetcvs.y+' app zoom '+applicativezoom)
--    addMsg(' ajusted offnpx offnpy ')
    addMsg('pick mode newpress npx '..npx..' npy '..npy)
    local xcvs,ycvs=getTouchOnCanvas(0)
    addMsg('canvas coord: '..xcvs..' '..ycvs)
    
    if xcvs>=0 and ycvs>=0
    and xcvs<=conf.cvsw and ycvs<=conf.cvsh then
      addMsg('click in image canvas !!! ')
      if fill==false then
        addMsg('picking color')
        r,g,b,a=frames[currentIdx].data:getPixel(
--        npx,npy
        xcvs,ycvs
        )
        addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
        addMsg('quit pick')
        mybrush=love.graphics.newImage(currentBrushFunc(brshradius,r,g,b))
        mybrush:setFilter('nearest','nearest')

        paintcolor.r=r
        paintcolor.g=g
        paintcolor.b=b
      
        npress=false
      
        toPaintMode()
      return

      else
        addMsg('filling color WIP')
        print('calling flood fill')
        if eraseMode==false then
          floodFill(xcvs,ycvs,paintcolor,frames[currentIdx].data,frames[currentIdx].data)
        else
          floodFill(xcvs,ycvs,clearColor,frames[currentIdx].data,frames[currentIdx].data)
        end

      --image data needs to be uploaded back to gpu mem
        frames[currentIdx].pic:release()
        frames[currentIdx].pic=love.graphics.newImage(frames[currentIdx].data)

        frames[currentIdx].dirty=true

        -- upload to work canvas
        initCanvases(currentIdx)

        npress=false
      
        toPaintMode()
        return
        
      end
    else
      addMsg('click not in paint canvas!')
      npress=false
      return
    end
    
    --TODO to update for offset and zoom
--	  if 
--    npx<conf.cvsw
--    and npy<conf.cvsh
--     and fill==false  then
--	        print('pick color triggered')
--	   	--pick color
--      r,g,b,a=frames[currentIdx].data:getPixel(
--        npx,npy
--        )
--      addMsg('color '.. math.floor( r*255) ..' '.. math.floor(g*255) ..' '.. b*255)
--      addMsg('quit pick')
--  --		mybrush=love.graphics.newImage(roundBrushWithAlpha(brshradius,r,g,b))
--  --		mybrush=love.graphics.newImage(roundBrushWithGradient(brshradius,r,g,b))
--      mybrush=love.graphics.newImage(currentBrushFunc(brshradius,r,g,b))
--      mybrush:setFilter('nearest','nearest')

--      paintcolor.r=r
--      paintcolor.g=g
--      paintcolor.b=b
      
--      npress=false
      
--      toPaintMode()
--      return
--    elseif npx<conf.cvsw
--    and npy<conf.cvsh
--    and fill==true  then
--	   	--local r,g,b,a = frames[currentIdx].data:getPixel(npx,npy)
--	   	print('calling flood fill')
--      if eraseMode==false then
--        floodFill(npx,npy,paintcolor,frames[currentIdx].data,frames[currentIdx].data)
--      else
--        floodFill(npx,npy,clearColor,frames[currentIdx].data,frames[currentIdx].data)
--      end

--      --image data needs to be uploaded back to gpu mem
--      frames[currentIdx].pic:release()
--      frames[currentIdx].pic=love.graphics.newImage(frames[currentIdx].data)

--      frames[currentIdx].dirty=true

--      -- upload to work canvas
--      initCanvases(currentIdx)

--      npress=false
      
--      toPaintMode()
--      return

--    else
--      npress=false
--      addMsg('out of boundaries')
--      print('out of boundaries')
--    end
	end

end