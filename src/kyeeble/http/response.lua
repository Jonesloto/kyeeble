local class = require(script.Parent.Parent.class)
local HttpService = game:GetService("HttpService")
local Response, get = class('Response')

function Response:__init(body)
    self.__body = body

    return self
end

get.body = function(self)
    return self.__body
end

-- TODO: Handle possible error
get.json = function(self)
    return HttpService:JSONDecode(self.__body)
end

return Response