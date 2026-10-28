BUModData = BUModData or {
  lastDrinkTimestamp = 0,
  tolerance = 1
}

---@param player IsoPlayer
---@return table
function BUModData.getPlayerModData(player)
  local modData = player:getModData()
  if not modData.BU then
    modData.BU = {
      lastDrinkTimestamp = 0,
      tolerance = 1
    }
  end
  return modData.BU
end

---@param player IsoPlayer
function BUModData.getPlayerLastDrinkTimestamp(player)
  local modData = BUModData.getPlayerModData(player)
  return modData.lastDrinkTimestamp
end

---@param player IsoPlayer
---@param newTimestamp integer
function BUModData.setPlayerLastDrinkTimestamp(player, newTimestamp)
  local modData = BUModData.getPlayerModData(player)
  modData.lastDrinkTimestamp = newTimestamp
end