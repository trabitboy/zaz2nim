mx=0
my=0

msg={}

function msgToCvs()
	my=0
	for i,t in ipairs(msg)
	do
		love.graphics.print(t,mx,my)
		my=my+20
	end

end

function addMsg(t)
	table.insert(msg,t)

end