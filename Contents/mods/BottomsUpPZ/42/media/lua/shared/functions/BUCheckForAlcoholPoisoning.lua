-- local BU = require "BU"

---@param player IsoPlayer
---@return boolean
local function checkForAlcoholPoisoning(player)
  -- local player = getPlayer()
  -- if not player or player:isDead() then return end

  -- BU.syncAnimStates(player:getOnlineID(), player)

  local stats = player:getStats()
  local drunkenness = stats:get(CharacterStat.INTOXICATION)
  if not drunkenness then return false end

  print("Drunkenness: " .. tostring(drunkenness))
  -- local isLostInTheSauce = false

  if drunkenness > 85.0 then
    -- if isServer() then
    -- isLostInTheSauce = true
      -- BU.Commands.setModDataValue(player, "isLostInTheSauce", true)
    -- end
    -- print("Alcohol poisoning detected!")
    local severity = (drunkenness - 85.0) / 15.0

    local damageAmount = 3.0 + (severity * 7.0)
    -- local currentHealth = bodyDamage:getOverallBodyHealth()

    -- local bodyDamage = player:getBodyDamage()
    player:Say("I don't feel so good...")

    -- if isClient() then
    -- ISTimedActionQueue.add(BUTimedActionVomit:new(player))
    -- end

    print("last time user had drink CAP:" .. tostring(BU.Commands.getModDataValue(player, "lastDrinkTimestamp")))
    -- bodyDamage:ReduceGeneralHealth(damageAmount)
  end

  return drunkenness > 85.0

  -- BU.Commands.setModDataValue(player, "isLostInTheSauce", isLostInTheSauce)
end

-- Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)

return checkForAlcoholPoisoning