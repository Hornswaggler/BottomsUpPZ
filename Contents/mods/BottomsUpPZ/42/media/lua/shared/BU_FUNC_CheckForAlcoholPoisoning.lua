local function checkForAlcoholPoisoning()
  local player = getPlayer()
  if not player or player:isDead() then return end

  if isServer() then
    BU.tsPrint("Running server side...")
  end

  BU.syncAnimStates(player:getOnlineID(), player)

  local stats = player:getStats()
  local drunkenness = stats:get(CharacterStat.INTOXICATION)
  if not drunkenness then return end

  print("Drunkenness: " .. tostring(drunkenness))

  if drunkenness > 85.0 then
    BU.setModDataValue(player, "isLostInTheSauce", true)
    -- print("Alcohol poisoning detected!")
    local severity = (drunkenness - 85.0) / 15.0

    local damageAmount = 3.0 + (severity * 7.0)
    -- local currentHealth = bodyDamage:getOverallBodyHealth()

    -- local bodyDamage = player:getBodyDamage()
    player:Say("I don't feel so good...")

    ISTimedActionQueue.add(BUTimedActionVomit:new(player))

    -- print("last time user had drink CAP:" .. tostring(BU.getPlayerLastDrinkTimestamp(player)))
    -- bodyDamage:ReduceGeneralHealth(damageAmount)
  else
    BU.setModDataValue(player, "isLostInTheSauce", false)
  end
end

-- Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)

return checkForAlcoholPoisoning