-- if percentage is possible for taskbar, pass a percentageRate into this function
RegisterServerEvent("bls-atmhack:hack-success")
AddEventHandler("bls-atmhack:hack-success", function()
    -- if percentage is given in then the moneyToGive would become following
    -- local moneyToGive = math.floor(progressPercentage/100) * math.random(BLSE.MinMoney, BLSE.MaxMoney)
    local moneyToGive = math.random(BLSE.MinMoney, BLSE.MaxMoney)

    -- lisa mängjale raha
    -- lisa lahe tekst kuidas ta nüüd on rikas mees VIST JÄRGNEV
    -- TriggerClientEvent('DoLongHudText', playerId, 'Sa varastasid masinast kokku ' + moneyToGive, 1)

end)