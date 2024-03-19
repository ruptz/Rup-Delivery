local QBCore = exports["qb-core"]:GetCoreObject()

local drivers = {}

RegisterServerEvent("rup-delivery:delivery_duty")
AddEventHandler("rup-delivery:delivery_duty", function(onDuty)
    local client = source
    if onDuty then
        drivers[client] = GetGameTimer()
    else
        drivers[client] = nil
    end
end)

RegisterServerEvent("rup-delivery:delivery_complete")
AddEventHandler("rup-delivery:delivery_complete", function()
    local client = source
    local Player = QBCore.Functions.GetPlayer(source)
    if drivers[client] then
        if drivers[client] < GetGameTimer() then
            print("DEBUG - Paying for delivery.")
            drivers[client] = GetGameTimer() + 5000
            local payoutIndex = math.random(#Config.Payouts)
            local payoutAmount = Config.Payouts[payoutIndex]()
            Player.Functions.AddMoney("bank", payoutAmount, "Delivery Job")
        else
            print("DEBUG - Was recently paid out. Can't pay.")
        end
    else
        print("DEBUG - rup-delivery:delivery_complete - Not on delivery duty")
    end
end)

RegisterServerEvent("rup-delivery:delivery_getroutes")
AddEventHandler("rup-delivery:delivery_getroutes", function()
    local ply = source
    TriggerClientEvent("rup-delivery:delivery_routes", ply, Config.DropOffs)
end)
