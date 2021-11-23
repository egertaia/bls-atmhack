robbedLocations = {}

function isNearSearchedLocation(coords)
    for k, v in pairs(robbedLocations) do
        local distanceFromLocation = #(v - coords)
        if distanceFromLocation < 4 then
            return true
        end
    end

    return false
end

RegisterServerEvent("bls-atmhack:hack-success")
AddEventHandler("bls-atmhack:hack-success", function(progressPercentage)
    local src = source
    local user = exports["bls-base"]:getModule("Player"):GetUser(src)
    local userCoords = exports['bls-position']:getPlayerCoords(src)
    local moneyToGive = progressPercentage / 100 * math.random(BLSE.MinMoney, BLSE.MaxMoney)

    user:addMoney(moneyToGive)
    TriggerClientEvent("DoLongHudText", src, string.format( "Sa varastasid masinast kokku $%d.", moneyToGive), 1)
end)

RegisterNetEvent("bls-atmhack:server:attempt-hack")
AddEventHandler("bls-atmhack:server:attempt-hack", function()
    local src = source
    local userCoords = exports['bls-position']:getPlayerCoords(src)

    local isNear = isNearSearchedLocation(userCoords)
    if (isNear) then
        TriggerClientEvent("DoLongHudText", src, "Seda masinat on alles hiljuti tühjendatud.", 2)
    else
        TriggerClientEvent("bls-atmhack:start", src)
        table.insert(robbedLocations, userCoords)
    end
end)

