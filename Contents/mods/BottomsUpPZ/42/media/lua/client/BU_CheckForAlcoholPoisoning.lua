local function checkForAlcoholPoisoning()
  local player = getPlayer()
  if not player or player:isDead() then return end

  -- TODO: set Drunken Stumble when???
  player:setVariable("isLostInTheSauce", true)

  local stats = player:getStats()

  local drunkenness = stats:get(CharacterStat.INTOXICATION)
  if not drunkenness then return end

  print("Drunkenness: " .. tostring(drunkenness))

  -- if drunkenness > 85.0 then
  -- print("Alcohol poisoning detected!")
  local severity = (drunkenness - 85.0) / 15.0

  local damageAmount = 3.0 + (severity * 7.0)
  -- local currentHealth = bodyDamage:getOverallBodyHealth()

  -- local bodyDamage = player:getBodyDamage()
  player:Say("I don't feel so good...")

  ISTimedActionQueue.add(BUTimedActionVomit:new(player))

  print("last time user had drink CAP:" .. tostring(BU.getPlayerLastDrinkTimestamp(player)))

  -- bodyDamage:ReduceGeneralHealth(damageAmount)
  -- end
end

Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)