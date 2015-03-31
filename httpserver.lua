
local json = require "cjson"

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
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

 
srv=net.createServer(net.TCP)
  srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
      request = {}
      httpRequest = mysplit(payload, "\r\n")
      i = (httpRequest[1])
      if string.match(i, "HTTP") then
          splitUp = mysplit(i)
           
          request.method = (splitUp[1])
          request.url = (splitUp[2])
          request.protocal = (splitUp[3])
      else
        sendResponse(conn, {
            status = 500,
            content = { error = "Confused by request. :("}
        });
        return;
      end
      print("Method: " .. request.method .. ", URL: " .. request.url)
      if HttpRequests[request.url] ~= nil then
        if HttpRequests[request.url][request.method] ~= nil then
            response = HttpRequests[request.url][request.method]()
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
    end)
end)   
