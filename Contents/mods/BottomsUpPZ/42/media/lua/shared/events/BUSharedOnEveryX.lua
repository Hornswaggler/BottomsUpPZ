local handleDrinkUrge = require("functions/BUHandleDrinkUrge")
local checkForDrunkenStumble = require("functions/BUCheckForDrunkenStumble")

Events.EveryOneMinute.Add(checkForDrunkenStumble)
Events.EveryHours.Add(handleDrinkUrge)
