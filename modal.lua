
modalActive=false

modalMsg=''

setModal=function(txt)
	modalMsg=txt
	modalActive=true
end

disableModal=function()
	modalActive=false
end


displayModal=function()
	if modalActive==true then
	   love.graphics.setColor(0.,0.,0.,1.)
	   love.graphics.rectangle('fill',100,100,500,500)
	   love.graphics.setColor(1.,1.,1.,1.)
	end
end

