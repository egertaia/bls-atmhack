RegisterServerEvent("bls-atmhack:hack-success")
AddEventHandler("bls-atmhack:hack-success", function(progressPercentage)
    local src = source
    local user = exports["bls-base"]:getModule("Player"):GetUser(src)
    local moneyToGive = math.floor(progressPercentage/100) * math.random(BLSE.MinMoney, BLSE.MaxMoney)

    user:addMoney(moneyToGive)
    TriggerClientEvent('DoLongHudText', src, string.format( "Sa varastasid masinast kokku $%d.", moneyToGive), 1)

end)