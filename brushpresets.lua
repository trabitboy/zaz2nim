--to save the brush presets on function keys

-- when we change presets we recompose a preview picture
brushPreviewCanvas=nil




--structure for documentation
--we save setings with f6 f10
--we restore with f1 f5
brushPresets={
--	f1={eraser=true,size=8},
--	f2={size=8,color={r=1.0,g=0.0,b=0.0,type='soft'|'hard'}}
}

--texs stored separately so we can save metadata
brushTexes ={
	   --f2=realblittablebrush
}


--DIRTY takes keycode directly so slot is f'x' - 5
storeInSlot= function(key)
	print('storing '..key)
	slot=key:sub(2,3)
	tgtslot=slot-5
	print('tgtslot '..tgtslot)
	tkey='f'..tgtslot


	if eraseMode==true then
	   print('eraser stored')
	   brushPresets[tkey]={eraser=true,size=eraserRadius}
	else
	   print('brush stored '..tkey)
     
     
     if currentBrushFunc==roundBrushWithAlpha then
        local currentType='hard'
     elseif currentBrushFunc==roundBrushWithGradient then
        local currentType='soft'
     end
	   brushPresets[tkey]={size=brshradius,color={r=paintcolor.r,g=paintcolor.g,b=paintcolor.b},type=currentType}
     if currentBrushFunc==roundBrushWithAlpha then
        brushPresets[tkey].type='hard'
     elseif currentBrushFunc==roundBrushWithGradient then
        brushPresets[tkey].type='soft'
     end
	   brushTexes[tkey]=mybrush
	end
	
end

restoreSlot= function(key)
	print('restoring '..key)

	local pot=brushPresets[key]
	if pot==nil then
	   print('nothing to restore yet')
	   return
	end

	if pot.eraser==true then
	   print('eraser restored')
	   eraseMode=true
	   eraserRadius=pot.size
	else
	   eraseMode=false
     if pot.type=='hard' then
        currentBrushFunc=roundBrushWithAlpha
     elseif pot.type=='soft' then
        currentBrushFunc=roundBrushWithGradient
     end

	   
     print('brush restored '..key)
	   brshradius=pot.size
	   paintcolor.r=pot.color.r
	   paintcolor.g=pot.color.g
	   paintcolor.b=pot.color.b
	   mybrush=brushTexes[key]
	end
	

end





saveBrushes=function ()
--brushes are stored by project
	  


	  --conf.prjfld
	  --lets try without stripping texes
	  love.filesystem.write(conf.prjfld..'brushes.lua',serialize(brushPresets))

end

--we loaded brushes, lets prepare the texes
initBrushTexes=function()

	for k,pres in pairs( brushPresets )
	do
		if pres.eraser==nil then

        --brush func depends on template
        local initBrushFunc=1 --just to exist
         if pres.type=='hard' then
            initBrushFunc=roundBrushWithAlpha
         elseif pres.type=='soft' then
            initBrushFunc=roundBrushWithGradient
         end
        

				local tmp=love.graphics.newImage(initBrushFunc(	pres.size,pres.color.r,pres.color.g,pres.color.b))
				tmp:setFilter('nearest','nearest')
				brushTexes[k]=tmp
				print('text brush stored for '..k)
				print('color '..pres.color.r..' '..pres.color.g..' '..pres.color.b)
		end
	end

end


loadBrushes=function()
 local loaded = {}
 local loadedFsInfo=love.filesystem.getInfo(conf.prjfld..'brushes.lua')
 print('brushes file ')
 print(loadedFsInfo)
 if loadedFsInfo then
    brushPresets=love.filesystem.load(conf.prjfld..'brushes.lua')()
    initBrushTexes ()--these can not be serialized
 else
--  highscores=defaulths()
    print('no brushes file, TODO load defaults')
 end


end