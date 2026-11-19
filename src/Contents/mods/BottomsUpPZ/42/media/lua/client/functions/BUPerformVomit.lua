local function performVomit(player)
  if not player or player:isDead() then return end
  ISTimedActionQueue.add(BUTimedActionVomit:new(player))
end

return performVomit