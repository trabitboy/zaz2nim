function renderWidgets(locals)
	for i,w in ipairs(locals)
	do
		w.render(w)
	end

end


function consumeClick( widgets)
		for i,w in ipairs (widgets)
		do
			ret=w.click(w,npx,npy)
			if ret==true then
				npress=false
				break
			end

		end
end