-- local BU = require "BU"

---@param module string
---@param command string
---@param packet BUDataPacket | nil
---@---@type Callback_OnServerCommand
local onServerCommand = function(module, command, packet)
  
  print("BU_Client: onServerCommand: module=" .. tostring(module) .. ", command=" .. tostring(command) .. ", packet=" .. tostring(packet))

  if not isClient() or
    module ~= BU.module or
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
  -- print("Unpacked?", tostring(unpack(payload,1, #payload) or nil))

  BU.Commands[command](targetPlayer, unpack(payload,1, #payload))

  -- local payload = packet.payload or {}

  -- if payload ~= nil then
  --   BU.Commands[command](targetPlayer, payload.key, payload.value)
  -- else
  --   BU.Commands[command](targetPlayer)
  -- end
end

Events.OnServerCommand.Add(onServerCommand)