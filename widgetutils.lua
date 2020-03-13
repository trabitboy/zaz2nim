function renderWidgets(locals)
	for i,w in ipairs(locals)
	do
		w.render(w)
	end

end


--returns true if click consumed
function consumeClick( widgets)
		for i,w in ipairs (widgets)
		do
			ret=w.click(w,npx,npy)
			if ret==true then
				npress=false
				return true
			end

		end
		return false
end