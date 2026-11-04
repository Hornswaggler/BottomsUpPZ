
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