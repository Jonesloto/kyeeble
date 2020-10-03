--[[
Http wrapper
]]--
local url = require(script.url)
local Http, get = class('Http')

function Http:__init()
    self.__url = url

	return self
end

get.url = function(self)
    return self.__url
end

return Http()