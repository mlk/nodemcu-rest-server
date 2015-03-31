
HttpRequests = {}

HttpRequests["/"] = {}

HttpRequests["/"]["GET"] = function() 
    response = {}
    response.status = 200
    response.content = { fred = "Hello" }
    return response
end

HttpRequests["/test.txt"] = { GET = function()
    response = {}
    response.status = 200
    response.content = { test = "Hello" }
    return response
    end
}

HttpRequests["/thingie"] = { POST = function()
        print("test!")
    end
}

dofile("wifi.lua")
setupWifiMode( function() 
    dofile("httpserver.lua")
end)

