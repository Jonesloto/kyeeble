local class = require(script.Parent.Parent.class)
local errors = require(script.Parent.Parent.errors)
local Url, get = class('Url')
local HttpClient = require(script.Parent.client)

function Url:__init(domain, subdomain, valuesDict)
    if type(domain) ~= "string" or type(subdomain) ~= "string" then
        errors.type():raise()
    end

    for name, replaceValue in pairs(valuesDict) do
        if type(name) == "string" and type(replaceValue) == "string" then
            subdomain:gsub("%" .. name .. "%", replaceValue)
        else
            errors.type():raise()
        end
    end
    
    self.__url = domain .. subdomain 
    self.__httpClient = HttpClient()
    return self
end

get.url = function(self)
    return self.__url
end

return Url