if not isClient() then return end

---@param module string
---@param command string
---@param packet BUDataPacket | nil
---@---@type Callback_OnServerCommand
local onServerCommand = function(module, command, packet)
  
  if module ~= BU.module or
    BU.Commands[command] == nil or
    type(BU.Commands[command]) ~= "function" or
    packet == nil
  then return end

  local targetPlayer = getPlayerByOnlineID(packet.playerId)
  if targetPlayer == nil then return end

  local payload = {}
  if packet ~= nil and packet.payload ~= nil then
    payload = packet.payload
  end

  BU.Commands[command](targetPlayer, unpack(payload,1, #payload))
end

Events.OnServerCommand.Add(onServerCommand)