---@class BUModData
---@alias BUModKeys keyof BUModData
local BUModData = {}
BUModData.lastDrinkTimestamp = 0
BUModData.tolerance = 1
BUModData.dailyConsumptionTarget = 1.0
BUModData.dailyConsumptionRemaining = 1.0
BUModData.isLostInTheSauce = false

return BUModData