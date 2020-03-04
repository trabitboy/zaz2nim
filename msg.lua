maxMsg=10

mx=0
my=0

msg={}

function msgToCvs()
	my=0
	-- for i,t in ipairs(msg)
	-- do
		-- love.graphics.setColor(0.,0.,0.,1.)
		-- love.graphics.print(t,mx,my)
		-- my=my+20
	-- end
	love.graphics.setColor(1.,0.,0.,1.)

	for i = #msg, 1, -1 do
		love.graphics.print(msg[i],mx,my)
		my=my+20
	end
	love.graphics.setColor(1.,1.,1.,1.)

end

function addMsg(t)
	table.insert(msg,t)
	if max_msg<=tbllngth(msg) then
		table.remove(msg,max_msg+1)	
	end

end
