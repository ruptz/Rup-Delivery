local dTruck = nil
local destBlip = nil
local hasPackage = false
local box = nil
local firstDest = true
local isOnDeliveryDuty = false
local myJobPoint = 1
local drops = {}

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ChatNotification(icon, title, subtitle, message)
    if not icon then
        icon = "CHAR_LESTER"
    end
    if not title then
        title = ""
    end
    if not subtitle then
        subtitle = ""
    end
    if not message then
        message = ""
    end

    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage(icon, icon, false, 2, title, subtitle, "")
    DrawNotification(false, true)
    PlaySoundFrontend(-1, "GOON_PAID_SMALL", "GTAO_Boss_Goons_FM_SoundSet", 0)

    return true
end

Citizen.CreateThread(function()
    for _, b in pairs(Config.JobLoc) do
        local blip = AddBlipForCoord(b.v)
        SetBlipSprite(blip, 351)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 43)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Job")
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("rup-delivery:delivery_routes")
AddEventHandler("rup-delivery:delivery_routes", function(places)
    local myPos = GetEntityCoords(PlayerPedId())
    drops = {}
    for k, v in pairs(places) do
        local vec = vector3(v["x"], v["y"], v["z"])
        local dist = #(myPos - vec)
        if dist < 4000 then
            table.insert(drops, vec)
        end
    end

    PickDestination()
end)

function SetDestination(d)
    SetNewWaypoint(d.x, d.y)
    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end
    destBlip = AddBlipForCoord(d.x, d.y, 0.0)
    SetBlipSprite(destBlip, 66)
    SetBlipDisplay(destBlip, 2)
    SetBlipScale(destBlip, 1.0)
    SetBlipColour(destBlip, 10)
    SetBlipAsShortRange(destBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery")
    EndTextCommandSetBlipName(destBlip)
end

function FinishedRoute()
    SetWaypointOff()
    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end
end

function NextDestination()
    if #drops > 0 then
        PickDestination()
    else
        FinishedRoute()
    end
end

function compare(a, b)
    return a.d < b.d
end

function RecalculateDistance()
    local temp = drops
    drops = {}
    local myPos = GetEntityCoords(PlayerPedId())
    for k, v in pairs(temp) do
        local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, v["x"], v["y"], v["z"])
        table.insert(drops, {x = v["x"], y = v["y"], z = v["z"], d = dist})
    end
    table.sort(drops, compare)
end

function PickDestination()
    if not firstDest then
        RecalculateDistance()
    end
    Citizen.CreateThread(function()
        local atDest = false
        local dropNum = 1
        if firstDest then
            dropNum = math.random(#drops)
            firstDest = false
        end
        local destination = table.remove(drops, dropNum)
        SetWaypointOff()
        SetDestination(destination)
        while not atDest do
            Citizen.Wait(0)
            DrawMarker(1, destination.x, destination.y, destination.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.25, 0, 255, 0, 90, false, false, 1.0, false)
            if not IsPedInVehicle(PlayerPedId(), dTruck) then
                if not hasPackage then
                    local offset = GetOffsetFromEntityInWorldCoords(dTruck, 0.0, -4.0, 0.0)
                    DrawMarker(1, offset.x, offset.y, offset.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.20, 1.20, 1.25, 255, 180, 0, 120, false, false, 1.0, false)
                    if Vdist2(GetEntityCoords(PlayerPedId()), offset.x, offset.y, offset.z) < 2.0 then
                        local ped = PlayerPedId()
                        alert("Press ~INPUT_CONTEXT~ to pick up package.")
                        if IsControlJustPressed(1, 38) then
                            box = CreateObject(GetHashKey("prop_cs_box_clothes"), GetEntityCoords(ped), true, false, true)
                            AttachEntityToEntity(box, ped, GetPedBoneIndex(ped, 18905), 0.3, 0.0, 0.0, 0.0, 200.0, 40.0, false, false, false, true, 0.0, true)
                            hasPackage = true
                        end
                    end
                else
                    if Vdist2(GetEntityCoords(PlayerPedId()), destination.x, destination.y, destination.z) < 1.2 then
                        alert("Press ~INPUT_CONTEXT~ to drop package.")
                        if IsControlJustPressed(1, 38) then
                            DropPackage()
                            ChatNotification("CHAR_JIMMY_BOSTON", "Post OP", "Delivery", "Nice job, Head to next delivery.")
                            TriggerServerEvent("rup-delivery:delivery_complete")
                            atDest = true
                        end
                    end
                end
            end
            if not isOnDeliveryDuty then
                atDest = true
            end
        end
        NextDestination()
    end)
end

function DropPackage()
    if hasPackage then
        if box then
            DeleteObject(box)
        end
        
        local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.32, 0.0, -0.07)
        local tempBox = CreateObject(GetHashKey("prop_cs_box_clothes"), offset.x, offset.y, offset.z, true, false, true)

        ActivatePhysics(tempBox)
        FreezeEntityPosition(tempBox, false)
        hasPackage = false
        
        Citizen.CreateThread(function()
            Citizen.Wait(30000)
            DeleteObject(tempBox)
        end)
    end
end

function StartDeliveryJob(ped, sNum)
    DoScreenFadeOut(400)
    Citizen.Wait(600)

    if dTruck then
        TaskLeaveVehicle(ped, dTruck, 16)
        DeleteVehicle(dTruck)
    end

    local veh = GetHashKey(Config.JobLoc[sNum].veh)

    RequestModel(veh)
    while not HasModelLoaded(veh) do
        Wait(1)
    end

    dTruck = CreateVehicle(veh, Config.Spawns[sNum].x, Config.Spawns[sNum].y, Config.Spawns[sNum].z, Config.Spawns[sNum].w, true, false)

    Citizen.Wait(100)
    DecorRegister("OwnerId", 3)
    DecorSetInt(dTruck, "OwnerId", GetPlayerServerId(PlayerId()))
    SetVehicleOnGroundProperly(dTruck)
    SetVehicleColours(dTruck, 112, 83)
    SetModelAsNoLongerNeeded(veh)
    SetEntityAsMissionEntity(dTruck, true, true)
    SetPedIntoVehicle(ped, dTruck, -1)
    SetVehicleDoorsLocked(dTruck, 1)

    isOnDeliveryDuty = true

    TriggerServerEvent("rup-delivery:delivery_getroutes")
    ChatNotification("CHAR_JIMMY_BOSTON", "Post OP", "Delivery", "Head out to your route and get to work.")

    Citizen.CreateThread(function()
        local warned = false
        while isOnDeliveryDuty do
            Citizen.Wait(0)
            if hasPackage then
                local ped = PlayerPedId()
                if IsPlayerFreeAiming(ped) then
                    DropPackage()
                elseif IsControlJustPressed(1, 24) or IsControlJustPressed(1, 25) then -- Attack/Aim
                    if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
                        DropPackage()
                    end
                elseif IsControlJustPressed(1, 23) or IsControlJustPressed(1, 45) then -- Enter Vehicle/Reload
                    if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
                        DropPackage()
                    end
                elseif IsPedInAnyVehicle(ped, true) then
                    DropPackage()
                end
            else
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(dTruck)) > 80.0 then
                    DelTruckGoOffDuty()
                end
            end
        end
    end)

    TriggerServerEvent("rup-delivery:delivery_duty", true)
    myJobPoint = sNum

    DoScreenFadeIn(1000)
    Citizen.Wait(400)
end


function DelTruckGoOffDuty()
    isOnDeliveryDuty = false

    if dTruck then
        if IsPedInAnyVehicle(PlayerPedId()) then
            TaskLeaveVehicle(PlayerPedId(), dTruck, 16)
            Citizen.Wait(100)
        end
        DeleteVehicle(dTruck)
        dTruck = nil
    end

    if box or hasPackage then
        if box then
            DeleteObject(box)
        end
        hasPackage = false
    end

    drops = {}
    firstDest = true
    SetWaypointOff()
    ChatNotification("CHAR_JIMMY_BOSTON", "Post OP", "Delivery", "See you next time.")

    TriggerServerEvent("rup-delivery:delivery_duty", false)
end

Citizen.CreateThread(function()
    DoScreenFadeIn(100)
    while true do
        Citizen.Wait(0)
        if not isOnDeliveryDuty then
            for k, p in pairs(Config.JobLoc) do
                DrawMarker(1, p.v.x, p.v.y, p.v.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.25, 3.25, 1.0, 0, 255, 0, 90, false, false, 1, false)
                DrawMarker(29, p.v.x, p.v.y, p.v.z + 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 180, 0, 90, false, false, 1, true)
                local ped = PlayerPedId()
                local myPos = GetEntityCoords(ped)
                local jDist = #(myPos - p.v)
                if jDist < 3.0 then
                    alert("Press ~INPUT_CONTEXT~ to go on duty.")
                    if IsControlJustPressed(1, 38) and not IsPedInAnyVehicle(ped) then
                        StartDeliveryJob(ped, k)
                    end
                end
            end
        else
            local myPos = GetEntityCoords(PlayerPedId())
            -- Check for ending duty
            for k, p in pairs(Config.JobLoc) do
                DrawMarker(1, p.v.x, p.v.y, p.v.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.25, 3.25, 1.0, 255, 0, 0, 90, false, false, 1, false)
                DrawMarker(29, p.v.x, p.v.y, p.v.z + 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 180, 0, 90, false, false, 1, true)
                if #(myPos - p.v) < 3.0 then
                    alert("Press ~INPUT_CONTEXT~ to go off duty.")
                    if IsControlJustPressed(1, 38) then
                        DelTruckGoOffDuty()
                    end
                end
            end
        end
    end
end)
