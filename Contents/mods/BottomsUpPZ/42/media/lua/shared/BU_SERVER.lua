-- local BU = require "BU"

---@param module string
---@param command string
---@param player IsoPlayer
---@param args BUDataPacket | nil
---@type Callback_OnClientCommand
local onClientCommand = function(module, command, player, args)
  if not isServer() then return end	
  if module ~= "BU" then return end

  local payload = args and args.payload 
  BU.Commands[command](player, args ~= nil and unpack(payload,1, #payload) or nil)

  sendServerCommand(module, command, {
    payload = payload,
    playerId = player:getOnlineID()
  })
end

Events.OnClientCommand.Add(onClientCommand)
