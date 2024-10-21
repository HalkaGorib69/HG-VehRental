local Framework, QBCore, ESX = nil, nil, nil

if GetResourceState("es_extended") == "started" then
    Framework = "esx"
    ESX = exports["es_extended"]:getSharedObject()
elseif GetResourceState("qb-core") == "started" then
    Framework = "qb"
    QBCore = exports["qb-core"]:GetCoreObject()
end

local function ToggleMoney(source, Toggle, Type, Amount)
    local Player
    if not Framework then return end

    if Framework == 'esx' then
        Player = ESX.GetPlayerFromId(source)
        Type = 'money'
    elseif Framework == 'qb' then
        Player = QBCore.Functions.GetPlayer(source)
    end

    if Toggle == 'has' then
        if Framework == 'esx' then
            return Player.getMoney()
        elseif Framework == 'qb' then
            return Player.Functions.GetMoney(Type)
        end
    elseif Toggle == 'add' then
        if Framework == 'esx' then
            Player.addAccountMoney(Type, Amount)
        elseif Framework == 'qb' then
            Player.Functions.AddMoney(Type, Amount)
        end
        return true
    elseif Toggle == 'remove' then
        if Framework == 'esx' then
            Player.removeMoney(Amount)
        elseif Framework == 'qb' then
            Player.Functions.RemoveMoney(Type, Amount)
        end
        return true
    end
end

lib.callback.register('server:HG-Rental:togglemoney', function(source, type, amount)
    local Data = ToggleMoney(source, type, 'cash', amount)
    return Data
end)