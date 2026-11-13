local BUCommands = require("BUCommands")

---@class BUUtil
local BUUtil = {}
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

---@param player IsoPlayer
---@param command string
---@param payload BUDataPacket | nil
BUUtil.buSendClientCommand = function(player, command, payload)
  if isClient() and player:isLocalPlayer() then
    sendClientCommand(BU.module, command, {payload = payload or {}})
  end
end

---@param player IsoPlayer
---@param command string
---@param payload BUDataPacketPayload
BUUtil.buSendServerCommand = function(player, command, payload)
  if isServer() then
    sendServerCommand(BU.module, command,  {payload = payload, playerId = player:getOnlineID()})
  end
end

return BUUtil