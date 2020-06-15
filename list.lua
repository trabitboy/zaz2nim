--queue implementation copied from lua.org doc
--additional size maintained

List = {}


function List.new ()
      return {first = 0, last = -1,size=0}
end

function List.pushRight (list, value)
      local last = list.last + 1
      list.last = last
      list[last] = value
      list.size=list.size+1
end
    
function List.popLeft (list)
      local first = list.first
      if first > list.last then error("list is empty") end
      local value = list[first]
      list[first] = nil        -- to allow garbage collection
      list.first = first + 1
      if list.size>0 then
      	 list.size=list.size-1
      end
      return value
end
