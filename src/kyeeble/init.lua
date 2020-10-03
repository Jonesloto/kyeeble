--[[
Copyright (c) 2020 Kyando
This is a module infrastructure for handling daily annoyances that can get repetitive
From errors and classes to http, async and server client communication, all the small things you have to do
	
	THIS IS A WIP

]]--

local class = require(script.class)
local metadata = require(script.metadata)
local Candle, get = class('Candle')

function Candle:__init()
	self.__VERSION__ = metadata.version
	self.__AUTHOR__ = metadata.author
	self.__REPO__ = metadata.repo
	self.__LICENSE__ = metadata.license
	return self
end

get.version = function(self)
	return self.__VERSION__
end

get.author = function(self)
	return self.__AUTHOR__
end

return Candle()