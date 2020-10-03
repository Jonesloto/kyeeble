local class = require(script.Parent.Parent.class)
local error = require(script.Parent.errorclass)

local Errors, get = class("Errors")

local HttpError = class("HttpError", error)
local TypeError = class("HttpError", error)
local LoggingError = class("LoggingError", error)

TypeError.__defaultMessage = "The type of the given instances are invalid"
HttpError.__defaultMessage = "There was an error with the HTTP module"
LoggingError.__defaultMessage = "There was an error with the LOGGING module"

Errors.__error = error
Errors.__LoggingError = LoggingError
Errors.__HttpError = HttpError
Errors.__TypeError = TypeError

function Errors:__init()
    return self
end

get.http = function(self)
    return self.__HttpError
end

get.logging = function(self)
    return self.__LoggingError
end

get.type = function(self)
    return self.__TypeError
end

get.default = function(self)
    return self.__error
end

return errors