json = require "cjson"

function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

HttpRequests = {}

local simplewifisettings = require 'simplewificonfig'

simplewifisettings.setupWifiMode( function() 
    dofile("httpserver.lua")
    dofile("example-requests.lua")
    unrequire("simplewificonfig")
end)
   