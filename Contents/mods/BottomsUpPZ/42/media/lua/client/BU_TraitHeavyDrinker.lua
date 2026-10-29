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

local superStart = ISDrinkFluidAction.start
function ISDrinkFluidAction:start()

  local player = self.character
  if player:hasTrait(CharacterTrait.get(ResourceLocation.of(BU.HEAVY_DRINKER_TRAIT_ID))) then
    print("Player has the heavy drinker trait")
  else
    print("Player does not have the trait...")
  end

  self.buAlcoholAmount = 0.0
  self.buIsAlcoholicDrink = false

  if self.item:isFluidContainer() then
    local fluidContainer =  self.item:getFluidContainer()
    if fluidContainer:getPrimaryFluid():isCategory(FluidCategory.Alcoholic) then
      self.buIsAlcoholicDrink = true
      local alcoholPercentage = fluidContainer:getProperties():getAlcohol()

      -- the total amount of 100% pure alcohol the user might consume
      self.buAlcoholAmount = fluidContainer:getPrimaryFluidAmount() * self.percentage * alcoholPercentage

      print("Player drinking alcohol: " .. tostring(self.buAlcoholAmount) .. " liters of pure alcohol.")
    end
  end

  superStart(self)
end

local superPerform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform()
  ---@diagnostic disable-next-line: unnecessary-if
  if self.buIsAlcoholicDrink then
    BU.updateDailyConsumptionRemaining(self.character, self.buAlcoholAmount * -1)
  end
  superPerform(self)
end

local superStop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop()
  ---@diagnostic disable-next-line: unnecessary-if
  if self.buIsAlcoholicDrink 
    and self.item:isFluidContainer() 
    and not self.item:getFluidContainer():isEmpty()
  then
    BU.updateDailyConsumptionRemaining(self.character, self:getJobDelta() * self.buAlcoholAmount * -1)
  end 
  superStop(self)
end

local function handlePlayerAlcoholUrge()
  print("Handling Urge")
  local player = getPlayer()
  if not player or player:isDead() then return end
  local dailyConsumptionTarget = BU.getPlayerDailyConsumptionTarget(player)
  BU.updateDailyConsumptionRemaining(player, dailyConsumptionTarget / 24)
end

Events.EveryHours.Add(handlePlayerAlcoholUrge)