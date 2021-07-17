local holstered  = true
local blocked	 = false

local holsteredbig  = true
local blockedbig	 = false
local duffelbag = nil
local iswearing = false

local checkagain = false
local nocount = 0

Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(1000)
	    TriggerEvent('skinchanger:getSkin', function(skin)
		    duffelbag = skin['bags_1']
	    end)
	    Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("anim@heists@ornate_bank@grab_cash")
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped, false) then
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and GetVehiclePedIsTryingToEnter(ped) == 0 and not IsPedInParachuteFreeFall (ped) then
			if CheckWeapon(ped) then
				if holstered then
					holsteredbig = true
					blocked   = true
					SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
					TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) 					  
					Citizen.Wait(200)
					SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
					TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					holstered = false
					Citizen.Wait(400)
					ClearPedTasks(ped)
				else
					blocked = false
				end
			elseif CheckBigWeapon(ped) then
				if holsteredbig then
					if iswearing == true then
						holstered = true
						blockedbig   = true
						TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "intro", 8.0, 2.0, -1, 51, 2, 0, 0, 0 )
						Citizen.Wait(1600)
						ClearPedTasks(ped)
						holsteredbig = false
					else
						--TriggerEvent('esx:showNotification', Config.Notification)
						Notification()
						SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
					end
				else
					blockedbig = false
				end
			elseif not holstered then
				TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
				Citizen.Wait(500)
				TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) 
				Citizen.Wait(60)
				ClearPedTasks(ped)
				holstered = true
			elseif not holsteredbig then
				TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "outro", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
				Citizen.Wait(1500)
				ClearPedTasks(ped)
				holsteredbig = true
			end
		else
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		end
		else
			holstered = false
			holsteredbig = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if blocked then
				DisableControlAction(1, 25, true )
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(1, 23, true)
				DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
				DisablePlayerFiring(ped, true) -- Disable weapon firing
			end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if blockedbig then
				DisableControlAction(1, 25, true )
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(1, 23, true)
				DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
				DisablePlayerFiring(ped, true) -- Disable weapon firing
			end
	end
end)

function CheckBigWeapon(ped)
	for i = 1, #Config.BigWeapons do
		if GetHashKey(Config.BigWeapons[i]) == GetSelectedPedWeapon(ped) then
			    return true
		end
	end
	return false
end

function CheckWeapon(ped)
	for i = 1, #Config.Weapons do
		if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
			    return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _,bags in pairs(Config.Duffelbags) do
			if duffelbag == bags then
				iswearing = true
			else
				nocount = nocount + 1
				if nocount == #Config.Duffelbags then
					iswearing = false
				end
			end
		end
		nocount = 0
	end
end)

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end
