if not isServer() then return end

local checkForAlcoholPoisoning = require("functions/BUCheckForAlcoholPoisoning")

Events.EveryTenMinutes.Add(function() 
  local players = getOnlinePlayers()
  for i = 0, players:size() - 1 do
    local eachPlayer = players:get(i)
    BU.Util.PrintPlayerInfo(eachPlayer)

    local isLostInTheSauce = checkForAlcoholPoisoning(eachPlayer)
    if not isLostInTheSauce then
      BU.Commands.setModDataValue(
        eachPlayer, 
        "isLostInTheSauce", 
        isLostInTheSauce
      )
    end
  end
end)
