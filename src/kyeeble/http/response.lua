local class = require(script.Parent.Parent.class)
local errors = require(script.Parent.Parent.errors)
local HttpService = game:GetService("HttpService")
local Response, get = class('Response')

function Response:__init(body)
    self.__body = body

    return self
end

get.body = function(self)
    return self.__body
end

get.json = function(self)
    pcall(function()
        decoded = HttpService:JSONDecode(self.__body)
    end)
    if decoded then return decoded else errors.http("Error occured decoding json"):raise() end
end

return Response