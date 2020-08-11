

--in this mode, we clean the back buffer, 
-- and paint to it 
-- display of paint mode also displays back buffer
-- on pen up back buffer is merged with normal cvs 


--draws a line from last blit x last blit y to current coords
function basicPaintUnderBlitBrushLineRemember(x,y)
	print("basic paint under blit line x,y "..x.." "..y)
  
  
  love.graphics.setCanvas(backBufferCvs)
  
  love.graphics.draw(mybrush,x,y)
  love.graphics.setCanvas() -- without this black layer, wouhou

	lastblitx=x
	lastblity=y
	
	dirtycvs=true
end

function commitBasicPaintUnder()
  print('commitBasicPaintUnder()')
  --blit cvs on top of backbuffercvs
  love.graphics.setCanvas(backBufferCvs)
  love.graphics.draw(cvs)
  
  love.graphics.setCanvas()
  --invert buffers
  local tmp = cvs
  cvs=backBufferCvs
  backBufferCvs=tmp
  
  --clear new backbuffercvs
  love.graphics.setCanvas(backBufferCvs)
  love.graphics.clear(1.,1.,1.,0.)
  love.graphics.setCanvas()
end

function initBasicPaintUnderBlitMode()
  
  --this flag is used to see if this paint mode is enabled
  basicPaintUnderMode=true
  
  
  love.graphics.setCanvas(backBufferCvs )
  love.graphics.clear(1.,1.,1.,0.)
  love.graphics.setCanvas()
  
  
  blitBrushLineRemember=basicPaintUnderBlitBrushLineRemember

  backBufferRender=true

  penUpPaintModeCb=commitBasicPaintUnder
end

