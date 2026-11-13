local BU = require "BU_STATE"

local checkForAlcoholPoisoning = require("BU_FUNC_CheckForAlcoholPoisoning")
local checkForDrunkenStumble = require("BU_FUNC_CheckForDrunkenStumble")
local handleDrinkUrge = require("BU_FUNC_HandleDrinkUrge")

Events.EveryTenMinutes.Add(function()
  if isServer() then
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
      local player = players:get(i)
      print("Checking alcohol poisoning for player:", player)
      -- checkForAlcoholPoisoning(player)
    end
  end
  if isClient() then
    local player = getPlayer()
    if not player or player:isDead() then return end
    -- checkForAlcoholPoisoning(player)
  end
end)
Events.EveryOneMinute.Add(checkForDrunkenStumble)
Events.EveryHours.Add(handleDrinkUrge)