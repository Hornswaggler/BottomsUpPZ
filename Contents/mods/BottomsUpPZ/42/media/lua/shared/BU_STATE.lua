---@class BUModData
---@field lastDrinkTimestamp number
---@field tolerance number
---@field dailyConsumptionTarget number
---@field dailyConsumptionRemaining number
---@field isLostInTheSauce boolean
---@alias BUModKeys keyof BUModData

---@class BUCommands
---@field getPlayerModData fun(player: IsoPlayer): BUModData
---@field setModDataValue fun<K: keyof BUModData>(player: IsoPlayer, key: K, value: BUModData[K])
---@field getModDataValue fun<K: keyof BUModData>(player: IsoPlayer, key: K): BUModData[K]
---@field updateLastDrinkTimestamp fun(player: IsoPlayer)
---@field updateDailyConsumptionRemaining fun(player: IsoPlayer, delta: number)
---@field syncAnimStates fun(playerNum: integer, player: IsoPlayer)
---@alias BUCommandName keyof BUCommands

---@class BUConstants
---@field HEAVY_DRINKER_TRAIT_ID string
---@field STUMBLE_MAX number
---@field STUMBLE_THRESHOLD number
---@field STUMBLE_COOLDOWN number

---@class BUUtil
---@field tsPrint fun(message: string)
---@field PrintPlayerInfo fun(player: IsoPlayer)

---@class BU: BUCommands
---@field module string
---@field modData BUModData
---@field CONST BUConstants
---@field Util BUUtil

---@class BUDataPacketPayload
---@field key BUModKeys
---@field value BUModData[BUModKeys]

---@class BUDataPacket: table
---@field payload BUDataPacketPayload
---@field playerId integer

---@type { isLostInTheSauce: "isLostInTheSauce" }
local BUAnimstates = {
  isLostInTheSauce = "isLostInTheSauce"
}

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

---@type BU
BU = BU or {}
BU.module = "BU"
BU.modData = BU.modData or newModData()

BU.CONST = BU.CONST or {}
BU.CONST.HEAVY_DRINKER_TRAIT_ID = "bu:heavierdrinker"
BU.CONST.STUMBLE_MAX = 100
BU.CONST.STUMBLE_THRESHOLD = 1
BU.CONST.STUMBLE_COOLDOWN = 5

---@param player IsoPlayer
---@return BUModData
function BU.getPlayerModData(player)
  local playerModData = player:getModData()
  if not playerModData.BU then
    playerModData.BU = newModData()
  else
    -- todo: remove this before release!!! 
    --or... do this during startup... :|
    -- this is so I don't have to create a new save every time to clear the serialized values
    for k, v in pairs(newModData()) do
      if playerModData.BU[k] == nil then
        playerModData.BU[k] = v
      end
    end
  end
  return playerModData.BU
end

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
---@param value BUDataPacket
local buSendServerCommand = function(player, command, value)
  if isServer() then
    sendServerCommand(BU.module, command,  value)
  end
end

---@generic K: keyof BUModData
---@param key K
---@param value BUModData[K]
BU.setModDataValue = function(player, key, value)
  BU.Util.tsPrint("Setting mod data value for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
  local modData = BU.getPlayerModData(player)
  modData[key] = value
  if BUAnimstates[key] ~= nil then
    player:setVariable(key, value)
  end
  buSendServerCommand(player, "setModDataValue", {payload = {key = key, value = value}, playerId = player:getOnlineID()})
  -- buSendClientCommand(player, "setModDataValue", {key = key, value = value})
end

---@generic K: keyof BUModData
---@param key K
---@return BUModData[K]
BU.getModDataValue = function(player, key)
  local modData = BU.getPlayerModData(player)
  return modData[key] or newModData()[key]
end

-- ---@param player IsoPlayer
-- function BU.getPlayerLastDrinkTimestamp(player)
--   return BU.getModDataValue(player, "lastDrinkTimestamp")
-- end

-- ---@param player IsoPlayer
-- ---@return number
-- function BU.getPlayerDailyConsumptionTarget(player)
--   return BU.getModDataValue(player, "dailyConsumptionTarget")
-- end

---@param player IsoPlayer
function BU.updateLastDrinkTimestamp(player)
  BU.setModDataValue(player, "lastDrinkTimestamp", getGametimeTimestamp())
end

---@param player IsoPlayer
---@param delta number
function BU.updateDailyConsumptionRemaining(player, delta)
  BU.Util.tsPrint("Updating daily consumption remaining by " .. tostring(delta) .. " for player " .. tostring(player:getUsername()))
  BU.setModDataValue(player, "dailyConsumptionRemaining", BU.getModDataValue(player, "dailyConsumptionRemaining") + delta)
  BU.updateLastDrinkTimestamp(player)
end

---@param playerNum integer
---@param player IsoPlayer
BU.syncAnimStates = function(playerNum, player)
  print("Player created: " .. tostring(playerNum) .. " " .. tostring(player:getUsername()))
  
  for key, animState in pairs(BUAnimstates) do
    local value = BU.getModDataValue(player, key)
    player:setVariable(animState, value)
    -- buSendClientCommand(player, "setModDataValue", {key, value})
  end
  
  -- for i, animState in pairs(BUAnimstates) do
  --   BU.Util.tsPrint("Syncing anim state: " .. tostring(animState))
  --   local value = BU.getModDataValue(player, animState)
  --   player:setVariable(animState, value)
  --   buSendClientCommand(player, "setModDataValue", {animState, value})
  -- end
end

BU.Util = BU.Util or {}

BU.Util.tsPrint = function(message)
  local timestamp = os.date("%H:%M:%S %m-%d-%Y", getTimestamp())
  print("[" .. timestamp .. "] " .. message)
end

---@param player IsoPlayer
BU.Util.PrintPlayerInfo = function(player)
  local modData = BU.getPlayerModData(player)
  BU.Util.tsPrint("Player Info: " .. tostring(player:getUsername()) .. " " .. tostring(player:getOnlineID()))
  BU.Util.tsPrint("Is Local: " .. tostring(player:isLocalPlayer()))
  BU.Util.tsPrint("Last Drink Timestamp: " .. tostring(modData.lastDrinkTimestamp))
  BU.Util.tsPrint("Tolerance: " .. tostring(modData.tolerance))
  BU.Util.tsPrint("Daily Consumption Target: " .. tostring(modData.dailyConsumptionTarget))
  BU.Util.tsPrint("Daily Consumption Remaining: " .. tostring(modData.dailyConsumptionRemaining))
  BU.Util.tsPrint("Is Lost In The Sauce: " .. tostring(modData.isLostInTheSauce))
end

return BU