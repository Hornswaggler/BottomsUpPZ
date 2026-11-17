local performVomit = require("functions/BUPerformVomit")

Events.EveryTenMinutes.Add(function()
  print("EVERY TEN MINUTES CLIENT...")
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.Util.PrintPlayerInfo(player)

  local player = getPlayer()
  if not player or player:isDead() then return end

  if(BU.Commands.getModDataValue(player, "isLostInTheSauce")) then
    print("Player is lost in the sauce, performing vomit action...")
    performVomit(player)
  end

  -- local players = getOnlinePlayers()
  -- for i = 0, players:size() - 1 do
  --   local each = players:get(i)
  --   BU.Util.PrintPlayerInfo(each)
  --   print("Checking alcohol poisoning for player:", each)
  --   -- checkForAlcoholPoisoning(player)
  -- end

end)