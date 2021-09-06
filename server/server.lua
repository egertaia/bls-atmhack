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

RegisterServerEvent("wrp-atmhack:hack-success")
AddEventHandler("wrp-atmhack:hack-success", function(progressPercentage)
    local src = source
    local user = exports["wrp-base"]:getModule("Player"):GetUser(src)
    local moneyToGive = progressPercentage / 100 * math.random(EGERT.MinMoney, EGERT.MaxMoney)

    user:addMoney(moneyToGive)
    TriggerClientEvent("DoLongHudText", src, string.format( "Sa varastasid masinast kokku $%d.", moneyToGive), 1)
end)

RegisterNetEvent("wrp-atmhack:server:attempt-hack")
AddEventHandler("wrp-atmhack:server:attempt-hack", function()
    local src = source
    local userCoords = GetEntityCoords(src)

    local isNear = isNearSearchedLocation(userCoords)
    if (isNear) then
        TriggerClientEvent("DoLongHudText", src, "Seda masinat on alles hiljuti tühjendatud.", 2)
    else
        TriggerClientEvent("wrp-atmhack:start", src)
        table.insert(robbedLocations, userCoords)
    end
end)

