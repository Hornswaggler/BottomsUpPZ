---@param command string
local function onServerCommand(module, command, args)
  if not isClient() then return end
  if module ~= BU.module then return end

  local targetPlayer = getPlayerByOnlineID(args.playerId)
  local targetFunction = BU[command]

  local payload = args.args.payload

  print("Target Function is: " .. tostring(targetFunction) .. " Payload: " .. tostring(payload))
  print("Params: " .. unpack(payload,1, #payload))

  if targetPlayer and not targetPlayer:isLocalPlayer() and targetFunction ~= nil then
    targetFunction(targetPlayer, unpack(args.args.payload, 1, #args.args.payload))
  end
end

Events.OnServerCommand.Add(onServerCommand)