HttpRequests["/"] =  { 
    GET = function(request) 
        response = {}
        response.status = 200
        response.content = { 
            fred = "this is a test",
            two = {
                Test="fred",
                trueistrue=true
            }
        }
        return response
    end,
    POST = function(request) 
        response = {}
        if request.content.one == "one" then
            response.status = 200
            response.content = { 
                fred = "this is a test"
            }
        else 
            response.status = 400
            response.content = { 
                fred = "ye messed up"
            }
        end
        return response
    end
}

