
local json = require "cjson"

function starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

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
        print("Confused. :(")
        conn:send("HTTP/1.1 500 CONFUSED")
      end
      print("Method: " .. request.method .. ", URL: " .. request.url)
      if HttpRequests[request.url] ~= nil then
        if HttpRequests[request.url][request.method] ~= nil then
            response = HttpRequests[request.url][request.method]()
            conn:send("HTTP/1.1 " .. response.status .. " OK\n\n" .. json.encode(response.content))
        else
            conn:send("HTTP/1.1 405 Method not supported\n\r\n\r Method not supported. :(" .. request.url)
        end
      else 
        conn:send("HTTP/1.1 404 Not Found\n\r\n\r The resource has not been found. :(" .. request.url)
      end
      conn:close()
    end)
end)   
