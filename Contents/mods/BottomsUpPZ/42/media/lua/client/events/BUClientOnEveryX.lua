local checkForAlcoholPoisoning = require("functions/BUCheckForAlcoholPoisoning")
local performVomit = require("functions/BUPerformVomit")
local updateNauseaByDelta = require("functions/BUIncreaseNauseaByDelta")

Events.EveryTenMinutes.Add(function()
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.util.PrintPlayerInfo(player)

  if(BU.cmd.getModDataValue(player, "isLostInTheSauce")) then
    updateNauseaByDelta(player, BU.cfg.BASE_NAUSEA_DELTA * BU.cmd.getModDataValue(player, "tolerance"))
    performVomit(player)
  else
    updateNauseaByDelta(player, BU.cfg.BASE_NAUSEA_DELTA * BU.cmd.getModDataValue(player, "tolerance") * -1)
  end

end)


if isMultiplayer() then return end

Events.EveryTenMinutes.Add(function() 
  local player = getPlayer()
  if not player or player:isDead() then return end

  local isLostInTheSauce = checkForAlcoholPoisoning(player)
  if not isLostInTheSauce then
    BU.cmd.setModDataValue(
      player, 
      "isLostInTheSauce", 
      isLostInTheSauce
    )
  end
end)