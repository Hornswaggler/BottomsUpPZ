if isMultiplayer() then return end

local BaseFluidAction = require("actions/BUISDrinkFluidAction")

local superStart = ISDrinkFluidAction.start
function ISDrinkFluidAction:start()
  print("Starting to drink...")
  BaseFluidAction.InitBUDrinkAction(self) 
  superStart(self)
end

local superPerform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform()
  print("Perform complete" .. " is server? " .. tostring(isServer()))
  print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) )

  BaseFluidAction.onPlayerConsumedAlcohol(self, 1)
  
  superPerform(self)
end

local superStop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop()
  print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) .. " delta " .. tostring(self:getJobDelta()) )
  BaseFluidAction.onPlayerConsumedAlcohol(self, self:getJobDelta())

  superStop(self)
end