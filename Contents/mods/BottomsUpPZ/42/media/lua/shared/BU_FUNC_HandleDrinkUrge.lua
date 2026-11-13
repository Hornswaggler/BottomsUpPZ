-- alcoholism properties

-- tolerance: the higher the tolerance, able to drink more w/out getting sick
--  increases w/ regular drinking
--  How quickly?
--   we'll try... +1 -1 per day +2 for booze drink(s)
--
-- people who start w/ trait start w/ high tolerance
-- people w/out start at 0

-- Can gain this trait if you don't have it, if you drink frequently enough?? or... if your tolerance reaches a certain point


-- reduces panic? already does this
--
-- need to intercept event when/ where player drinks alcohol or ... just periodically check?
--
--
-- local parentUpdate = ISDrinkFluidAction.update
-- function ISDrinkFluidAction:update()
--   parentUpdate(self)
--   print("Drinking update" .. tostring(self))
-- end
--
-- increase character's TENSE state if character doesn't get drink
--
-- if characters tolerance too high, it becomes dependence and not drinking makes them slower
--  will get sick from not drinking and lose health...

-- local parentUpdate = ISDrinkFluidAction.update
-- function ISDrinkFluidAction:update()
--   -- print("Job Delta" .. tostring( self:getJobDelta()))
--   -- print("Delta" .. tostring(self:getDeltaModifiers()))

--   parentUpdate(self)
-- end
local BU = require "BU_STATE"

local function handleDrinkUrge()
  print("Handling Urge")
  local player = getPlayer()
  if not player or player:isDead() then return end
  local dailyConsumptionTarget = BU.Commands.getModDataValue(player, "dailyConsumptionTarget")
  BU.Commands.updateDailyConsumptionRemaining(player, dailyConsumptionTarget / 24)
end

return handleDrinkUrge
