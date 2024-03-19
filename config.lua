Config = {}

Config.DropOffs = {
    [1] = vector3(152.52, 237.36, 106.97),
    [2] = vector3(646.28, 267.24, 103.26),
    [3] = vector3(971.65, 8.67, 81.04),
    [4] = vector3(1137.58, -470.69, 66.67),
    [5] = vector3(1165.29, -1347.32, 35.97),
    [6] = vector3(858.68, -3202.46, 5.99),
    -- Add more drop-off positions as needed
}

Config.Spawns = {
    [1] = vector4(-3155.67, 1132.26, 20.69, 335.2),
    [2] = vector4(62.66, 123.57, 79.02, 161.44),
    [3] = vector4(-425.89, 6167.91, 31.32, 315.59),
    [4] = vector4(-521.54, -2904.96, 5.83, 113.16)
}

Config.JobLoc = {
    [1] = {v = vector3(-3147.12, 1121.18, 20.86), h = 59.9, veh = "boxville2"},
    [2] = {v = vector3(78.81, 111.89, 81.16), h = 64.33, veh = "boxville2"},
    [3] = {v = vector3(-421.2, 6136.79, 31.87), h = 181.67, veh = "boxville4"},
    [4] = {v = vector3(-424.23, -2789.84, 6.52), h = 134.05, veh = "boxville4"}
}

Config.Payouts = {
    [1] = function()
        return math.random(50, 75)
    end,
    [2] = function()
        return math.random(80, 120)
    end,
    [3] = function()
        return math.random(80, 200)
    end,
    [4] = function()
        return math.random(120, 200)
    end,
    [5] = function()
        return math.random(200, 500)
    end
    -- Add more payouts as needed
}