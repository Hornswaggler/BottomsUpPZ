-- Todo is this required? no pun intended
require "TimedActions/ISTimedActionQueue"
require "TimedActions/ISBaseTimedAction"

---@class BUVomitTimedAction : ISBaseTimedAction
BUVomitTimedAction = ISBaseTimedAction:derive("BUVomitTimedAction")

function BUVomitTimedAction:new(player)
  ---@type ISBaseTimedAction
    local o =  ISBaseTimedAction.new(self, player)
    o.stopOnWalk, o.stopOnRun, o.stopOnAim = false, false, false
    o.maxTime = 90 -- 30 ticks = 1 second of animation time
    return o
end

---@return boolean
function BUVomitTimedAction:isValid()
  return self.character ~= nil and not self.character:isDead()
end

function BUVomitTimedAction:start()
  self:setActionAnim("buVomit")
end

function BUVomitTimedAction:perform()
  ISBaseTimedAction.perform(self)
end

function BUVomitTimedAction:stop()
    ISBaseTimedAction.stop(self)
end

function BUVomitTimedAction:createInGameUi()
    return nil
end


local function checkForAlcoholPoisoning()
  local player = getPlayer()
  if not player or player:isDead() then return end

  local stats = player:getStats()

  local drunkenness = stats:get(CharacterStat.INTOXICATION)
  if not drunkenness then return end

  print("Drunkenness: " .. tostring(drunkenness))

  -- if drunkenness > 85.0 then
    print("Alcohol poisoning detected!")
    local severity = (drunkenness - 85.0) / 15.0

    -- Reduce health. In PZ, maximum body health is 100.0
    -- Dealing 3 to 10 damage every 10 in-game minutes creates a lethal window
    local damageAmount = 3.0 + (severity * 7.0)
    --local currentHealth = bodyDamage:getOverallBodyHealth()
    
    -- print("Current health: " .. tostring(currentHealth))
    -- print("Damage amount: " .. tostring(math.max(0.0, currentHealth - damageAmount)))
    
    -- local bodyDamage = player:getBodyDamage()
    player:Say("I don't feel so good...")
    ISTimedActionQueue.add(BUVomitTimedAction:new(player))

    -- bodyDamage:ReduceGeneralHealth(damageAmount)
  -- end
end

Events.EveryTenMinutes.Add(checkForAlcoholPoisoning)