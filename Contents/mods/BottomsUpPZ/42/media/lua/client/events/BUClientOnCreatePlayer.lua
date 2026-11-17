Events.OnCreatePlayer.Add(function()
  local function initPlayer() 
    local player = getPlayer()
    BU.Commands.syncAnimStates(player)
    BU.Commands.notifyUserJoined(player)
    Events.OnTick.Remove(initPlayer)
  end

  Events.OnTick.Add(initPlayer)
end)