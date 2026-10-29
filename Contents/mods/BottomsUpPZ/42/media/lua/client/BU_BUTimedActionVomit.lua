
---@class BUVomitTimedAction: ISBaseTimedAction
BUTimedActionVomit = ISBaseTimedAction:derive("BUVomitTimedAction")

function BUTimedActionVomit:new(player)
  ---@type ISBaseTimedAction
  local o = ISBaseTimedAction.new(self, player)
  
  o.useProgressBar, o.stopOnWalk, o.stopOnRun, o.stopOnAim = false, false, false, false
  o.maxTime = (106/30) * 60 -- 30 ticks = 1 second of animation time
  return o
end

---@return boolean
function BUTimedActionVomit:isValid()
  return self.character ~= nil and not self.character:isDead()
end

-- TODO: Sound should be hooked in at the animation layer
function BUTimedActionVomit:start()
  print("BUVomitTimedAction:start()")
  self.soundID = self.character:getEmitter():playSound("BU_Vomit")
  self:setActionAnim("buVomit")
end

function BUTimedActionVomit:perform()
  print("BUVomitTimedAction:perform()")
  ISBaseTimedAction.perform(self)
end

function BUTimedActionVomit:stop()
  print("BUVomitTimedAction:stop()")
  if self.soundID and self.character:getEmitter():isPlaying(self.soundID) then
    self.character:getEmitter():stopSound(self.soundID)
  end
  ISBaseTimedAction.stop(self)
end

function BUTimedActionVomit:createInGameUi()
  return nil
end