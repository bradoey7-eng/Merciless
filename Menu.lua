-- Menu module.
local Menu = {}

---@module GUI.ThemeManager
local ThemeManager = require("GUI/ThemeManager")

---@module GUI.SaveManager
local SaveManager = require("GUI/SaveManager")

---@module GUI.Library
local Library = require("GUI/Library")

---@module Menu.CombatTab
local CombatTab = require("Menu/CombatTab")

---@module Menu.GameTab
local GameTab = require("Menu/GameTab")

---@module Menu.AutomationTab
local AutomationTab = require("Menu/AutomationTab")

---@module Menu.BuilderTab
local BuilderTab = require("Menu/BuilderTab")

---@module Menu.VisualsTab
local VisualsTab = require("Menu/VisualsTab")

---@module Menu.ExploitTab
local ExploitTab = require("Menu/ExploitTab")

---@module Menu.LycorisTab
local LycorisTab = require("Menu/LycorisTab")   -- we'll rename this folder later if needed

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

-- Services.
local runService = game:GetService("RunService")
local stats = game:GetService("Stats")
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

-- Signals.
local renderStepped = Signal.new(runService.RenderStepped)

-- Maids.
local menuMaid = Maid.new()

-- Title - changed to generic
local MENU_TITLE = "Merciless | Deepwoken"

---Initialize menu.
function Menu.init()
	local window = Library:CreateWindow({
		Title = MENU_TITLE,
		Center = true,
		AutoShow = not shared.Merciless.silent,
		TabPadding = 8,
		MenuFadeTime = 0.0,
	})

	ThemeManager:SetLibrary(Library)
	ThemeManager:SetFolder("Merciless-Themes")

	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("Merciless-Configs")
	SaveManager:SetIgnoreIndexes({
		"Fly", "NoClip", "Speedhack", "InfiniteJump",
		"TweenToObjective", "TweenToBack",
	})

	CombatTab.init(window)
	BuilderTab.init(window)
	GameTab.init(window)
	VisualsTab.init(window)
	AutomationTab.init(window)
	ExploitTab.init(window)
	LycorisTab.init(window)   -- this tab name can be changed later

	Logger.warn("Menu initialized.")
end

---Detach menu.
function Menu.detach()
	menuMaid:clean()
	BuilderTab.detach()
	Library:Unload()
end

return Menu
