local BU = require("BU_STATE")
local checkForAlcoholPoisoning = require("BU_FUNC_CheckForAlcoholPoisoning")
local checkForDrunkenStumble = require("BU_FUNC_CheckForDrunkenStumble")
local handleDrinkUrge = require("BU_FUNC_HandleDrinkUrge")

Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)
Events.EveryOneMinute.Add(checkForDrunkenStumble)
Events.EveryHours.Add(handleDrinkUrge)

Events.OnCreatePlayer.Add(BU.syncAnimStates)

Events.EveryTenMinutes.Add(function() 
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.PrintPlayerInfo(player)
end)