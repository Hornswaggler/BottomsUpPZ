if not isServer() then return end

-- local BU = require ("BU")
local checkForAlcoholPoisoning = require("functions/BUCheckForAlcoholPoisoning")
local BaseFluidAction = require("actions/BUISDrinkFluidAction")

local superServerStart = ISDrinkFluidAction.serverStart
function ISDrinkFluidAction:serverStart()
  print("Starting timed action on server: " .. tostring(self.character))
  BaseFluidAction.InitBUDrinkAction(self)
  superServerStart(self)
end

local superStop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop()
  -- if isServer() then
  print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) .. " delta " .. tostring(self:getJobDelta()) )
  BaseFluidAction.updateDailyConsumptionRemaining(self, self:getJobDelta())
  -- end
  superStop(self)
end

-- todo should use pcall here...
local superComplete = ISDrinkFluidAction.complete
function ISDrinkFluidAction:complete()
  print("Called complete" .. " is server? " .. tostring(isServer()))
  print("self.buIsAlcoholicDrink: " .. tostring(self.buIsAlcoholicDrink) )
  BaseFluidAction.updateDailyConsumptionRemaining(self, 1)

return superComplete(self)
end