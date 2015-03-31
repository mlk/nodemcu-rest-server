function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end


HttpRequests = {}

local wifi = require 'simplewificonfig'

wifi.setupWifiMode( function() 
    print("Wifi set up" .. node.heap())
    dofile("httpserver.lua")
    print("HTTP set up" .. node.heap())
    dofile("example-requests.lua")
    print("requests set up" .. node.heap())
    unrequire("simplewificonfig")
end)

 