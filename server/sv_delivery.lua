local drivers = {}

RegisterServerEvent("rup-delivery:delivery_duty")
AddEventHandler("rup-delivery:delivery_duty", function(onDuty)
    local src = source
    if onDuty then
        drivers[src] = GetGameTimer()
    else
        drivers[src] = nil
    end
end)

RegisterServerEvent("rup-delivery:delivery_complete")
AddEventHandler("rup-delivery:delivery_complete", function()
    local src = source
    if Config.Framework == 'qb' then
        local QBCore = exports["qb-core"]:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if drivers[src] then
            if drivers[src] < GetGameTimer() then
                drivers[src] = GetGameTimer() + 5000
                local payoutIndex = math.random(#Config.Payouts)
                local payoutAmount = Config.Payouts[payoutIndex]()
                Player.Functions.AddMoney("bank", payoutAmount, "Delivery Job")
            end
        end
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if drivers[src] then
            if drivers[src] < GetGameTimer() then
                drivers[src] = GetGameTimer() + 5000
                local payoutIndex = math.random(#Config.Payouts)
                local payoutAmount = Config.Payouts[payoutIndex]()
                xPlayer.addAccountMoney('bank', payoutAmount)
            end
        end
    elseif Config.Framework == 'nd' then
        local NDCore = exports["ND_Core"]
        local Player = NDCore.getPlayer(src)
        if drivers[src] then
            if drivers[src] < GetGameTimer() then
                drivers[src] = GetGameTimer() + 5000
                local payoutIndex = math.random(#Config.Payouts)
                local payoutAmount = Config.Payouts[payoutIndex]()
                Player.addMoney("bank", payoutAmount, "Delivery Job")
            end
        end
    elseif Config.Framework == 'qbx' then
        local Player = exports.qbx_core:GetPlayer(source)
        if drivers[src] then
            if drivers[src] < GetGameTimer() then
                drivers[src] = GetGameTimer() + 5000
                local payoutIndex = math.random(#Config.Payouts)
                local payoutAmount = Config.Payouts[payoutIndex]()
                Player.Functions.AddMoney("bank", payoutAmount, "Delivery Job")
            end
        end
    else
        if Config.Debug then
            print("DEBUG - Not on delivery duty")
        end
    end
end)

RegisterServerEvent("rup-delivery:delivery_getroutes")
AddEventHandler("rup-delivery:delivery_getroutes", function()
    local src = source
    TriggerClientEvent("rup-delivery:delivery_routes", src, Config.DropOffs)
end)
