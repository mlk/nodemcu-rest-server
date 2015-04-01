function isempty(s)
  return s == nil or s == ''
end

function sendResponse(conn, response) 
    reponseNiceName = "unknown"
    
    if response.status == nil then
        response.status = 200
        reponseNiceName = "OK"
    end
        
    if response.headers == nil then
        response.headers = {}
    end
    
    conn:send("HTTP/1.1 " .. response.status .. " " .. reponseNiceName .. " \n")
    foundContentType = false;
    for k,v in pairs(response.headers) do 
         conn:send(k .. ":" .. v .. "\n")
         if k == "Content-Type" then
            foundContentType = true
         end
    end
    if not foundContentType then
        conn:send("Content-Type:application/json\n\n")
        if response.content ~= nil then
            conn:send(json.encode(response.content))
        end
    else
        conn:send(response.content)
        conn:send(json.encode(response.content))
    end
    response = nil
end

function elSplit( value, inSplitPattern, outResults )
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( value, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( value, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( value, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( value, theStart ) )
   return outResults
end

function createRequest(payload)
    local request = {}
    
    local splitPayload = elSplit(payload, "\r\n\r\n")
    local httpRequest = elSplit((splitPayload[1]), "\r\n")
    if not isempty((splitPayload[2])) then 
        request.content = json.decode((splitPayload[2]))
    end
    
    local splitUp = elSplit((httpRequest[1]), "%s+")
    
    request.method = (splitUp[1])
    request.path = (splitUp[2])
    request.protocal = (splitUp[3])

    local pathParts = elSplit(request.path, "/")
    local maybeId = tonumber((pathParts[table.getn(pathParts)]))

    if maybeId ~= nil then 
        request.fullPath = request.url
        request.path = string.sub(request.fullPath, 1, string.len(request.fullPath) - string.len("" .. maybeId))
        request.id = maybeId
    end
    
    --request.headers = {}
    --table.remove(httpRequest, 1)
    --for idx, line in ipairs(httpRequest) do
        --local header = elSplit(line, ":")
        --local name = (header[1])
        --local value = (header[2]) 
        --request.headers[name] = value
        --header = nil
        --name = nil
        --value = nil
    --end
    print(node.heap())
    httpRequest = nil
    splitUp = nil
    splitPayload = nil
    maybeId = nil
    collectgarbage()
    print(node.heap())
    return request
end

srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
        print("Got something...")

        local request = createRequest(payload)

        print("Method: " .. request.method .. " Location: " .. request.path)
        
        if HttpRequests[request.path] ~= nil then
            if HttpRequests[request.path][request.method] ~= nil then
                print("Executing code")
                local response = HttpRequests[request.path][request.method](request)
                sendResponse(conn, response)
                response = nil
            else
                sendResponse(conn, {
                    status = 405,
                    content = { error = "Method not supported for URL", path = request.path}
                });
            end
        else
            if file.open(string.sub(request.path, 2)) ~= nil then
                conn:send("HTTP/1.1 200 OK\n")
                conn:send("Content-Type: text/html\n\n")
                local line = file.readline()
                while line ~= nil do
                    conn:send(line)
                    line = file.readline()
                end
                file.close()
            else
                sendResponse(conn, {
                    status = 404,
                    content = { error = "File not found", url = request.path}
                })
            end
        end
        conn:close()
        request = nil
        collectgarbage()
    end)
end)   
