local BU = require ("BU_STATE")
local checkForAlcoholPoisoning = require("BU_FUNC_CheckForAlcoholPoisoning")

local initBUDrinkAction = function(drinkFluidAction)
  local player = drinkFluidAction.character
    if player:hasTrait(CharacterTrait.get(ResourceLocation.of(BU.Config.HEAVY_DRINKER_TRAIT_ID))) then
      print("Player has the heavy drinker trait")
    else
      print("Player does not have the trait...")
    end

    drinkFluidAction.buAlcoholAmount = 0.0
    drinkFluidAction.buIsAlcoholicDrink = false

    if drinkFluidAction.item:isFluidContainer() then
      local fluidContainer =  drinkFluidAction.item:getFluidContainer()
      if fluidContainer:getPrimaryFluid():isCategory(FluidCategory.Alcoholic) then
        drinkFluidAction.buIsAlcoholicDrink = true
        local alcoholPercentage = fluidContainer:getProperties():getAlcohol()

        -- the total amount of 100% pure alcohol the user might consume
        drinkFluidAction.buAlcoholAmount = fluidContainer:getPrimaryFluidAmount() * drinkFluidAction.percentage * alcoholPercentage
      end
    end
end

local superServerStart = ISDrinkFluidAction.serverStart
function ISDrinkFluidAction:serverStart()
  print("Starting timed action on server: " .. tostring(self.character))
  initBUDrinkAction(self)
  superServerStart(self)
end

local superStart = ISDrinkFluidAction.start
function ISDrinkFluidAction:start()

  print("Starting to drink...")
  initBUDrinkAction(self) 
  -- local player = self.character
  -- if player:hasTrait(CharacterTrait.get(ResourceLocation.of(BU.CONST.HEAVY_DRINKER_TRAIT_ID))) then
  --   print("Player has the heavy drinker trait")
  -- else
  --   print("Player does not have the trait...")
  -- end

  -- self.buAlcoholAmount = 0.0
  -- self.buIsAlcoholicDrink = false

  -- if self.item:isFluidContainer() then
  --   local fluidContainer =  self.item:getFluidContainer()
  --   if fluidContainer:getPrimaryFluid():isCategory(FluidCategory.Alcoholic) then
  --     self.buIsAlcoholicDrink = true
  --     local alcoholPercentage = fluidContainer:getProperties():getAlcohol()

  --     -- the total amount of 100% pure alcohol the user might consume
  --     self.buAlcoholAmount = fluidContainer:getPrimaryFluidAmount() * self.percentage * alcoholPercentage
  --   end
  -- end

  superStart(self)
end

---@param drinkFluidAction ISDrinkFluidAction
---@param delta number
local updateDailyConsumptionRemaining = function(drinkFluidAction, delta)

  print("Updating daily consumption..." .. tostring(isServer()))

  if drinkFluidAction.buIsAlcoholicDrink then
    BU.Commands.updateDailyConsumptionRemaining(drinkFluidAction.character, delta * drinkFluidAction.buAlcoholAmount * -1)
    checkForAlcoholPoisoning(drinkFluidAction.character)
  end
end

local superPerform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform()
  print("Perform complete" .. " is server? " .. tostring(isServer()))
  print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) )


  -- updateDailyConsumptionRemaining(self)
  superPerform(self)
end

local superStop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop()
  if isServer() then
    print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) .. " delta " .. tostring(self:getJobDelta()) )
    -- updateDailyConsumptionRemaining(self, self:getJobDelta())
  end
  superStop(self)
end

-- todo should use pcall here...
local superComplete = ISDrinkFluidAction.complete
function ISDrinkFluidAction:complete()
  if isServer() then
    print("Called complete" .. " is server? " .. tostring(isServer()))
    print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) )
    updateDailyConsumptionRemaining(self, 1)
  end
  return superComplete(self)
end