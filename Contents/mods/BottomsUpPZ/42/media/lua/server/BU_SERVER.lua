local BU = require "BU_STATE"

---@param module string
---@param command string
---@param player IsoPlayer
---@param args BUDataPacket | nil
---@type Callback_OnClientCommand
local onClientCommand = function(module, command, player, args)
  if not isServer() then return end	
  if module ~= BU.module then return end

  if args ~= nil then
    BU.Util.tsPrint("Received client command: " .. tostring(command) .. " with payload: " .. tostring(args.payload or ""))
    -- todo: Add type safety
    BU[command](player, unpack(args.payload,1, #args.payload))
    sendServerCommand(module, command, {
      payload = args.payload,
      playerId = player:getOnlineID()
    })
  end


end

Events.OnClientCommand.Add(onClientCommand)
