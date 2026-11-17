local checkForAlcoholPoisoning = require("functions/BUCheckForAlcoholPoisoning")
local performVomit = require("functions/BUPerformVomit")

Events.EveryTenMinutes.Add(function()
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.Util.PrintPlayerInfo(player)

  if(BU.Commands.getModDataValue(player, "isLostInTheSauce")) then
    performVomit(player)
  end

end)


if isMultiplayer() then return end

Events.EveryTenMinutes.Add(function() 
  local player = getPlayer()
  if not player or player:isDead() then return end

  local isLostInTheSauce = checkForAlcoholPoisoning(player)
  if not isLostInTheSauce then
    BU.Commands.setModDataValue(
      player, 
      "isLostInTheSauce", 
      isLostInTheSauce
    )
  end
end)