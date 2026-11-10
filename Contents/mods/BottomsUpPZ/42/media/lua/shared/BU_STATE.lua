---@class BUModData
---Last time player had a drink
---@field lastDrinkTimestamp integer
---How apt player is to get sick from drinking
---@field tolerance integer
---How much user requires a day
---@field dailyConsumptionTarget number
---@field dailyConsumptionRemaining number
---@field isLostInTheSauce boolean

---@return table | BUModData
local function newModData()
  return {
    lastDrinkTimestamp = 0,
    tolerance = 1,
    dailyConsumptionTarget = 1.0,
    dailyConsumptionRemaining = 1.0,
    isLostInTheSauce = false
  }
end

BU = BU or {}
BU.module = "BU"
BU.modData = BU.modData or newModData()
BU.HEAVY_DRINKER_TRAIT_ID = "bu:heavierdrinker"
BU.STUMBLE_MAX = 100
BU.STUMBLE_THRESHOLD = 1
BU.STUMBLE_COOLDOWN = 5

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

---@generic K: keyof BUModData
---@param key K
---@param value BUModData[K]
---@param sync boolean
BU.setModDataValue = function(player, key, value)
  local modData = BU.getPlayerModData(player)
  modData[key] = value
end

---@generic K: keyof BUModData
---@param key K
---@return BUModData[K]
BU.getModDataValue = function(player, key)
  local modData = BU.getPlayerModData(player)
  return modData[key]
end

---@param player IsoPlayer
function BU.getPlayerLastDrinkTimestamp(player)
  return BU.getModDataValue(player, "lastDrinkTimestamp")
end

---@param player IsoPlayer
---@return number
function BU.getPlayerDailyConsumptionTarget(player)
  return BU.getModDataValue(player, "dailyConsumptionTarget")
end

---@param player IsoPlayer
function BU.updateLastDrinkTimestamp(player)
  BU.setModDataValue(player, "lastDrinkTimestamp", getGametimeTimestamp())
end

---@param player IsoPlayer
---@param delta number
function BU.updateDailyConsumptionRemaining(player, delta)
  BU.setModDataValue(player, "dailyConsumptionRemaining", BU.getModDataValue(player, "dailyConsumptionRemaining") + delta)
  BU.updateLastDrinkTimestamp(player)
end

---@param player IsoPlayer
---@param isLostInTheSauce boolean
BU.setIsLostInTheSauce = function(player, isLostInTheSauce)
  player:setVariable("isLostInTheSauce", isLostInTheSauce)
  BU.setModDataValue(player, "isLostInTheSauce", isLostInTheSauce)
  
  if isClient() and player:isLocalPlayer() then 
    sendClientCommand(BU.module, "setIsLostInTheSauce", {payload = isLostInTheSauce})
  end
end

return BU