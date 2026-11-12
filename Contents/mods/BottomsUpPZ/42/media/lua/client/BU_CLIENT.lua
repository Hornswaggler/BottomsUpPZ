local BU = require "BU_STATE"

---@param module string
---@param command string
---@param packet BUDataPacket | nil
---@---@type Callback_OnServerCommand
local onServerCommand = function(module, command, packet)
  
  if not isClient() or
    module ~= BU.module or
    BU[command] == nil or
    type(BU[command]) ~= "function" or
    packet == nil
  then return end

  local targetPlayer = getPlayerByOnlineID(packet.playerId)
  if targetPlayer == nil then return end

  local payload = packet.payload

  print("Target Function is: " .. tostring(command) .. " " .. tostring(BU[command]) .. " Payload: " .. tostring(payload))
  BU[command](targetPlayer, payload.key, payload.value)

end

Events.OnServerCommand.Add(onServerCommand)