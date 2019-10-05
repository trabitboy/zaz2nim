function renderWidgets(locals)
	for i,w in ipairs(locals)
	do
		w.render(w)
	end

end
