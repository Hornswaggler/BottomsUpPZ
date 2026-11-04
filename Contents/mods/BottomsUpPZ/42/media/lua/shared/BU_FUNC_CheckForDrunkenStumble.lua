local BU = require "BU_STATE"

local consecutiveStumbles = BU.STUMBLE_COOLDOWN

---@param player IsoPlayer
local function performStumble(player)
  player:setBumpType("stagger")
  player:setVariable("BumpFall", true)
  player:setVariable("BumpFallType", "drunk")
end

---@return boolean
local function didDrunkenStumble()
  if ZombRand(BU.STUMBLE_MAX) > BU.STUMBLE_THRESHOLD then
    if consecutiveStumbles >= BU.STUMBLE_COOLDOWN then
      consecutiveStumbles = 0
      return true
    else
      consecutiveStumbles = consecutiveStumbles + 1
    end
  end
  return false
end

local function checkForDrunkenStumble()
  local player = getPlayer()
  if not player 
    or player:isDead() 
    or not player:isPlayerMoving() 
    or player:isAsleep()
  then return end

  if didDrunkenStumble() then performStumble(player) end
end

return checkForDrunkenStumble
