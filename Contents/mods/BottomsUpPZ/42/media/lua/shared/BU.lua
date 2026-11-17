local BUModData = require("model/BUModData")
local BUCommands = require("model/BUCommands")
local BUUtil = require("model/BUUtil")
local BUConfig = require("model/BUConfig")

---@class BUDataPacketPayload
---@field key BUModKeys
---@field value BUModData[BUModKeys]

---@class BUDataPacket: table
---@field payload BUDataPacketPayload
---@field playerId integer

---@class BU
BU = BU or {}

BU.module = "BU"
BU.Util = BUUtil
BU.Config = BUConfig
BU.Commands = BUCommands
BU.modData = BUModData

return BU