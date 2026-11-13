local BU = require "BU"

---@param module string
---@param command string
---@param packet BUDataPacket | nil
---@---@type Callback_OnServerCommand
local onServerCommand = function(module, command, packet)
  
  if not isClient() or
    module ~= BU.module or
    BU.Commands[command] == nil or
    type(BU.Commands[command]) ~= "function" or
    packet == nil
  then return end

  local targetPlayer = getPlayerByOnlineID(packet.playerId)
  if targetPlayer == nil then return end

  local payload = packet.payload or {}

  if payload ~= nil then
    BU.Commands[command](targetPlayer, payload.key, payload.value)
  else
    BU.Commands[command](targetPlayer)
  end
end

Events.OnServerCommand.Add(onServerCommand)