---@param player IsoPlayer
---@param amount number
local function increaseNausea(player, amount)
  if not player or player:isDead() then return end
  player:getStats():add(CharacterStat.FOOD_SICKNESS, amount);
  getCore():setBlinkingMoodle("Sick");
end

return increaseNausea