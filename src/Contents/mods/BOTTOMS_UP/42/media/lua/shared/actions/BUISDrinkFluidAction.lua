-- local BU = require ("BU")
local checkForAlcoholPoisoning = require("functions/BUCheckForAlcoholPoisoning")

local baseFluidAction = {}

baseFluidAction.InitBUDrinkAction = function(drinkFluidAction)
  local player = drinkFluidAction.character
  if player:hasTrait(CharacterTrait.get(ResourceLocation.of(BU.cfg.HEAVY_DRINKER_TRAIT_ID))) then
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

---@param drinkFluidAction ISDrinkFluidAction
---@param delta number
baseFluidAction.onPlayerConsumedAlcohol = function(drinkFluidAction, delta)

  print("Updating daily consumption..." .. tostring(isServer()))

  -- todo: type safety?
  if drinkFluidAction.buIsAlcoholicDrink then
    local alcoholAmount = delta * drinkFluidAction.buAlcoholAmount
    BU.cmd.updateDailyConsumptionRemaining(drinkFluidAction.character, alcoholAmount * -1)
    BU.cmd.updateTolerance(drinkFluidAction.character, alcoholAmount)
    BU.cmd.updateLastDrinkTimestamp(drinkFluidAction.character)
    BU.cmd.setModDataValue(drinkFluidAction.character, "isLostInTheSauce", checkForAlcoholPoisoning(drinkFluidAction.character))
  end
end

return baseFluidAction
