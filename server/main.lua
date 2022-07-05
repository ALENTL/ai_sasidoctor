ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('alen_revive:getConnectedEMS', function ()
    local xplayers = ESX.GetPlayers()
    local amount = 0

    for i = 1, #xplayers, 1 do
        local xplayer = ESX.GetPlayerFromID(xplayers[i])
        if xplayer.job.name == 'ambulance' then
            amount = amount + 1
        end
    end
    cb(amount)
end)

RegisterServerEvent('alen_revive:setDeathStatus')
AddEventHandler('alen_revive:setDeathStatus', function (isDead)
    local identifier = GetPlayerIdentifiers(source)[1]

    if type(isDead) ~= 'boolean' then
        return
    end

    MySQL.update('UPDATE users SET is_dead = @isDead WHERE identifier = @identifer', {
        ['@identifer'] = identifier,
        ['@isDead'] = isDead
    })
end)

RegisterServerEvent('alen_revive:feeAfterRevive')
AddEventHandler('alen_revive:feeAfterRevive', function ()
    local xPlayer = ESX.GetPlayerFromID(source)
    xPlayer.removeAccountMoney('bank', Config.Fee)

    if Config.okokNotify == 'true' then
        TriggerClientEvent('okokNotify:alert', source, "You will be revived", "Dr Johnny Sins will be recieving you within 4 minutes", 5000, 'success')
    else
        xPlayer.showNotification("~r~you have paid a revive fee of~g~Revive.".. Config.Fee)
    end
end)