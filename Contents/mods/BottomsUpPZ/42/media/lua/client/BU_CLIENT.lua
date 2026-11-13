local BU = require "BU_STATE"

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

  local payload = packet.payload

  print("Target Function is: " .. tostring(command) .. " " .. tostring(BU.Commands[command]) .. " Payload: " .. tostring(payload))
  BU.Commands[command](targetPlayer, payload.key, payload.value)
end

Events.OnServerCommand.Add(onServerCommand)