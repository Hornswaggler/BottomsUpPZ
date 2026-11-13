local BU = require "BU"

if isServer() then
  Events.EveryTenMinutes.Add(function() 
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
      local player = players:get(i)
      BU.Util.PrintPlayerInfo(player)
    end
  end)
end