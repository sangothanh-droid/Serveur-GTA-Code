local testDriveVehicle = nil
local openVehicleMenu, openVehicleSubmenu -- déclarations avancées (référencement croisé)

local function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function clearTestDrive()
    if testDriveVehicle and DoesEntityExist(testDriveVehicle) then
        DeleteEntity(testDriveVehicle)
    end
    testDriveVehicle = nil
end

local function startTestDrive(entry, spawnCoords)
    clearTestDrive()

    local hash = GetHashKey(entry.model)
    RequestModel(hash)
    local attempts = 0
    while not HasModelLoaded(hash) and attempts < 200 do
        Wait(10)
        attempts = attempts + 1
    end
    if not HasModelLoaded(hash) then
        TriggerEvent('QBCore:Notify', 'Modèle de véhicule introuvable.', 'error')
        return
    end

    testDriveVehicle = CreateVehicle(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    SetVehicleOnGroundProperly(testDriveVehicle)
    SetPedIntoVehicle(PlayerPedId(), testDriveVehicle, -1)
    SetModelAsNoLongerNeeded(hash)

    TriggerEvent('QBCore:Notify',
        ("Essai de %ds : ne vous éloignez pas trop du véhicule."):format(math.floor(Config.TestDriveTimeMs / 1000)),
        'primary')

    local myVehicle = testDriveVehicle
    SetTimeout(Config.TestDriveTimeMs, function()
        if testDriveVehicle == myVehicle then
            clearTestDrive()
            TriggerEvent('QBCore:Notify', "Fin de l'essai.", 'primary')
        end
    end)
end

CreateThread(function()
    while true do
        Wait(2000)
        if testDriveVehicle and DoesEntityExist(testDriveVehicle) then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(testDriveVehicle))
            if dist > Config.TestDriveWanderDistance then
                clearTestDrive()
                TriggerEvent('QBCore:Notify', 'Essai annulé : trop éloigné du véhicule.', 'error')
            end
        end
    end
end)

openVehicleSubmenu = function(dealership, entry)
    exports['qb-menu']:openMenu({
        {
            header = '‹ Retour au catalogue',
            icon = 'fas fa-angle-left',
            action = function() openVehicleMenu(dealership) end,
        },
        {
            header = entry.label,
            txt = ('Prix catalogue : $%d'):format(entry.price),
            disabled = true,
        },
        {
            header = 'Essayer',
            txt = 'Faire apparaître le véhicule pour un essai gratuit',
            action = function() startTestDrive(entry, dealership.spawnCoords) end,
        },
        {
            header = 'Acheter',
            txt = ('Payer $%d depuis votre compte en banque'):format(entry.price),
            action = function() TriggerServerEvent('rp-dealership:server:buyVehicle', dealership.id, entry.model) end,
        },
    })
end

openVehicleMenu = function(dealership)
    local items = {
        { header = '‹ Fermer', icon = 'fas fa-angle-left', action = function() exports['qb-menu']:closeMenu() end },
        { header = dealership.label, txt = 'Choisissez un véhicule', isMenuHeader = true },
    }

    for _, entry in ipairs(Config.Catalog) do
        if entry.type == dealership.vehicleType then
            table.insert(items, {
                header = entry.label,
                txt = ('$%d'):format(entry.price),
                action = function() openVehicleSubmenu(dealership, entry) end,
            })
        end
    end

    exports['qb-menu']:openMenu(items)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for _, dealership in ipairs(Config.Dealerships) do
            local dist = #(coords - dealership.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, dealership.coords.x, dealership.coords.y, dealership.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 40, 80, 220, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(dealership.coords, ('[E] %s'):format(dealership.label))
                    if IsControlJustReleased(0, 38) then -- E
                        openVehicleMenu(dealership)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
