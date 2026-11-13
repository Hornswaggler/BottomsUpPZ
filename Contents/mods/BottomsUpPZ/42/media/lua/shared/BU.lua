local BUModData = require("BUModData")
local BUCommands = require("BUCommands")
local BUUtil = require("BUUtil")
local BUConfig = require("BUConfig")

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