
Events.EveryTenMinutes.Add(function() 
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.Util.PrintPlayerInfo(player)
end)

Events.OnCreatePlayer.Add(function(playerIndex,player)
  print("On Create Player called...")
  BU.Commands.syncAnimStates(playerIndex, player)
end)

