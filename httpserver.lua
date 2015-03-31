local json = require "cjson"

function isempty(s)
  return s == nil or s == ''
end

function sendResponse(conn, response) 
    if response.status == nil then
        response.status = 200
    end
        
    if response.headers == nil then
        response.headers = {}
    end
    
    reponseNiceName = "unknown"
    
    conn:send("HTTP/1.1 " .. response.status .. " " .. reponseNiceName .. " \n")
    foundContentType = false;
    for k,v in pairs(response.headers) do 
         conn:send(k .. ":" .. v .. "\n")
         if k == "Content-Type" then
            foundContentType = true
         end
    end
    if not foundContentType then
        conn:send("Content-Type:application/json\n")
    end
    conn:send("\n")
    if response.content ~= nil then
        conn:send(json.encode(response.content))
    end
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

print("Creating WWW server")

srv=net.createServer(net.TCP)
  srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
      request = {}
      
      splitPayload = elSplit(payload, "\r\n\r\n")
      httpRequest = elSplit((splitPayload[1]), "\r\n")
      if not isempty((splitPayload[2])) then 
        print((splitPayload[2]))
        request.content = json.decode((splitPayload[2]))
      end
      
      payload = nil
      splitPayload[1] = nil      
      splitPayload[2] = nil
      collectgarbage()
      
      local splitUp = elSplit((httpRequest[1]), "%s+")
       
      request.method = (splitUp[1])
      request.url = (splitUp[2])
      request.protocal = (splitUp[3])
      splitUp = nil

      request.headers = {}
      table.remove(httpRequest, 1)
      for idx, line in ipairs(httpRequest) do
        local header = elSplit(line, ":")
        local name = (header[1])
        local value = (header[2]) 
        request.headers[name] = value
        header = nil
        name = nil
        value = nil
      end

      if HttpRequests[request.url] ~= nil then
        if HttpRequests[request.url][request.method] ~= nil then
            response = HttpRequests[request.url][request.method](request)
            sendResponse(conn, response)
        else
            sendResponse(conn, {
                status = 405,
                content = { error = "Method not supported for URL", url = request.url}
            });
        end
      else 
          sendResponse(conn, {
                status = 404,
                content = { error = "File not found", url = request.url}
            });
      end
      conn:close()
      request = nil
      collectgarbage()
      print("Request Processed" .. node.heap())
    end)
end)   
