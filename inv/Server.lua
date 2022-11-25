local Object = require 'object.Object'
local Common = require 'inv.Common'
local CraftManager = require 'inv.CraftManager'
local DeviceManager = require 'inv.DeviceManager'
local InvManager = require 'inv.InvManager'
local RPCManager = require 'inv.RPCManager'
local TaskManager = require 'inv.TaskManager'

local Server = Object:subclass()

function Server:init()
    local config = Common.loadJSON("server.json")

    self.invManager = InvManager(self)
    self.deviceManager = DeviceManager(self, config.overrides)
    self.craftManager = CraftManager(self)
    self.taskManager = TaskManager(self)
    self.rpcManager = RPCManager

    --self.craftManager:loadRecipes("recipes/minecraft.json")
    self.deviceManager:scanDevices()
end

function Server:send(clientID, message)
    rednet.send(clientID, message, Common.PROTOCOL)
end

function Server:onMessage(clientID, message)
    if self.rpcManager[message[1]] then
        self.rpcManager[message[1]](self, clientID, unpack(message[2]))
    end
end

function Server:mainLoop()

    --print(textutils.serialize(recipes))

    --print(cmgr:pullOrCraftItemsExt("minecraft:wooden_pickaxe",10,"turtle_1",1))

    --print(textutils.serialize(cmgr:scanItemsCraftable()))
    --print(textutils.serialize(mgr.itemDB))

    rednet.open(Common.getModemSide())
    --rednet.host(Common.PROTOCOL,os.getComputerLabel())
    while true do
        evt = {os.pullEventRaw()}
        --print(textutils.serialize(evt))
        --print(unpack(evt))
        if evt[1] == "rednet_message" then
            self:onMessage(evt[2], evt[3])
        elseif evt[1] == "peripheral" then
            self.deviceManager:addDevice(evt[2])
        elseif evt[1] == "peripheral_detach" then
            self.deviceManager:removeDevice(evt[2])
        elseif evt[1] == "terminate" then
            break
        end
    end
    --rednet.unhost(Common.PROTOCOL)
    rednet.close(Common.getModemSide())
end

return Server
