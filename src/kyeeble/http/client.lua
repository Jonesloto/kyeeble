local class = require(script.Parent.Parent.class)
local errors = require(script.Parent.Parent.errors)
local HttpService = game:GetService("HttpService")
local HttpClient, get = class('HttpClient')
local ResponseClass = require(script.Parent.response)

function HttpClient:__init()
    return self
end

function HttpClient:get(url, nocache, headers)
    pcall(function ()
	    returnValue = HttpService:GetAsync(HttpService:UrlEncode(url), nocache, headers)
    end)
    
    if response then return ResponseClass(returnValue) else errors.Http("There was an error performing this get request"):raise() end
end

return HttpClient
