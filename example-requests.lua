HttpRequests["/"] =  { 
    GET = function(request) 
        print("HELLO ALL")
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
    end
}

HttpRequests["/status"] =  { 
    GET = function(request) 
        response = {}
        response.status = 200
        response.content = { 
            heap = node.heap(),
            chipid = node.chipid(),
            flashid = node.flashid(),
            wifi = {
                mac = wifi.sta.getmac(),
                ip = wifi.sta.getip(),
                status = wifi.sta.status()
            }
        }
        return response
    end
}

HttpRequests["/temp"] =  { 
    GET = function(request) 
        t=require("ds18b20")
        t.setup(9)
        addrs=t.addrs()
        -- Total DS18B20 numbers, assume it is 2
        print(table.getn(addrs))
        -- The first DS18B20
        print(t.read(addrs[1],t.C))
        print(t.read(addrs[1],t.F))
        print(t.read(addrs[1],t.K))
        -- The second DS18B20
        print(t.read(addrs[2],t.C))
        print(t.read(addrs[2],t.F))
        print(t.read(addrs[2],t.K))
        -- Just read
        print(t.read())
        -- Just read as centigrade
        print(t.read(nil,t.C))
        -- Don't forget to release it after use
        t = nil
        ds18b20 = nil
        package.loaded["ds18b20"]=nil
    
        response = {}
        response.status = 200
        response.content = { 
            heap = node.heap(),
            chipid = node.chipid(),
            flashid = node.flashid(),
            wifi = {
                mac = wifi.sta.getmac(),
                ip = wifi.sta.getip(),
                status = wifi.sta.status()
            }
        }
        return response
    end
}