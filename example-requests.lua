nextId = 0

HttpRequests["/notes"] =  { 
    GET = function(request) 
        response = {}
        response.status = 200
        response.content = { 

        }
        if request.id ~= nil then
            if file.open(request.id .. ".note") ~= nil then
                record = json.decode(file.read())
                file.close()
                response.content.text = record.content
            else
                response.status = 404
                response.content = nil
            end
        else
            response.content.notes = {}
            
            local fileListing  = file.list()
            for name, size in pairs(fileListing) do
                if string.sub(name,-5)==".note" then
                    response.content.notes[string.sub(name, 1, string.len(name) - 5)] = { size = size }
                end
            end
        end
        
        return response
    end,
    POST = function(request) 
        print(request.content.text)
        print(node.heap())
        collectgarbage()
        collectgarbage()
        print(node.heap())
        
        response = {}
    
        print(request.content.text)
        local fileContent = { content =  request.content.text }
        file.open(nextId .. ".note", "w")
        file.write(json.encode(fileContent))
        file.close()
        response.headers = { Location = "/notes/" .. nextId }
        response.status = 201
        nextId = nextId + 1

        return response
    end,
}
