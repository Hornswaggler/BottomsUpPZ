if not isServer() then return end

---@param module string
---@param command string
---@param player IsoPlayer
---@param args BUDataPacket | nil
---@type Callback_OnClientCommand
local onClientCommand = function(module, command, player, args)
  if module ~= BU.module then return end

  local payload = {}
  if args ~= nil and args.payload ~= nil then
    payload = args.payload
  end
  -- print("Unpacked?", tostring(unpack(payload,1, #payload) or nil))

  BU.Commands[command](player, payload ~= nil and unpack(payload,1, #payload))

  sendServerCommand(module, command, {
    payload = payload,
    playerId = player:getOnlineID()
  })
end

Events.OnClientCommand.Add(onClientCommand)
