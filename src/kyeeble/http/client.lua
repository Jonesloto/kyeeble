local class = require(script.Parent.Parent.class)
local HttpService = game:GetService("HttpService")
local HttpClient, get = class('HttpClient')

local responseClass = require(script.Parent.response)

function HttpClient:__init()
    return self
end

function HttpClient:get(url, nocache, headers)
    pcall(function ()
		returnValue = HttpService:GetAsync(url, nocache, headers)
    end)
    
    -- TODO: Handle possible error here
    if response then return responseClass(returnValue) else return nil end
end

return HttpClient
