---@class BUModData
---@field tolerance number a scalar value representing the player's tolerance to alcohol, where lower values indicate greater tolerance
---@alias BUModKeys keyof BUModData
local BUModData = {}
BUModData.lastDrinkTimestamp = 0
BUModData.tolerance = 5
BUModData.dailyConsumptionTarget = 1.0
BUModData.dailyConsumptionRemaining = 1.0
BUModData.isLostInTheSauce = false

return BUModData