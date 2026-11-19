local consecutiveStumbles = BU.cfg.STUMBLE_COOLDOWN

---@param player IsoPlayer
local function doStumble(player)
  player:setBumpType("stagger")
  player:setVariable("BumpFall", true)
  player:setVariable("BumpFallType", "drunk")
end

---@return boolean
local function didDrunkenStumble()
  if ZombRand(BU.cfg.STUMBLE_MAX) > BU.cfg.STUMBLE_THRESHOLD then
    if consecutiveStumbles >= BU.cfg.STUMBLE_COOLDOWN then
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

  if BU.cmd.getModDataValue(player, "isLostInTheSauce") 
    and didDrunkenStumble() 
  then doStumble(player) end
end

return checkForDrunkenStumble
