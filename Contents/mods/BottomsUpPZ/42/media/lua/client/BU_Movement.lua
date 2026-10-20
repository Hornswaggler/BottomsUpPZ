require "TimedActions/WalkToTimedAction"

local swayTimer = 0.0

local SWAY_FREQUENCY = 1.0 
local SWAY_AMPLITUDE = 0.5

local forwardVector = Vector2.new()
local swayVector = Vector2.new()

local lastTick = getTimestampMs()

---@param player IsoPlayer | IsoGameCharacter
---@param moveX number
---@param moveY number
local function applyDrunkSway(player, moveX, moveY)
    local deltaTime = getTimestampMs() - lastTick

    print("Delta Time" .. tostring(deltaTime))

    player:getForwardDirection(forwardVector)
    swayVector:set(forwardVector)

    swayVector:rotate(Math.PI / 2.0)
    swayVector:normalize()

    local radiansPerMs = (SWAY_FREQUENCY * 6.283185) / 1000.0
    swayTimer = swayTimer + (deltaTime * radiansPerMs)
    if swayTimer >= 6.283185 then 
        swayTimer = swayTimer - 6.283185 
    end

    local swayFactor = math.sin(swayTimer) * SWAY_AMPLITUDE
    local dx = moveX + (-moveY * swayFactor)
    local dy = moveY + (moveX * swayFactor)

    lastTick = getTimestampMs()

    return dx, dy
end

local collisionBoudary = Vector2.new()
local deferredMovementVector = Vector2.new()  

---@param player IsoPlayer | IsoGameCharacter
local function updatePlayerLocation(player)
  if not player or player:isDead() then return end

  
  -- if true then return end

  if player:isPlayerMoving() then
    player:getDeferredMovement(deferredMovementVector)
    -- deferredMovementVector:setLength( (deferredMovementVector:getLength() * 0.5))   

    collisionBoudary:set(deferredMovementVector) 
    collisionBoudary:normalize()
    collisionBoudary:setLength(player:getWidth())

    local nextX = player:getX() + collisionBoudary:getX()
    local nextY = player:getY() + collisionBoudary:getY()

    if fastfloor(nextY) - fastfloor(player:getY()) ~= 0 or 
        fastfloor(nextX) - fastfloor(player:getX()) ~= 0 then

      local nextGridSquare = getCell():getGridSquare(fastfloor(nextX), fastfloor(nextY), player:getZ())

      if not nextGridSquare:isFree(false) or 
          nextGridSquare:isBlockedTo(player:getSquare()) then return end
    end

    local newX, newY = applyDrunkSway(player, deferredMovementVector:getX(), deferredMovementVector:getY())

    player.setX(player, newX + player:getX())
    player.setY(player, newY + player:getY ())


    -- player.setX(player, player:getX() + deferredMovementVector:getX())
    -- player.setY(player, player:getY() + deferredMovementVector:getY())
  end
end

---@param player IsoPlayer | IsoGameCharacter
local function onPlayerUpdate(player)
  if not player or player:isDead() or player:isCurrentActionPathfinding() then return end
  updatePlayerLocation(player)
end

--TODO: Wrap handlePlayerUpdate in pcall to prevent crashes from mod conflicts
-- local function ProcessZombieHitboxes()
--     pcall(handlePlayerUpdate)
-- end

Events.OnPlayerUpdate.Add(onPlayerUpdate)

local parentWalkToTimedActionUpdate = ISWalkToTimedAction.update

function ISWalkToTimedAction:update()
  parentWalkToTimedActionUpdate(self)
  if self.character and self.character:isPlayerMoving() then
    print("Inside the timed action update...")
    updatePlayerLocation(self.character)
  end
end
