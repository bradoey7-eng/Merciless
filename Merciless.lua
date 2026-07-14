-- Detach and initialize a Merciless instance.
local Merciless = { queued = false, silent = false, dpscanning = false, norpc = false }

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.Hooking
local Hooking = require("Game/Hooking")

---@module Menu
local Menu = require("Menu")

---@module Features
local Features = require("Features")

---@module Utility.ControlModule
local ControlModule = require("Utility/ControlModule")

---@module Game.InputClient
local InputClient = require("Game/InputClient")

---@module Game.PlayerScanning
local PlayerScanning = require("Game/PlayerScanning")

---@module Game.Timings.SaveManager
local SaveManager = require("Game/Timings/SaveManager")

---@module Features.Combat.StateListener
local StateListener = require("Features/Combat/StateListener")

---@module Utility.PersistentData
local PersistentData = require("Utility/PersistentData")

---@module Game.KeyHandling
local KeyHandling = require("Game/KeyHandling")

---@module Game.QueuedBlocking
local QueuedBlocking = require("Game/QueuedBlocking")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Game.Timings.ModuleManager
local ModuleManager = require("Game/Timings/ModuleManager")

---@module Utility.CoreGuiManager
local CoreGuiManager = require("Utility/CoreGuiManager")

---@module Game.ServerHop
local ServerHop = require("Game/ServerHop")

---@module Game.Wipe
local Wipe = require("Game/Wipe")

---@module Features.Automation.EchoFarm
local EchoFarm = require("Features/Automation/EchoFarm")

---@module Features.Automation.JoyFarm
local JoyFarm = require("Features/Automation/JoyFarm")

-- Merciless maid.
local mercilessMaid = Maid.new()

-- Constants.
local LOBBY_PLACE_ID = 4111023553
local DEPTHS_PLACE_ID = 5735553160
local CHIME_LOBBY_PLACE_ID = 12559711136

-- Services.
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Timestamp.
local startTimestamp = os.clock()

---Handle execution logging. (You can remove this whole function if you want zero logging)
local function handleExecutionLogging()
	-- You can leave this empty or remove calls to it below if you want to stay lowkey
end

---Initialize instance.
function Merciless.init()
	local localPlayer = nil

	repeat
		task.wait()
	until game:IsLoaded()

	repeat
		localPlayer = playersService.LocalPlayer
	until localPlayer ~= nil

	if isfile and isfile("smarker.txt") then
		Merciless.silent = true
	end

	if isfile and isfile("dpscanning.txt") then
		Merciless.dpscanning = true
	end

	if isfile and isfile("norpc.txt") then
		Merciless.norpc = true
	end

	if game.PlaceId == CHIME_LOBBY_PLACE_ID or game.PlaceId == LOBBY_PLACE_ID then
		handleExecutionLogging()
	end

	if game.PlaceId == CHIME_LOBBY_PLACE_ID then
		return Logger.warn("Script has initialized in the Chime lobby.")
	end

	if game.PlaceId ~= LOBBY_PLACE_ID then
		KeyHandling.init()
		Hooking.init()
	end

	CoreGuiManager.set()
	PersistentData.init()

	if game.PlaceId == LOBBY_PLACE_ID then
		Logger.warn("Script has initialized in the lobby.")
	end

	if game.PlaceId == LOBBY_PLACE_ID then
		if PersistentData.get("shslot") then
			return ServerHop.lobby()
		end
		if PersistentData.get("wdata") then
			return Wipe.lobby()
		end
	end

	PersistentData.set("shslot", nil)

	if game.PlaceId == DEPTHS_PLACE_ID then
		if PersistentData.get("wdata") then
			Wipe.depths()
		end
	end

	if PersistentData.get("efdata") then
		EchoFarm.start()
	end

	if game.PlaceId == LOBBY_PLACE_ID then
		return
	end

	QueuedBlocking.init()
	SaveManager.init()
	ModuleManager.refresh()
	ControlModule.init()
	Features.init()
	Menu.init()
	PlayerScanning.init()
	StateListener.init()

	Logger.notify("Script has been initialized.")

	handleExecutionLogging()

	-- Rest of the init code (Rich Presence etc.) can stay or be removed later
end

---Detach instance.
function Merciless.detach()
	mercilessMaid:clean()
	ModuleManager.detach()
	JoyFarm.stop()
	Menu.detach()
	QueuedBlocking.detach()
	ControlModule.detach()
	Features.detach()
	SaveManager.detach()
	PlayerScanning.detach()
	CoreGuiManager.clear()
	StateListener.detach()
	Hooking.detach()
	Logger.warn("Script has been detached.")
end

return Merciless
