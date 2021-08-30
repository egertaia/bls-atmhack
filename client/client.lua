local robbed = false

function nearATM()
    local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

    for _, search in pairs(BLSEGERT.atms) do
        local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
        if distance <= 2.5 then
            return true
        end
    end
end

local function hackCallback(result)
    if (result) then
        TriggerServerEvent("bls-atmhack:hack-success");
        robbed = true;
        Citizen.Wait(1200000)
        robbed = false
        --mony
    else
        TriggerEvent('DoLongHudText', 'Süsteemiühendus terminaliga katkes. Proovi hiljem uuesti', 1)
        robbed = true;
        Citizen.Wait(600000)
        robbed = false
    end
end

RegisterNetEvent("bls-atmhack:start")
AddEventHandler("bls-atmhack:start", function()
    if (exports["bls-inventory"]:hasEnoughOfItem("creditcard", 1, true)) then

        if not robbed and nearATM() then
            local player = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(player, false)

            local jamCreditCardProgress = exports["bls-taskbar"]:taskBar(10000, 'Valmistad masinat ette häkkimiseks', false, false, playerVeh)
            TriggerEvent("bls-atmhack:connecting")
            if (jamCreditCardProgress == 100) then
                -- dispatch a police now please
                -- dispatch hackerman
                TriggerEvent("bls-hackingdevices:start-hacking", "RANDOM", "RANDOM", 20, hackCallback)

            end

        else
            TriggerEvent('DoLongHudText', 'Sa ei märka ühtegi kohta kuhu krediitkaarti torgata', 1)
        end

    else
        TriggerEvent('DoLongHudText', 'Sul ei ole ühtegi krediitkaarti', 1)
    end
    
end)

RegisterNetEvent("bls-atmhack:connecting")
AddEventHandler("bls-atmhack:connecting", function()
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(10000)
    ClearPedTasks(GetPlayerPed(-1))
end)