local STUMBLE_MAX = 100
local STUMBLE_THRESHOLD = 75
local STUMBLE_COOLDOWN = 5

local consecutiveStumbles = STUMBLE_COOLDOWN

---@param player IsoPlayer
local function performStumble(player)
  player:setBumpType("stagger")
  player:setVariable("BumpFall", true)
  player:setVariable("BumpFallType", "drunk")
end

---@return boolean
local function didDrunkenStumble()
  if ZombRand(STUMBLE_MAX) > STUMBLE_THRESHOLD then
    if consecutiveStumbles >= STUMBLE_COOLDOWN then
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
  if not player or player:isDead() then return end
  if didDrunkenStumble() then performStumble(player) end
end

Events.EveryOneMinute.Add(checkForDrunkenStumble)