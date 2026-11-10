local BU = require("BU_STATE")

---@param player IsoPlayer
local function onClientCommand(module, command, player, args)
  if not isServer() then return end	
  if module ~= BU.module then return end

  -- todo: Add type safety
  BU[command](player, args.payload)
  sendServerCommand(module, command, {
    args = args,
    playerId = player:getOnlineID()
  })
end

Events.OnClientCommand.Add(onClientCommand)
