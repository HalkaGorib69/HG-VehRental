local PlatNum = nil

local function Notify(header, des, ntype)
    lib.notify({ title = header, description = des, type = ntype })
end

local function SpawnRentalVeh(Veh, Price, Loc, Plate)
    local Data = lib.callback.await('server:HG-Rental:togglemoney', false, 'remove', Price)
    if Data then
        local fullPlate = Plate..""..math.random(1000, 9999)
        lib.requestModel(Veh)
        local SpawnVeh = CreateVehicle(Veh, Loc.x, Loc.y, Loc.z, Loc.w, true, false)
        SetVehicleNumberPlateText(SpawnVeh, fullPlate)
        SetVehicleEngineOn(SpawnVeh, true, true, true)
        SetVehicleOnGroundProperly(SpawnVeh)
        TaskWarpPedIntoVehicle(PlayerPedId(), SpawnVeh, -1)
        SetModelAsNoLongerNeeded(Veh)
        PlatNum = fullPlate
        Notify('Rental', 'You have rented a vehicle.', 'success')
    else
        Notify('Rental', 'You do not have enough money.', 'error')
        return
    end
end

local function trimPlate(plate)
    return string.gsub(plate, "^%s*(.-)%s*$", "%1")
end
local function ReturnRentalVeh()
    local Ped = PlayerPedId()
    local PedCoords = GetEntityCoords(Ped)
    local ReturnPrice = 0

    local closestVehicle, closestVehicleCoords = lib.getClosestVehicle(PedCoords, 10.0, true)
    if closestVehicle == nil then
        Notify('Rental', 'No vehicle found nearby.', 'error')
        return
    end

    local VehPlate = trimPlate(GetVehicleNumberPlateText(closestVehicle))
    local StoredPlate = trimPlate(PlatNum)
    if VehPlate ~= StoredPlate then
        Notify('Rental', 'This is not the vehicle you rented.', 'error')
        return
    end

    if Config.Rental.ReturnMoney then
        local vehicleModel = GetEntityModel(closestVehicle)
        for _, i in pairs(Config.Rental.Locations) do
            for k, v in pairs(i.Vehiclelist) do
                local vehicleHash = GetHashKey(k)
                if vehicleModel == vehicleHash then
                    ReturnPrice = v.Price
                    break
                end
            end
        end
    end

    if Config.Rental.ReturnMoney then
        local Data = lib.callback.await('server:HG-Rental:togglemoney', false, 'add', ReturnPrice)
        if Data then
            Notify('Rental', 'You have returned the vehicle and received a refund.', 'success')
        end
    else
        Notify('Rental', 'You have returned the vehicle.', 'success')
    end

    DeleteVehicle(closestVehicle)
    PlatNum = nil
end



local function OpenRentMenu(Vehiclelist, Loc, Plate)
    local AllOptions = {}
    if Config.Rental.ReturnMoney and PlatNum then
        AllOptions[#AllOptions+1] = {
            icon = 'fas fa-car',
            title = 'Return Vehicle',
            description = 'Return the rented vehicle.',
            onSelect = function()
                ReturnRentalVeh()
            end
        }
    end
    for k, v in pairs(Vehiclelist) do
        AllOptions[#AllOptions+1] = {
            icon = 'fas fa-car',
            title = v.Label,
            description = 'Price: $'..v.Price,
            onSelect = function()
                SpawnRentalVeh(k, v.Price, Loc, Plate)
            end
        }
    end

    lib.registerContext({
        id = 'HG_Rental_Menu',
        title = 'Rental Menu',
        options = AllOptions
    })
    lib.showContext('HG_Rental_Menu')
end


CreateThread(function()
    for k, v in pairs(Config.Rental.Locations) do

        --Blips 
        local blip = AddBlipForCoord(v.NPCCoords.x, v.NPCCoords.y, v.NPCCoords.z)
        SetBlipSprite(blip, v.Blips.Sprite)
        SetBlipScale(blip, v.Blips.Scale)
        SetBlipColour(blip, v.Blips.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Blips.Name)
        EndTextCommandSetBlipName(blip)

        --NPC
        lib.requestModel(v.NPCModel)
        local NPC = CreatePed(4, v.NPCModel, v.NPCCoords.x, v.NPCCoords.y, v.NPCCoords.z, v.NPCCoords.w, false, true)
        FreezeEntityPosition(NPC, true)
        SetEntityInvincible(NPC, true)
        SetBlockingOfNonTemporaryEvents(NPC, true)
        SetPedDiesWhenInjured(NPC, false)
        SetPedCanRagdollFromPlayerImpact(NPC, false)
        SetEntityAsMissionEntity(NPC, true, true)

        --Interaction
        if Config.Rental.Target == "ox_target" then
            exports.ox_target:addSphereZone({
                coords = vec3(v.NPCCoords.x, v.NPCCoords.y, v.NPCCoords.z+1.3),
                radius = 0.5,
                debug = Config.Rental.Debug,
                drawSprite = true,
                options = {
                    {
                        onSelect = function()
                            OpenRentMenu(v.Vehiclelist, v.VehicleSpawn, v.PlatePrefix)
                        end,
                        icon = 'fas fa-car',
                        label = 'Rent Vehicle',
                        distance = 4.5
                    }
                }
            })
        elseif Config.Rental.Target == "qb-target" then
            exports['qb-target']:AddBoxZone('HG_Rental'..v.NPCCoords.x, vector3(v.NPCCoords.x, v.NPCCoords.y, v.NPCCoords.z), 1.0, 1.0, {
                name = 'HG_Rental'..v.NPCCoords.x,
                heading = v.NPCCoords.w,
                debugPoly = Config.Rental.Debug,
                minZ = v.NPCCoords.z - 1.0,
                maxZ = v.NPCCoords.z + 1.0,
                }, {
                options = {
                    {
                        event = function()
                            OpenRentMenu(v.Vehiclelist, v.VehicleSpawn, v.PlatePrefix)
                        end,
                        icon = 'fas fa-car',
                        label = 'Rent Vehicle',
                    }
                },
                distance = 4.5
            })
        end
    end
end)
