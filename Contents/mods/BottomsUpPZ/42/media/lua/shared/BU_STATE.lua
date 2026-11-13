---@class BU
BU = BU or {}

---@type { heavyDrinker: "bu:heavierdrinker" }
local BUTraits = {
  heavyDrinker = "bu:heavierdrinker"
}

---@param player IsoPlayer
---@param command string
---@param value BUDataPacket
local buSendClientCommand = function(player, command, value)
  if isClient() and player:isLocalPlayer() then
    sendClientCommand(BU.module, command, {payload = value})
  end
end

---@param player IsoPlayer
---@param command string
---@param payload BUDataPacketPayload
local buSendServerCommand = function(player, command, payload)
  if isServer() then
    sendServerCommand(BU.module, command,  {payload = payload, playerId = player:getOnlineID()})
  end
end

---@return BUModData
local function newModData()
  return {
    lastDrinkTimestamp = 0,
    tolerance = 1,
    dailyConsumptionTarget = 1.0,
    dailyConsumptionRemaining = 1.0,
    isLostInTheSauce = false
  }
end

---@class BUModData
---@alias BUModKeys keyof BUModData
local BUModData = BU.modData or {}
BUModData.lastDrinkTimestamp = 0
BUModData.tolerance = 1
BUModData.dailyConsumptionTarget = 1.0
BUModData.dailyConsumptionRemaining = 1.0
BUModData.isLostInTheSauce = false

---@class BUAnimState
---@field key BUModKeys
---@field variable string
---@type BUAnimState[]
local BUAnimstates = {
  {key = "isLostInTheSauce", variable = "isLostInTheSauce"}
}

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

---@class BUDataPacketPayload
---@field key BUModKeys
---@field value BUModData[BUModKeys]

---@class BUDataPacket: table
---@field payload BUDataPacketPayload
---@field playerId integer

---@class BUCommands
---@alias BUCommandName keyof BUCommands
local BUCommands = BU.Commands or {}

---@param player IsoPlayer
---@return BUModData
BUCommands.getPlayerModData = function(player)
  local playerModData = player:getModData()
  if not playerModData.BU then
    playerModData.BU = BUModData
  else

    --todo: do this during startup... :|
    -- this is so I don't have to create a new save every time to clear the serialized values
    for k, v in pairs(newModData()) do
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
  for _, animState in ipairs(BUAnimstates) do
    if animState.key == key then
      BU.Util.tsPrint("Setting anim state for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
      setAnimVariable(player, animState.variable, modData[animState.key])
    end
  end

  buSendServerCommand(
    player, "setModDataValue",
    {key = key, value = value}
  )
end

---@generic K: keyof BUModData
---@param player IsoPlayer
---@param key K
---@return BUModData[K]
BUCommands.getModDataValue = function(player, key)
  local modData = BUCommands.getPlayerModData(player)
  return modData[key] or newModData()[key]
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

---@param playerNum integer
---@param player IsoPlayer
BUCommands.syncAnimStates = function(playerNum, player)
  local modData = BUCommands.getPlayerModData(player)
  for _, animState in ipairs(BUAnimstates) do
    local value = modData[animState.key]
    setAnimVariable(player, animState.variable, value)
    buSendServerCommand(
      player,
      "setModDataValue",
      {key = animState.key, value = value}
    )
  end
end

---@class BUUtil
local BUUtil = BU.Util or {}
BUUtil.tsPrint = function(message)
  local timestamp = os.date("%H:%M:%S %m-%d-%Y", getTimestamp())
  print("[" .. timestamp .. "] " .. message)
end

---@param player IsoPlayer
BUUtil.PrintPlayerInfo = function(player)
  local modData = BUCommands.getPlayerModData(player)
  BUUtil.tsPrint("Player Info: " .. tostring(player:getUsername()) .. " " .. tostring(player:getOnlineID()))
  BUUtil.tsPrint("Is Local: " .. tostring(player:isLocalPlayer()))
  BUUtil.tsPrint("Last Drink Timestamp: " .. tostring(modData.lastDrinkTimestamp))
  BUUtil.tsPrint("Tolerance: " .. tostring(modData.tolerance))
  BUUtil.tsPrint("Daily Consumption Target: " .. tostring(modData.dailyConsumptionTarget))
  BUUtil.tsPrint("Daily Consumption Remaining: " .. tostring(modData.dailyConsumptionRemaining))
  BUUtil.tsPrint("Is Lost In The Sauce: " .. tostring(modData.isLostInTheSauce))
end

---@class BUConfig
local BUConfig = BU.Config or {}
BUConfig.HEAVY_DRINKER_TRAIT_ID = BUTraits.heavyDrinker
BUConfig.STUMBLE_MAX = 100
BUConfig.STUMBLE_THRESHOLD = 1
BUConfig.STUMBLE_COOLDOWN = 5

BU.module = "BU"
BU.Util = BUUtil
BU.Config = BUConfig
BU.Commands = BUCommands
BU.modData = BUModData

return BU