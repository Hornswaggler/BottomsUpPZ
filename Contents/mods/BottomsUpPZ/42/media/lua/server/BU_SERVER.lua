local function setPlayerVariable(player, args)
  if player and args and args.variable and args.value ~= nil then
    player:setVariable(args.variable, args.value)
  end
end

---@param player IsoPlayer
local function onClientCommand(module, command, player, args)

    local onlinePlayers = getOnlinePlayers()
  for i = 0, onlinePlayers:size() - 1 do
    local player = onlinePlayers:get(i)
    print("Player online Id:", tostring(player:getOnlineID()))
  end

  sendServerCommand(module, command, {
    args = args,
    playerId = player:getID()
  })
  print("Client Command Received: " .. tostring(module) .. " " .. tostring(command) .. " " .. tostring(args) .. tostring(player) .. tostring(player:getID()))
  if module == "BU" and command == "setPlayerVariable" then
    print("Module is BU: setting player variable")
    setPlayerVariable(player, args)
  end
end

print("BU_SERVER.lua loaded")

Events.OnClientCommand.Add(onClientCommand)
