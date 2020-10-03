local class = require(script.Parent.Parent.class)

local Error = class("Error")

Error.__defaultMessage = "This is a default error message"

function Error:__init(message)
    self.__message = message or self.__defaultMessage
end

function Error:raise()
    error(self.__name .. ": " self.__message)
end

return Error