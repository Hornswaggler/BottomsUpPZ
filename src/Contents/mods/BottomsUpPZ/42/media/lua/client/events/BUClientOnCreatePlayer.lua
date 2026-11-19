local BU = require("BU")

Events.OnCreatePlayer.Add(function()
  local function initPlayer() 
    local player = getPlayer()

    local buLocal = BU

    print(tostring(buLocal))

    BU.cmd.syncAnimStates(player)
    -- todo: this doesn't need to run in single player... Probably
    BU.cmd.notifyUserJoined(player)
    Events.OnTick.Remove(initPlayer)
  end

  Events.OnTick.Add(initPlayer)
end)