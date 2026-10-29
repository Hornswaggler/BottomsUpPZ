---@class BUModData
---Last time player had a drink
---@field lastDrinkTimestamp integer
---How apt player is to get sick from drinking
---@field tolerance integer
---How much user requires a day
---@field dailyConsumptionTarget number
---@field dailyConsumptionRemaining number

---@alias BUModDataEnum "'lastDrinkTimestamp'" | "'tolerance'" | "'dailyConsumptionTarget'" | "'dailyConsumptionRemaining'"


---@return table | BUModData
local function newModData()
  return {
    lastDrinkTimestamp = 0,
    tolerance = 1,
    dailyConsumptionTarget = 1.0,
    dailyConsumptionRemaining = 1.0
  }
end

BU = BU or {}
BU.module = "BU"
BU.modData = BU.modData or newModData()
BU.HEAVY_DRINKER_TRAIT_ID = "bu:heavierdrinker"

---@param player IsoPlayer
---@return BUModData
function BU.getPlayerModData(player)
  local playerModData = player:getModData()
  if not playerModData.BU then
    playerModData.BU = newModData()
  else
    -- todo: remove this before release!!! 
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
function BU.getPlayerLastDrinkTimestamp(player)
  return BU.getPlayerModData(player).lastDrinkTimestamp
end

---@param player IsoPlayer
---@return number
function BU.getPlayerDailyConsumptionTarget(player)
  return BU.getPlayerModData(player).dailyConsumptionTarget
end

---@param player IsoPlayer
function BU.updateLastDrinkTimestamp(player)
  BU.getPlayerModData(player).lastDrinkTimestamp = getGametimeTimestamp()
end

---@param player IsoPlayer
---@param delta number
function BU.updateDailyConsumptionRemaining(player, delta)
  local modData = BU.getPlayerModData(player)

  modData.dailyConsumptionRemaining = modData.dailyConsumptionRemaining + delta

  print("Daily COnsumption remaining: " .. tostring(modData.dailyConsumptionRemaining))
  
  BU.updateLastDrinkTimestamp(player)
end

