local BUModData = require("model/BUModData")
local BUAnimState = require("model/BUAnimState")


---@class BUCmd
---@alias BUCmdName keyof BUCmd
local buCmd = {}

---@return BUModData
local newModData = function()
  ---@type BUModData
  local result = {}
  for k, v in pairs(BUModData) do
    print("Copying mod data key: " .. tostring(k) .. " = " .. tostring(v))
    result[k] = v
  end
  return result
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
buCmd.getPlayerModData = function(player)
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
buCmd.setModDataValue = function(player, key, value)
  BU.util.tsPrint("Setting mod data value for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
  local modData = buCmd.getPlayerModData(player)
  modData[key] = value
  for _, animState in ipairs(BUAnimState) do
    if animState.key == key then
      BU.util.tsPrint("Setting anim state for player " .. tostring(player:getUsername()) .. ": " .. tostring(key) .. " = " .. tostring(value))
      setAnimVariable(player, animState.variable, modData[animState.key])
    end
  end

  BU.util.buSendServerCommand(
    player, "setModDataValue",
    {key, value}
  )
end

buCmd.userJoined = function(player)
  BU.util.tsPrint("User joined: " .. tostring(player:getUsername()))

  if isServer() then
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
      local eachPlayer = players:get(i)
      for _, animState in ipairs(BUAnimState) do
        print("Syncing anim state for player " .. tostring(player:getUsername()) .. ": " .. tostring(animState.key))
        local value =  BU.cmd.getModDataValue(eachPlayer, animState.key)
        -- BU.Commands.setModDataValue(player, animState.key, value)
        BU.util.buSendServerCommand(
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

buCmd.notifyUserJoined = function(player)
  BU.util.tsPrint("Notifying user joined: " .. tostring(player:getUsername()))
  BU.util.buSendClientCommandList(player, "userJoined")
end

---@param player IsoPlayer
---@param key BUModKeys
---@return BUModData[BUModKeys]
buCmd.getModDataValue = function(player, key)
  local modData = buCmd.getPlayerModData(player)
  return modData[key] or freshModData[key]
end

---@param player IsoPlayer
buCmd.updateLastDrinkTimestamp = function(player)
  buCmd.setModDataValue(player, "lastDrinkTimestamp", getGametimeTimestamp())
end

---@param player IsoPlayer
---@param delta number
buCmd.updateDailyConsumptionRemaining = function(player, delta)
  BU.util.tsPrint("Updating daily consumption remaining by " .. tostring(delta) .. " for player " .. tostring(player:getUsername()))
  buCmd.setModDataValue(player, "dailyConsumptionRemaining", buCmd.getModDataValue(player, "dailyConsumptionRemaining") + delta)
end

---@param player IsoPlayer
buCmd.syncAnimStates = function(player)
  local modData = buCmd.getPlayerModData(player)
  for _, animState in ipairs(BUAnimState) do
    local value = modData[animState.key]
    setAnimVariable(player, animState.variable, value)
    BU.util.buSendServerCommand(
      player,
      "setModDataValue",
      {animState.key, value}
    )
  end
end


buCmd.syncAllPlayerAnimStates = function()
  local players = getOnlinePlayers()
  for i = 0, players:size() - 1 do
    local eachPlayer = players:get(i)
    buCmd.syncAnimStates(eachPlayer)
  end
end

---@param player IsoPlayer
---@param delta number
buCmd.updateTolerance = function(player, delta)
  print("Player drank: " .. tostring(delta) .. " pure alcohol. Updating tolerance for player " .. tostring(player:getUsername()))
  
  local tolerance = buCmd.getModDataValue(player, "tolerance")
  local maxTolerance = 0.01
  local toleranceScalar = 0.05
  local newTolerance = tolerance - delta * toleranceScalar

  print("New Tolerance: " .. tostring(newTolerance))

  buCmd.setModDataValue(player, "tolerance", newTolerance >= maxTolerance and newTolerance or maxTolerance)
end

return buCmd