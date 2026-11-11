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

---@generic K: keyof BUModData
---@type table<K,K>
local BUAnimstates = {
  isLostInTheSauce = "isLostInTheSauce"
}

BU = BU or {}
BU.module = "BU"
BU.modData = BU.modData or newModData()
BU.HEAVY_DRINKER_TRAIT_ID = "bu:heavierdrinker"
BU.STUMBLE_MAX = 100
BU.STUMBLE_THRESHOLD = 1
BU.STUMBLE_COOLDOWN = 5

BU.tsPrint = function(message)
  local timestamp = os.date("%H:%M:%S %m-%d-%Y", getTimestamp())
  print("[" .. timestamp .. "] " .. message)
end

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

local buSendClientCommand = function(player, command, value)
  if isClient() and player:isLocalPlayer() then 
    sendClientCommand(BU.module, command, {payload = value})
  end
end

---@generic K: keyof BUModData 
---@param key K 
---@param value BUModData[K]
BU.setModDataValue = function(player, key, value)
  BU.tsPrint("Setting mod data value for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
  local modData = BU.getPlayerModData(player)
  modData[key] = value
  if BUAnimstates[key] ~= nil then
    player:setVariable(key, value)
  end
  buSendClientCommand(player, "setModDataValue", {key, value})
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
  BU.tsPrint("Updating daily consumption remaining by " .. tostring(delta) .. " for player " .. tostring(player:getUsername()))
  BU.setModDataValue(player, "dailyConsumptionRemaining", BU.getModDataValue(player, "dailyConsumptionRemaining") + delta)
  BU.updateLastDrinkTimestamp(player)
end

---@param player IsoPlayer
---@param isLostInTheSauce boolean
BU.setIsLostInTheSauce = function(player, isLostInTheSauce)
  player:setVariable("isLostInTheSauce", isLostInTheSauce)
  BU.setModDataValue(player, "isLostInTheSauce", isLostInTheSauce )
  
  -- if isClient() and player:isLocalPlayer() then 
  --   sendClientCommand(BU.module, "setIsLostInTheSauce", {payload = isLostInTheSauce, callback = "setIsLostInTheSauce"})
  -- end
end

BU.setIsLostInTheSauceAnim = function(player, isLostInTheSauce)
  -- todo: on client...
  player:setVariable("isLostInTheSauce", isLostInTheSauce)
end

BU.syncAnimStates = function(playerNum, player)
  print("Player created: " .. tostring(playerNum) .. " " .. tostring(player:getUsername()))
  for i, animState in pairs(BUAnimstates) do
    BU.tsPrint("Syncing anim state: " .. tostring(animState))
    ---@diagnostic disable-next-line: generic-constraint-mismatch
    local value = BU.getModDataValue(player, animState)
    player:setVariable(animState, value)
    buSendClientCommand(player, "setModDataValue", {animState, value})
  end
end

---@param player IsoPlayer
BU.PrintPlayerInfo = function(player)
  local modData = BU.getPlayerModData(player)
  BU.tsPrint("Player Info: " .. tostring(player:getUsername()) .. " " .. tostring(player:getOnlineID()))
  BU.tsPrint("Is Local: " .. tostring(player:isLocalPlayer()))
  BU.tsPrint("Last Drink Timestamp: " .. tostring(modData.lastDrinkTimestamp))
  BU.tsPrint("Tolerance: " .. tostring(modData.tolerance))
  BU.tsPrint("Daily Consumption Target: " .. tostring(modData.dailyConsumptionTarget))
  BU.tsPrint("Daily Consumption Remaining: " .. tostring(modData.dailyConsumptionRemaining))
  BU.tsPrint("Is Lost In The Sauce: " .. tostring(modData.isLostInTheSauce))
end

return BU