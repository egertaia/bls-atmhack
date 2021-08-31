SECOND = 1000
MINUTE = 60000
RANDOM_HACKINGDEVICE = "RANDOM"

local robbed = false

local function nearATM()
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)

    for _, search in pairs(BLSE.atms) do
        local model = GetHashKey(search)
        entity = GetClosestObjectOfType(playerloc['x'], playerloc['y', playerloc['z'], 2.5, model, false, false, false)
        if entity ~= 0 then
            return true
        end
    end
end

local function hackCallback(result)
    if (result) then
        TriggerEvent("bls-atmhack:collecting-money")
        robbed = true;
        Citizen.Wait(math.random(BLSE.HackSuccessMinTimeout, BLSE.HackSuccessMaxTimeout) * MINUTE)
        robbed = false

    else
        TriggerEvent('DoLongHudText', 'Süsteemiühendus terminaliga katkes. Proovi hiljem uuesti', 1)
        robbed = true;
        Citizen.Wait(math.random(BLSE.HackFailureMinTimeout, BLSE.HackFailureMaxTimeout) * MINUTE)
        robbed = false
    end
end

RegisterNetEvent("bls-atmhack:start")
AddEventHandler("bls-atmhack:start", function()
    if (exports["bls-inventory"]:hasEnoughOfItem("creditcard", 1, true)) then

        if not robbed and nearATM() then
            local player = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(player, false)
            local playerPed = GetPlayerPed(-1)


            -- TODO: USE PROPER DISPATCH
            TriggerEvent("alert:noPedCheck", "storeRobbery")
            
            TriggerEvent("bls-atmhack:connecting", playerPed)
            local jamCreditCardProgress = exports["bls-taskbar"]:taskBar(10 * SECOND, 'Valmistad masinat ette häkkimiseks', false, false, playerVeh)
            
            if (jamCreditCardProgress == 100) then
                ClearPedTasks(playerPed)
                TriggerEvent("bls-hackingdevices:start-hacking", RANDOM_HACKINGDEVICE, RANDOM_HACKINGDEVICE, math.random(BLSE.HackDurationMin, BLSE.HackDurationMax), hackCallback)
            else
                ClearPedTasks(playerPed)
            end

        else
            TriggerEvent('DoLongHudText', 'Sa ei märka ühtegi kohta kuhu krediitkaarti torgata.', 1)
        end

    else
        TriggerEvent('DoLongHudText', 'Sul ei ole ühtegi krediitkaarti.', 1)
    end
    
end)

RegisterNetEvent("bls-atmhack:connecting")
AddEventHandler("bls-atmhack:connecting", function(playerPed)
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 50, 0, false, false, false)
end)

RegisterNetEvent("bls-atmhack:collecting-money")
AddEventHandler("bls-atmhack:collecting-money", function()
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    while (not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash")) do
        Citizen.Wait(0)
    end
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    local playerPed = GetPlayerPed(-1)

    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@grab_cash", "grab", 8.0, -8.0, -1, 50, 0, false, false, false)

    local collectingMoneyProgress = exports["bls-taskbar"]:taskBar(10 * SECOND, 'Kogud masinast väljuvaid rahapakke', false, false, playerVeh)
    ClearPedTasks(playerPed)
    TriggerServerEvent("bls-atmhack:hack-success", collectingMoneyProgress);

end)