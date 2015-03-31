HttpRequests["/"] =  { 
    GET = function(request) 
        response = {}
        response.status = 200
        response.content = { fred = "Hello" }
        return response
    end
    
}

HttpRequests["/test.txt"] = { GET = function(request)
    response = {}
    response.status = 200
    response.content = { test = "Hello" }
    return response
    end
}

HttpRequests["/thingie"] = { POST = function(request)
        print("test!")
    end
}