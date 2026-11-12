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
        checkForAlcoholPoisoning(player)
      end

    


    -- players:forEach(function(player)
    --   print("Checking alcohol poisoning for player:", player)
    --   checkForAlcoholPoisoning(player)
    -- end)



    -- for _, player in ipairs(getOnlinePlayers()) do
    --   print("Checking alcohol poisoning for player:", player)
    --   checkForAlcoholPoisoning(player)
    -- end
  else
    local player = getPlayer()
    if not player or player:isDead() then return end
    checkForAlcoholPoisoning(player)
  end
end)
Events.EveryOneMinute.Add(checkForDrunkenStumble)
Events.EveryHours.Add(handleDrinkUrge)

Events.OnCreatePlayer.Add(function(playerIndex,player)
  if isServer() then
    BU.syncAnimStates(playerIndex, player)
  end
end)

Events.EveryTenMinutes.Add(function() 
  if isServer() then
    -- for _, player in ipairs(getOnlinePlayers()) do
    --   BU.Util.PrintPlayerInfo(player)
    -- end


    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
      local player = players:get(i)
      BU.Util.PrintPlayerInfo(player)
    end

    
  else
    local player = getPlayer()
    if not player or player:isDead() then return end
    BU.Util.PrintPlayerInfo(player)
  end

end)