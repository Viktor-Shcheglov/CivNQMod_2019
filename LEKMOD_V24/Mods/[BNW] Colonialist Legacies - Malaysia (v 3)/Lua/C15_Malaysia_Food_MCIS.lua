-- C15_Malaysia_Food_MCIS
-- Author: Chrisy15
-- DateCreated: 4/17/2016 7:58:27 AM
--=======================================================================================================================
-- INCLUDES
--=======================================================================================================================
include("IconSupport")
--include("C15_Malaysia_Lua.lua")
--=======================================================================================================================
-- UTILITIES
--=======================================================================================================================
-- UTILS
-------------------------------------------------------------------------------------------------------------------------
-- JFD_IsCivilisationActive
function JFD_IsCivilisationActive(civilizationID)
	for iSlot = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local slotStatus = PreGame.GetSlotStatus(iSlot)
		if (slotStatus == SlotStatus["SS_TAKEN"] or slotStatus == SlotStatus["SS_COMPUTER"]) then
			if PreGame.GetCivilization(iSlot) == civilizationID then
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------------
-- GLOBALS
-------------------------------------------------------------------------------------------------------------------------
local activePlayerID		= Game.GetActivePlayer()
local activePlayer			= Players[activePlayerID]
local civilizationID 		= GameInfoTypes["CIVILIZATION_CL_MALAYSIA"]
local isMalaysiaCivActive	 = JFD_IsCivilisationActive(civilizationID)
local isMalaysiaActivePlayer = activePlayer:GetCivilizationType() == civilizationID
if isMalaysiaCivActive then
	print("Malaysia MCIS is loaded!")
end

function CityInfoStackDataRefresh(tCityInfoAddins, tEventsToHook)
   table.insert(tCityInfoAddins, {["Key"] = "C15_Malaysia_Food_MCIS", ["SortOrder"] = 1})
end
if isMalaysiaActivePlayer then
	LuaEvents.CityInfoStackDataRefresh.Add(CityInfoStackDataRefresh)
	LuaEvents.RequestCityInfoStackDataRefresh()
end
 
function CityInfoStackDirty(key, instance)
	if key ~= "C15_Malaysia_Food_MCIS" then return end
	ProcessCityScreen(instance)
end
if isMalaysiaActivePlayer then
	LuaEvents.CityInfoStackDirty.Add(CityInfoStackDirty)
end
if not(OptionsManager.GetSmallUIAssets()) then Controls.IconFrame:SetOffsetX(294) end
--=======================================================================================================================
-- CORE FUNCTIONS	
--=======================================================================================================================
-- Globals
--------------------------------------------------------------------------------------------------------------------------
g_C15_Malaysia_Food_MCIS_TipControls = {}
TTManager:GetTypeControlTable("C15_Malaysia_Food_MCIS_Tooltip", g_C15_Malaysia_Food_MCIS_TipControls)
-------------------------------------------------------------------------------------------------------------------------
-- ProcessCityScreen
-------------------------------------------------------------------------------------------------------------------------
local malaysiaMCISDummy = GameInfoTypes["BUILDING_C15_MALAY_MCIS_DUMMY"]
function ProcessCityScreen(instance)
	-- Ensure City Selected
	local city = UI.GetHeadSelectedCity()
	if (not city) then
		instance.IconFrame:SetHide(true)
		return
	end
	instance.IconFrame:SetToolTipType("C15_Malaysia_Food_MCIS_Tooltip")
	IconHookup(35, 64, "UNIT_ACTION_ATLAS", instance.IconImage)
	local bonus = city:GetNumRealBuilding(malaysiaMCISDummy)
	if bonus <= 0 then
		instance.IconFrame:SetHide(true)
		return
	end
	local textDescription = "[COLOR_POSITIVE_TEXT]" .. string.upper(Locale.ConvertTextKey("TXT_KEY_C15_MALAYSIA_MCIS_DESC")) .. "[ENDCOLOR]"
	local textHelp = Locale.ConvertTextKey("TXT_KEY_C15_MALAYSIA_MCIS_HELP", bonus)
	g_C15_Malaysia_Food_MCIS_TipControls.Heading:SetText(textDescription)
	g_C15_Malaysia_Food_MCIS_TipControls.Body:SetText(textHelp)
	g_C15_Malaysia_Food_MCIS_TipControls.Box:DoAutoSize()
	instance.IconFrame:SetHide(false)
end
--=======================================================================================================================
--=======================================================================================================================
