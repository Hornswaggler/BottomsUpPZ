-- local checkForAlcoholPoisoning = require("BU_FUNC_CheckForAlcoholPoisoning")
local checkForDrunkenStumble = require("BU_FUNC_CheckForDrunkenStumble")
local handleDrinkUrge = require("BU_FUNC_HandleDrinkUrge")

-- Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)
Events.EveryOneMinute.Add(checkForDrunkenStumble)
Events.EveryHours.Add(handleDrinkUrge)