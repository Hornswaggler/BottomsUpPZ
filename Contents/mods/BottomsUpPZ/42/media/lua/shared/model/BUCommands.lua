local BUModData = require("model/BUModData")
local BUAnimState = require("model/BUAnimState")

---@class BUCommands
---@alias BUCommandName keyof BUCommands
local BUCommands = {}

---@return BUModData
local newModData = function()
  ---@type BUModData
  return {
    lastDrinkTimestamp = 0,
    tolerance = 1,
    dailyConsumptionTarget = 1.0,
    dailyConsumptionRemaining = 1.0,
    isLostInTheSauce = false,
  }
end

---@param player IsoPlayer
---@param variable string
---@param value boolean|number|string
local function setAnimVariable(player, variable, value)
  if type(value) == "boolean" then
    player:setVariable(variable, value)
  elseif type(value) == "number" then
    player:setVariable(variable, value)
  elseif type(value) == "string" then
    player:setVariable(variable, value)
  else
    error("Unsupported animation variable value: " .. tostring(value))
  end
end

local freshModData = newModData()
---@param player IsoPlayer
---@return BUModData
BUCommands.getPlayerModData = function(player)
  local playerModData = player:getModData()
  if not playerModData.BU then
    playerModData.BU = BUModData
  else

    --todo: do this during startup... :|
    -- this is so I don't have to create a new save every time to clear the serialized values
    for k, v in pairs(freshModData) do
      if playerModData.BU[k] == nil then
        playerModData.BU[k] = v
      end
    end
  end
  return playerModData.BU
end

---@generic K: keyof BUModData
---@param player IsoPlayer
---@param key K
---@param value BUModData[K]
BUCommands.setModDataValue = function(player, key, value)
  BU.Util.tsPrint("Setting mod data value for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
  local modData = BUCommands.getPlayerModData(player)
  modData[key] = value
  for _, animState in ipairs(BUAnimState) do
    if animState.key == key then
      BU.Util.tsPrint("Setting anim state for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
      setAnimVariable(player, animState.variable, modData[animState.key])
    end
  end

  BU.Util.buSendServerCommand(
    player, "setModDataValue",
    {key, value}
  )
end

BUCommands.userJoined = function(player)
  BU.Util.tsPrint("User joined: " .. tostring(player:getUsername()))

  if isServer() then
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
      local eachPlayer = players:get(i)
      for _, animState in ipairs(BUAnimState) do
        print("Syncing anim state for player " .. tostring(player:getUsername()) .. ": " .. tostring(animState.key))
        local value =  BU.Commands.getModDataValue(eachPlayer, animState.key)
        -- BU.Commands.setModDataValue(player, animState.key, value)
        BU.Util.buSendServerCommand(
          eachPlayer,
          "setModDataValue",
          {animState.key, value}
        )
      end

      -- BU.Commands.set
    end
  end

  -- BU.Commands.syncAnimStates(player)
  -- BU.Commands.syncAnimStates(getPlayer())
end

BUCommands.notifyUserJoined = function(player)
  BU.Util.tsPrint("Notifying user joined: " .. tostring(player:getUsername()))
  BU.Util.buSendClientCommandList(player, "userJoined")
end

---@param player IsoPlayer
---@param key BUModKeys
---@return BUModData[BUModKeys]
BUCommands.getModDataValue = function(player, key)
  local modData = BUCommands.getPlayerModData(player)
  return modData[key] or freshModData[key]
end

---@param player IsoPlayer
BUCommands.updateLastDrinkTimestamp = function(player)
  BUCommands.setModDataValue(player, "lastDrinkTimestamp", getGametimeTimestamp())
end

---@param player IsoPlayer
---@param delta number
BUCommands.updateDailyConsumptionRemaining = function(player, delta)
  BU.Util.tsPrint("Updating daily consumption remaining by " .. tostring(delta) .. " for player " .. tostring(player:getUsername()))
  BUCommands.setModDataValue(player, "dailyConsumptionRemaining", BUCommands.getModDataValue(player, "dailyConsumptionRemaining") + delta)
  BUCommands.updateLastDrinkTimestamp(player)
end

---@param player IsoPlayer
BUCommands.syncAnimStates = function(player)
  local modData = BUCommands.getPlayerModData(player)
  for _, animState in ipairs(BUAnimState) do
    local value = modData[animState.key]
    setAnimVariable(player, animState.variable, value)
    BU.Util.buSendServerCommand(
      player,
      "setModDataValue",
      {animState.key, value}
    )
  end
end


BUCommands.syncAllPlayerAnimStates = function()
  local players = getOnlinePlayers()
  for i = 0, players:size() - 1 do
    local eachPlayer = players:get(i)
    BUCommands.syncAnimStates(eachPlayer)
  end
end

return BUCommands