ESX = exports['es_extended']:getSharedObject()

AddEventHandler('esx:onPlayerDeath', function (data)
    ESX.TriggerServerCallback('alen_revive:getConnectedEMS', function (amount)
        if amount < Config.ServiceCount then
            if Config.feeAfterRevive then
                TriggerServerEvent('alen_revive:feeAfterRevive')
                reviveUser(ped)
            else
                reviveUser(ped)
            end
        end
    end)
end)

function reviveUser(ped)
   local playerPed = PlayerPedId()
   local coords = GetEntityCoords(playerPed)

   TriggerServerEvent('alen_revive:setDeathStatus', false)

   Citizen.CreateThread(function ()
    DoScreenFadeOut(240000)

    while not IsScreenFadedOut() do
        Citizen.Wait(50)
    end

    local formattedCoords = {
        ESX.Math.Round(coords.x, 1),
        ESX.Math.Round(coords.y, 1),
        ESX.Math.Round(coords.z, 1)
    }

    ESX.SetPlayerData('lastPosition', formattedCoords)

    TriggerServerEvent('esx:updateLastPosition', formattedCoords)

    RespawnPed(playerPed, formattedCoords, 0.0)

    AnimpostfxStop('DeathFailOut')
    DoScreenFadeIn(800)
    TriggerScreenblurFadeIn(0)
   end)
end

function RespawnPed(ped, coords, heading)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)

    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('playerSpawned')
end