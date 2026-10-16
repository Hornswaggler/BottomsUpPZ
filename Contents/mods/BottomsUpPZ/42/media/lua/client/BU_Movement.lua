require "TimedActions/WalkToTimedAction"

BUMovementVector = Vector2.new()  

---@param player IsoPlayer | IsoGameCharacter
local function updatePlayerLocation(player)
  if not player or player:isDead() then return end

  if player:isPlayerMoving() then
    player:getDeferredMovement(BUMovementVector)

    player.setX(player, player:getX() + (BUMovementVector:getX() * 0.5))
    player.setY(player, player:getY() + (BUMovementVector:getY() * 0.5))
  end
end

---@param player IsoPlayer | IsoGameCharacter
local function handlePlayerUpdate(player)
  if not player or player:isDead() or player:isCurrentActionPathfinding() then return end
  updatePlayerLocation(player)
end

Events.OnPlayerUpdate.Add(handlePlayerUpdate)

local parentWalkToTimedActionUpdate = ISWalkToTimedAction.update

function ISWalkToTimedAction:update()
  parentWalkToTimedActionUpdate(self)
  if self.character and self.character:isPlayerMoving() then
    print("Inside the timed action update...")
    updatePlayerLocation(self.character)
  end
end
