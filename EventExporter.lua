-- Idan's event trace exporter, mostly meant for debugging event scripts

local EventTracerData = EventTracerData or {}
local eventLogging = false
local blacklistEvents = {
--    ["PLAYER_STARTED_MOVING"] = true,
}

frame = CreateFrame('Frame');
frame:RegisterAllEvents(); 
frame:SetScript('OnEvent', function(self, event, ...) 
	if not eventLogging then return else 
		if blacklistEvents[event] then return else
			if (event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT") then 
			   --local timestamp = date("%Y-%m-%d %H:%M:%S")
			   --local eventData = {timestamp = timestamp, event = event, args = {...}}
			   EventTracerData[event] = {CombatLogGetCurrentEventInfo()};
			   --print(event, CombatLogGetCurrentEventInfo()); 	   
			elseif event == "COMBAT_TEXT_UPDATE" then	
			   EventTracerData[event] = {GetCurrentCombatTextEventInfo()};
			   --print(event, GetCurrentCombatTextEventInfo()); 
			else
				EventTracerData[event] = {...};
				--print(event, ...); 
			   --table.insert(EventTracerData, eventData)
			end
		end
	end
end);

SLASH_EVENTEXPORTER1 = "/et"
SLASH_EVENTEXPORTER2 = "/ete"
SlashCmdList["EVENTEXPORTER"] = function(msg)
    if msg == "on" then
		eventLogging = true
		print("Event logging started.")
    elseif msg == "off" then
        eventLogging = false
        print("Event logging stopped.")
	elseif msg == "wipe" then
        wipe(EventTracerData)
        print("Event data cleared.")
	elseif msg == "show" then
        ShowEventDataWindow()
	elseif msg == "status" then
		if eventLogging == true then
			print("Event data collection is on.")
		else 
			print("Event data collection is off.")
		end
    else
        print("Usage: /ete on - Enable event data collection")
		print("Usage: /ete off - Disable event data collection")
		print("Usage: /ete status - Data collection status")
        print("Usage: /ete clear - Clear saved event data")
    end
end

