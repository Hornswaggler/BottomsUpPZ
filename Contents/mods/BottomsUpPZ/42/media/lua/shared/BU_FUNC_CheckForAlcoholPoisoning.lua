local BU = require "BU"

---@param player IsoPlayer
local function checkForAlcoholPoisoning(player)
  -- local player = getPlayer()
  -- if not player or player:isDead() then return end

  -- BU.syncAnimStates(player:getOnlineID(), player)

  local stats = player:getStats()
  local drunkenness = stats:get(CharacterStat.INTOXICATION)
  if not drunkenness then return end

  print("Drunkenness: " .. tostring(drunkenness))

  if drunkenness > 85.0 then
    if isServer() then
      BU.Commands.setModDataValue(player, "isLostInTheSauce", true)
    end
    -- print("Alcohol poisoning detected!")
    local severity = (drunkenness - 85.0) / 15.0

    local damageAmount = 3.0 + (severity * 7.0)
    -- local currentHealth = bodyDamage:getOverallBodyHealth()

    -- local bodyDamage = player:getBodyDamage()
    player:Say("I don't feel so good...")

    if isClient() then
      ISTimedActionQueue.add(BUTimedActionVomit:new(player))
    end

    print("last time user had drink CAP:" .. tostring(BU.Commands.getModDataValue(player, "lastDrinkTimestamp")))
    -- bodyDamage:ReduceGeneralHealth(damageAmount)
  else
    if isServer() then
      BU.Commands.setModDataValue(player, "isLostInTheSauce", false)
    end
  end
end

-- Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)

return checkForAlcoholPoisoning