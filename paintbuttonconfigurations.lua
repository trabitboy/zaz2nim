-- --feature flag for bucket fill
-- bucketFF=false


-- decoBgQuad={x=2*64, y=2*64, w=64, h=64}
-- realDecoBgQuad=love.graphics.newQuad(decoBgQuad.x,decoBgQuad.y,decoBgQuad.w,decoBgQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

-- decoSoundQuad={x=1*64, y=10*64, w=64, h=64}
-- realDecoSoundQuad=love.graphics.newQuad(decoSoundQuad.x,decoSoundQuad.y,decoSoundQuad.w,decoSoundQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


-- decoHardBrushQuad={x=2*64, y=9*64, w=64, h=64}
-- realHardBrushQuad=love.graphics.newQuad(decoHardBrushQuad.x,decoHardBrushQuad.y,decoHardBrushQuad.w,decoHardBrushQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

-- decoSoftBrushQuad={x=2*64, y=10*64, w=64, h=64}
-- realSoftBrushQuad=love.graphics.newQuad(decoSoftBrushQuad.x,decoSoftBrushQuad.y,decoSoftBrushQuad.w,decoSoftBrushQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


-- repDecoQuad = {x=2*64, y=12*64, w=64, h=64}
-- realRepDecoQuad=love.graphics.newQuad(repDecoQuad.x,repDecoQuad.y,repDecoQuad.w,repDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

-- beginRangeDecoQuad = {x=0*64, y=12*64, w=64, h=64}
-- realDecoBeginRangeQuad=love.graphics.newQuad(beginRangeDecoQuad.x,beginRangeDecoQuad.y,beginRangeDecoQuad.w,beginRangeDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


-- endRangeDecoQuad = {x=0*64, y=13*64, w=64, h=64}
-- realDecoEndRangeQuad=love.graphics.newQuad(endRangeDecoQuad.x,endRangeDecoQuad.y,endRangeDecoQuad.w,endRangeDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())


-- decoColorFrameQuad = {x=2*64, y=16*64, w=64, h=64}
-- realDecoColorFrameQuad=love.graphics.newQuad(decoColorFrameQuad.x,decoColorFrameQuad.y,decoColorFrameQuad.w,decoColorFrameQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

-- underPMDecoQuad = {x=2*64, y=11*64, w=64, h=64}
-- realUnderPMDecoQuad=love.graphics.newQuad(underPMDecoQuad.x,underPMDecoQuad.y,underPMDecoQuad.w,underPMDecoQuad.h,buttonsPic:getWidth(),buttonsPic:getHeight())

-- addQuad = {x=0, y=320, w=64, h=64}
-- prevQuad = {x=0, y=64, w=64, h=64}
-- nextQuad = {x=0, y=0, w=64, h=64}
-- saveQuad = {x=0, y=128, w=64, h=64}
-- penQuad=  {x=64, y=192, w=64, h=64}
-- alternateHandQuad = {x=64*5, y=64, w=64, h=64}
-- undoQuad = {x=2*64, y=8*64, w=64, h=64}
-- eraserQuad = {x=0, y=192, w=64, h=64}
-- settingsQuad = {x=0, y=10*64, w=64, h=64}
-- copyQuad = {x=0, y=8*64, w=64, h=64}
-- pasteQuad = {x=0, y=9*64, w=64, h=64}
-- lflickQuad = {x=0, y=6*64, w=64, h=64}
-- rflickQuad = {x=0, y=7*64, w=64, h=64}
-- bucketQuad = {x=64,y=0, w=64, h=64}

-- local incRepQuad={x=2*64, y=15*64, w=32, h=32}
-- local decRepQuad={x=2*64+32, y=15*64, w=32, h=32}


-- function createConfDefault()
-- 	local ret={
-- 	--left
-- 	{x=0,y=0,call=prevFrame,quad=prevQuad},
-- 	{x=0,y=64*buttonZoom,call=toRightFlick,quad=rflickQuad},
-- 	{x=0,y=uih-320*buttonZoom,call=undoLastStroke,quad=undoQuad},
-- 	{x=0,y=uih-256*buttonZoom,call=togglePen,quad=penQuad},
-- 	{x=0,y=uih-192*buttonZoom,call=toggleEraser,quad=eraserQuad},
-- 	{x=0,y=uih-128*buttonZoom,call=copyFrame,quad=copyQuad},
-- 	{x=0,y=uih-64*buttonZoom,call=addFrame,quad=addQuad},

-- 	--right
-- 	{x=uiw-64*buttonZoom,y=0,call=nextFrame,quad=nextQuad},
-- 	{x=uiw-64*buttonZoom,y=64*buttonZoom,call=toLeftFlick,quad=lflickQuad},
-- 	{x=uiw-64*buttonZoom,y=128*buttonZoom,call=togglePaintButtons,quad=alternateHandQuad},
-- 	{x=uiw-64*buttonZoom,y=192*buttonZoom,call=toSettings,quad=settingsQuad},
-- 	-- {x=uiw-64*buttonZoom,y=uih-192*buttonZoom,call=bucket,quad=bucketQuad},
-- 	{x=uiw-64*buttonZoom,y=uih-128*buttonZoom,call=pasteFrame,quad=pasteQuad},


-- 	{x=uiw-64*buttonZoom,y=uih-64*buttonZoom,call=initSaveScreenFromPaintMode,quad=saveQuad},

-- 	}
-- 	return ret
-- end

-- confButtonsDefault=createConfDefault()


-- --conf buttons 2 columns right
-- confButtonsRight={
-- 	--left
-- 	{x=uiw-128*buttonZoom,y=0,call=prevFrame,quad=prevQuad},
-- 	{x=uiw-128*buttonZoom,y=64*buttonZoom,call=toRightFlick,quad=rflickQuad},
-- 	{x=uiw-128*buttonZoom,y=uih-320*buttonZoom,call=undoLastStroke,quad=undoQuad},
-- 	{x=uiw-128*buttonZoom,y=uih-256*buttonZoom,call=togglePen,quad=penQuad},
-- 	{x=uiw-128*buttonZoom,y=uih-192*buttonZoom,call=toggleEraser,quad=eraserQuad},
-- 	{x=uiw-128*buttonZoom,y=uih-128*buttonZoom,call=copyFrame,quad=copyQuad},
-- 	{x=uiw-128*buttonZoom,y=uih-64*buttonZoom,call=addFrame,quad=addQuad},

-- 	--right
-- 	{x=uiw-64*buttonZoom,y=0,call=nextFrame,quad=nextQuad},
-- 	{x=uiw-64*buttonZoom,y=64*buttonZoom,call=toLeftFlick,quad=lflickQuad},
-- 	{x=uiw-64*buttonZoom,y=128*buttonZoom,call=togglePaintButtons,quad=alternateHandQuad},
-- 	{x=uiw-64*buttonZoom,y=192*buttonZoom,call=toSettings,quad=settingsQuad},
-- 	-- {x=uiw-64*buttonZoom,y=uih-192*buttonZoom,call=bucket,quad=bucketQuad},
-- 	{x=uiw-64*buttonZoom,y=uih-128*buttonZoom,call=pasteFrame,quad=pasteQuad},
-- 	{x=uiw-64*buttonZoom,y=uih-64*buttonZoom,call=initSaveScreenFromPaintMode,quad=saveQuad},
-- }

-- --conf buttons 2 columns leftx
-- confButtonsLeft={
-- 	--left
-- 	{x=0,y=0,call=prevFrame,quad=prevQuad},
-- 	{x=0,y=64*buttonZoom,call=toRightFlick,quad=rflickQuad},
-- 	{x=0,y=uih-320*buttonZoom,call=undoLastStroke,quad=undoQuad},
-- 	{x=0,y=uih-256*buttonZoom,call=togglePen,quad=penQuad},
-- 	{x=0,y=uih-192*buttonZoom,call=toggleEraser,quad=eraserQuad},
-- 	{x=0,y=uih-128*buttonZoom,call=copyFrame,quad=copyQuad},
-- 	{x=0,y=uih-64*buttonZoom,call=addFrame,quad=addQuad},

-- 	--right
-- 	{x=64*buttonZoom,y=0,call=nextFrame,quad=nextQuad},
-- 	{x=64*buttonZoom,y=64*buttonZoom,call=toLeftFlick,quad=lflickQuad},
-- 	{x=64*buttonZoom,y=128*buttonZoom,call=togglePaintButtons,quad=alternateHandQuad},
-- 	{x=64*buttonZoom,y=192*buttonZoom,call=toSettings,quad=settingsQuad},
-- 	-- {x=64*buttonZoom,y=uih-192*buttonZoom,call=bucket,quad=bucketQuad},
-- 	{x=64*buttonZoom,y=uih-128*buttonZoom,call=pasteFrame,quad=pasteQuad},
-- 	{x=64*buttonZoom,y=uih-64*buttonZoom,call=initSaveScreenFromPaintMode,quad=saveQuad},
-- }

