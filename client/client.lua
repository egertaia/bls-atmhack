SECOND = 1000
MINUTE = 60000
RANDOM_HACKINGDEVICE = "RANDOM"

local robbed = false

local function nearATM()
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)

    for _, search in pairs(EGERT.atms) do
        local model = GetHashKey(search)
        entity = GetClosestObjectOfType(playerloc["x"], playerloc["y"], playerloc["z"], 2.5, model, false, false, false)
        if entity ~= 0 then
            return true
        end
    end
    return false
end

local function hackCallback(result)
    if (result) then
        TriggerEvent("wrp-atmhack:collecting-money")
    else
        SetPlayerControl(PlayerId(), 1, 1) -- unfroze
        TriggerEvent("DoLongHudText", "Süsteemiühendus terminaliga katkes. Proovi hiljem uuesti", 1)
    end
end

RegisterNetEvent("wrp-atmhack:client:attempt-hack")
AddEventHandler("wrp-atmhack:client:attempt-hack", function()
    if (exports["wrp-inventory"]:hasEnoughOfItem("securityred", 1, false)) then
        TriggerServerEvent("wrp-atmhack:server:attempt-hack")
    else
        TriggerEvent("DoLongHudText", "Sul ei ole ühtegi krediitkaarti.", 2)
    end
end)

RegisterNetEvent("wrp-atmhack:start")
AddEventHandler("wrp-atmhack:start", function()
    if (exports["wrp-inventory"]:hasEnoughOfItem("securityred", 1, false)) then
        if not robbed and nearATM() then
            TriggerEvent("inventory:removeItem", "securityred", 1)
            local player = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(player, false)
            local playerPed = GetPlayerPed(-1)

            -- TODO: USE PROPER DISPATCH
            TriggerEvent("alert:noPedCheck", "storeRobbery")
            
            TriggerEvent("wrp-atmhack:connecting", playerPed)
            local jamCreditCardProgress = exports["wrp-taskbar"]:taskBar(10 * SECOND, "Valmistad masinat ette häkkimiseks", false, false, playerVeh)
            
            if (jamCreditCardProgress == 100) then
                ClearPedTasks(playerPed)
                TriggerEvent("wrp-hackingdevices:start-hacking", RANDOM_HACKINGDEVICE, RANDOM_HACKINGDEVICE, math.random(EGERT.HackDurationMin, EGERT.HackDurationMax), hackCallback)
            else
                ClearPedTasks(playerPed)
                SetPlayerControl(PlayerId(), 1, 1) -- unfrozen
            end

        else
            TriggerEvent("DoLongHudText", "Sa ei märka ühtegi kohta kuhu krediitkaarti torgata.", 2)
        end

    else
        TriggerEvent("DoLongHudText", "Sul ei ole ühtegi krediitkaarti.", 2)
    end
    
end)

RegisterNetEvent("wrp-atmhack:connecting")
AddEventHandler("wrp-atmhack:connecting", function(playerPed)
    SetPlayerControl(PlayerId(), 0, 0) -- frozen
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 50, 0, false, false, false)
end)

RegisterNetEvent("wrp-atmhack:collecting-money")
AddEventHandler("wrp-atmhack:collecting-money", function()
    SetPlayerControl(PlayerId(), 0, 0) -- frozen
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    while (not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash")) do
        Citizen.Wait(0)
    end
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    local playerPed = GetPlayerPed(-1)

    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@grab_cash", "grab", 8.0, -8.0, -1, 50, 0, false, false, false)

    local collectingMoneyProgress = exports["wrp-taskbar"]:taskBar(10 * SECOND, "Kogud väljuvaid rahapakke", false, false, playerVeh)
    ClearPedTasks(playerPed)
    SetPlayerControl(PlayerId(), 1, 1) -- unfroze
    TriggerServerEvent("wrp-atmhack:hack-success", collectingMoneyProgress);

end)