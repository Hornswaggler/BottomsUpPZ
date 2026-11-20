local modData = require("model/BUModData")
local cmd = require("model/BUCmd")
local util = require("model/BUUtil")
local cfg = require("model/BUCfg")

---@class BUDataPacketPayload
---@field key BUModKeys
---@field value BUModData[BUModKeys]

---@class BUDataPacket: table
---@field payload BUDataPacketPayload
---@field playerId integer

---@class BU
BU = {}

BU.module = "BU"
BU.util = util
BU.cfg = cfg
BU.cmd = cmd
BU.modData = modData

return BU