---@param command string
local function onServerCommand(module, command, args)
  if not isClient() then return end
  if module ~= BU.module then return end

  local targetPlayer = getPlayerByOnlineID(args.playerId)
  local targetFunction = BU[command]

  print("Target Function is: " .. tostring(targetFunction) .. " Payload: " .. tostring(args.args.payload))

  if targetPlayer and not targetPlayer:isLocalPlayer() and targetFunction ~= nil then
    targetFunction(targetPlayer, args.args.payload)
  end
end

Events.OnServerCommand.Add(onServerCommand)