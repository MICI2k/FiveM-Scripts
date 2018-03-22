-- TUNNEL AND PROXY
cfg = {}
vRPhk = {}
Tunnel.bindInterface("vrp_hotkeys",vRPhk)
vRPserver = Tunnel.getInterface("vRP","vrp_hotkeys")
HKserver = Tunnel.getInterface("vrp_hotkeys","vrp_hotkeys")
vRP = Proxy.getInterface("vRP")

-- GLOBAL VARIABLES
called = 0

-- YOU ARE ON A CLIENT SCRIPT ( Just reminding you ;) )
-- Keys IDs can be found at https://wiki.fivem.net/wiki/Controls


-- Hotkeys Configuration: cfg.hotkeys = {[Key] = {group = 1, pressed = function() end, released = function() end},}
cfg.hotkeys = {
  [46] = {
    --E call/skip emergency
    group = 0, 
	pressed = function() 
	  if vRP.isInComa({}) then
	    if called == 0 then	
	    HKserver.canSkipComa({},function(skipper)
		    if skipper then
		      HKserver.docsOnline({},function(docs)
		        if docs == 0 then
					TriggerEvent('htk:_T')
			    else
					called = 30
					local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
					HKserver.helpComa({x,y,z})
					Citizen.Wait(1000)
			    end
			  end)
            end
		  end)
		else
		  vRP.notify({"~r~You already called the ambulance."})
		end
	  end
	end,
	released = function()
	  --Do nothing on release because it's toggle.
	end,
  },
    [213] = {
    --home on numberpad toggle User List
    group = 0, 
	pressed = function() 
	  HKserver.openUserList({})
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
}

local InTimer = false
RegisterNetEvent('htk:_T') 
AddEventHandler('htk:_T', function() 
	local _t = 60
	if InTimer then return end
	InTimer = true
	Citizen.CreateThread(function() 
		while true do Wait(1)
			if _t <= 0 then
				return
			end
			_dT(0.5,0.8, 1.0,4,"Respawning in: "..(_t), 255,255,255, true)
		end
		return
	end) 
	Citizen.CreateThread(function() 
		while true do Wait(1000)
			_t = _t - 1
			if _t <= 0 then
			vRP.killComa({})
				return
			end
		end
		InTimer = false
		return
	end) 
end)

function _dT(x,y,scale,font,text,r,g,b,outline)
if r == nil then r,g,b = 255,255,255 end
Citizen.InvokeNative(0x4E096588B13FFECA,0)
SetTextFont(font) SetTextProportional(0)
SetTextScale(scale, scale) SetTextColour(r,g,b,255)
if outline == true or outline == nil then
SetTextDropShadow(0,0,0,0,255) SetTextEdge(2,0,0,0,255)
SetTextDropShadow() SetTextOutline() end
SetTextEntry("STRING") AddTextComponentString(text)
DrawText(x,y) end