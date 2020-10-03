--[[
This is a slightly modified instance of https://gist.github.com/Kyando2/2081c1711436758bf27d9ef731b9daae
]]--

local metadata = {}
local names = {}

function metadata:__call(...)
	local obj = setmetatable({}, self)
	obj:__init(...)
	return obj
end

function metadata:__newindex(k, v)
	if k:find("^" .. "__") == nil then
		print('Adding native property ' .. k ..' to class ' .. self.__name)
	end
	rawset(self, k, v)
end

function inherit(child, ancestor, inherited)
	for k1, v1 in pairs(ancestor) do
		if k1:find("^" .. "__") == nil then
			print('Adding inherited property ' .. k1 .. ' from ancestor ' .. ancestor.__name)
		end
		inherited[k1] = v1
	end
	for k2, v2 in pairs(ancestor.__inherited) do
		if k2:find("^" .. "__") == nil then
			print('Adding inherited property ' .. k2 .. ' from ancestor ' .. ancestor.__name)
		end
		inherited[k2] = v2
	end
	local ancestors = {}
	table.insert(ancestors, ancestor)
	table.insert(ancestors, ancestor.__ancestors)
	return ancestors
end

return setmetatable({},
{__call = 
	function(_, name, ...)
		if names[name] ~= nil then return names[name] end -- Returns the class if it was already loaded
		print('\n--- Generating Class ---')
		print(name)
		local parents = {...}
		parents.n = nil
		--[[
		**ATTRIBUTE TYPES**
		
		There are four different attribute types for objects; NATIVE, INHERITED, ADDED and GETTER
		NATIVE:
			Native attributes are attributes that are added when creating the class
			after using the implementation provided here. They are the 3rd to be fetched
			when searching for an attribute
		INHERITED:
			Inherited attributes are attributes that are inherited from the parent
			They are always the last ones to be fetched
		ADDED:
			Added attributes are attributes that are added after the initialization of the class into an object
			They are always the second ones fetched when searching for an attribute
		GETTER:
			Functions that have been added to the getter dictionary returned from this module
			They are the first one fetched when searching an attribute and are automatically called
			with the cls attribute
		]]--
		local class = setmetatable({__name = name}, metadata)
		local dict = {}
		local inherited = {}
		local getter = {}
		local ancestors = {}
		--[[
		**INHERITANCE**
		All native and inherited attributes from parent class are transfered to this class as inherited attributes
		]]--
		if parents then
			for _, v in pairs(parents) do
				inherit(class, v, inherited)
			end
		end
		--[[
		**INDEX**
		Adding an INDEX method to your class will overpower the default implementation below
		and automatically get called by __index
		]]--
		function class:__index(k)
			if k ~= "__init" then
				if rawget(class, "INDEX") then return rawget(class, "INDEX")(self, class, k) end
				if inherited["INDEX"] then return inherited.INDEX(self, class, k) end
			end
			if getter[k] then return getter[k](self) end
			if dict[k] ~= nil then
				return dict[k]
			elseif rawget(class, k) ~= nil then
				return rawget(class, k)
			elseif inherited[k] ~= nil then
				return inherited[k]
			end
			return nil
		end
		
		--[[
		**NEWINDEX**
		Adding an NEWINDEX method to your class will overpower the default implementation below
		and automatically get called by __newindex
		]]--
		function class:__newindex(k, v)
			if rawget(class, "NEWINDEX") then return rawget(class, "NEWINDEX")(self, class, k) end
			if inherited["NEWINDEX"] then return inherited.NEWINDEX(self, class, k) end
			dict[k] = v
		end
		--[[
		**THE DICT**
		
		The dict table is a table containing all of the added attributes to a Class
		This includes all attributes added after initialization
		-->> THOSE ATTRIBUTES ARE ALWAYS FETCHED **BEFORE** NATIVE AND INHERITED ATTRIBUTES <<--
		As such adding anything to that table will overwrite the native attribute
		For Example:
		Imagine an object with a native "happy" attribute set to true
		print(object.happy)
		>> true
		If we were to then do object.happy = false then 
		print(object)
		>> false
		However if we do object.happy = nil then
		print(object.happy)
		>> true 
		Because it went back to the native attribute
		]]--
		class.__dict = dict
		class.__inherited = inherited
		class.__ancestors = ancestors
		--[[
		**THE GETTER**
		any function added to the getter table will be called when trying to access an attribute
		Example:
		Imagine a class with a _name method which returns the class' name
			function getter.name(self)
				return self:_name()
			end
		This, put simply, transform a call of object:_name() to object.name 
		]]--
		class.__getter = getter 
		names[name] = class
		print('------------------------\n')
		return class, getter
	end})