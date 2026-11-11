local BU = require("BU_STATE")

---@param player IsoPlayer
local function onClientCommand(module, command, player, args)
  if not isServer() then return end	
  if module ~= BU.module then return end

  BU.tsPrint("Received client command: " .. tostring(command) .. " with payload: " .. tostring(args.payload))

  -- todo: Add type safety
  BU[command](player, unpack(args.payload,1, #args.payload))
  sendServerCommand(module, command, {
    args = args,
    playerId = player:getOnlineID()
  })
end

Events.OnClientCommand.Add(onClientCommand)
