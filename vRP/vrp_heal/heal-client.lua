local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "NPC",
    menu_subtitle = "Categories",
    color_r = 0,
    color_g = 128,
    color_b = 255,
}

local medicped = {
  {type=4, hash=0xB353629E, x=-450.595703125, y=-339.66802978516, z=33.50, a=3374176},
  {type=4, hash=0xB353629E, x= 1152.6365966797, y= -1527.6695556641, z= 33.8459815979, a=3346124},
  {type=4, hash=0xB353629E, x=358.05541992188,y= -593.90008544922,z= 27.79235458374, a=3535235},
}

local medicpedpos = {
	{ ['x'] = -449.67, ['y'] = -340.83, ['z'] = 34.50 },
	{ ['x'] = 1151.21, ['y'] = -1529.62, ['z'] = 35.37},
	{ ['x'] = 358.05,  ['y'] = -593.90,  ['z'] = 27.79},
}

local hospital_location = {-449.67, -340.83, 34.50}
local hospital_location2 =  {1152.6365966797,-1527.6695556641,33.8459815979}
local hospital_location3 = {359.49423217773,-594.16876220703,28.645805358887}


function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

-- healing function
function heal2()
local ped = GetPlayerPed(-1)
SetEntityHealth(ped, 200)
end

Citizen.CreateThread(function()
  RequestModel(GetHashKey("s_m_m_paramedic_01"))
  while not HasModelLoaded(GetHashKey("s_m_m_paramedic_01")) do
    Wait(1)
  end

  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end
  
 	    -- Spawn the medic Ped
  for _, item in pairs(medicped) do
    medicmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    SetEntityHeading(medicmainped,280.0)
    FreezeEntityPosition(medicmainped, true)
	SetEntityInvincible(medicmainped, true)
	SetBlockingOfNonTemporaryEvents(medicmainped, true)
    TaskPlayAnim(medicmainped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

local talktoemsped = true
--EMS Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(medicpedpos) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 3)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with ~y~NPC")
				if(IsControlJustReleased(1, 38))then
						if talktoemsped then
						    Notify("~b~Welcome to the ~h~Hospital!")
						    Citizen.Wait(500)
							HospitalMenu()
							Menu.hidden = false
							talktoemsped = false
						else
							talktoemsped = true
						end
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function HospitalMenu()
	ClearMenu()
    options.menu_title = "Healing"
	Menu.addButton("~h~Healing","Heal",nil)
    Menu.addButton("Close","CloseMenu",nil) 
end

function Heal()
    ClearMenu()
    options.menu_title = "~r~Healing"
	Menu.addButton("~r~Heal ~h~yourself","heal2",nil)
    Menu.addButton("Return","HospitalMenu",nil) 
end

function CloseMenu()
		Menu.hidden = true
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--blip

Citizen.CreateThread(function()
	pos = hospital_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,80)
	SetBlipColour(blip,49)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Hospital')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)

Citizen.CreateThread(function()
	pos = hospital_location2
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,61)
	SetBlipColour(blip,49)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Healing Point')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)

Citizen.CreateThread(function()
	pos = hospital_location3
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,80)
	SetBlipColour(blip,49)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Hospital')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)