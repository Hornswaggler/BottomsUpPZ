
Events.EveryTenMinutes.Add(function() 
  local player = getPlayer()
  if not player or player:isDead() then return end
  BU.Util.PrintPlayerInfo(player)
end)

Events.OnCreatePlayer.Add(function()
  local function initPlayer() 
    local player = getPlayer()
    print("On Create Player called..." .. tostring(player:getUsername()))
    BU.Commands.syncAnimStates(player)
    BU.Commands.notifyUserJoined(player)
    Events.OnTick.Remove(initPlayer)
  end

  Events.OnTick.Add(initPlayer)
end)

