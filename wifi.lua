function setupWifiMode(action)
    local json = require "cjson"
    file.open("wifi_settings.json","r")
    theSettings = file.read()
    settings = json.decode(theSettings)
    file.close()
    
    print("set up wifi mode")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(settings.sid,settings.password)
    --here SSID and PassWord should be modified according your wireless router
    wifi.sta.connect()
    tmr.alarm(1, 1000, 1, function()
        if wifi.sta.getip()== nil then
            print("IP unavaiable, Waiting...")
        else
            tmr.stop(1)
            print("Config done, IP is "..wifi.sta.getip())
            action()
        end
    end) 
end