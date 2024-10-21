Config = {}

Config.Rental = {
    Debug = false,
    Target = 'ox_target',         -- Choose the target system: ox_target or qb-target
    ReturnMoney = true,

    Locations = {
        [1] = {
            NPCModel = `a_m_m_business_01`,
            NPCCoords = vector4(-211.64, -1003.43, 28.3, 71.63),
            VehicleSpawn = vector4(-215.64, -1001.54, 29.27, 157.9),
            PlatePrefix = 'HG',
            Blips = { Sprite = 225, Scale = 0.8, Color = 0, Name = 'Altra Street Rentals' },
            Vehiclelist = {
                ['asea'] = {
                    Label = 'Asea',
                    Price = 100,
                }
            },
        },
    }
}