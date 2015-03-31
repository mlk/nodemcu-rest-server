HttpRequests = {}

dofile("wifi.lua")
setupWifiMode( function() 
    dofile("httpserver.lua")
    dofile("example-requests.lua")
end)

