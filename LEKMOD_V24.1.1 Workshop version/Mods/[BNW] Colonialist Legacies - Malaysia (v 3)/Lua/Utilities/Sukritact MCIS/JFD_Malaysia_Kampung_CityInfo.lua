-- JFD_Malaysia_Kampung_CityInfo
-- Author: JFD
-- DateCreated: 11/21/2014 10:10:10 AM
--=======================================================================================================================
-- INCLUDES
--=======================================================================================================================
include("IconSupport")
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

function CityInfoStackDataRefresh(tCityInfoAddins, tEventsToHook)
   table.insert(tCityInfoAddins, {["Key"] = "JFD_Malaysia_Kampung_CityInfo", ["SortOrder"] = 1})
end
if isMalaysiaActivePlayer then
	LuaEvents.CityInfoStackDataRefresh.Add(CityInfoStackDataRefresh)
	LuaEvents.RequestCityInfoStackDataRefresh()
end
 
function CityInfoStackDirty(key, instance)
	if key ~= "JFD_Malaysia_Kampung_CityInfo" then return end
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
g_JFD_Malaysia_Kampung_TipControls = {}
TTManager:GetTypeControlTable("JFD_Malaysia_Kampung_Tooltip", g_JFD_Malaysia_Kampung_TipControls)
-------------------------------------------------------------------------------------------------------------------------
-- ProcessCityScreen
-------------------------------------------------------------------------------------------------------------------------
local buildingKampungID = GameInfoTypes["BUILDING_CL_KAMPUNG"]
function ProcessCityScreen(instance)
	-- Ensure City Selected
	local city = UI.GetHeadSelectedCity()
	if (not city) then
		instance.IconFrame:SetHide(true)
		return
	end
	instance.IconFrame:SetToolTipType("JFD_Malaysia_Kampung_Tooltip")
	IconHookup(0, 64, "CL_KAMPUNG_ATLAS", instance.IconImage)
	local bonus = city:GetNumBuilding(buildingKampungID)
	if bonus <= 0 then
		instance.IconFrame:SetHide(true)
		return
	end
	local textDescription = "[COLOR_POSITIVE_TEXT]" .. string.upper(Locale.ConvertTextKey("TXT_KEY_IMPROVEMENT_CL_KAMPUNG")) .. "[ENDCOLOR]"
	local textHelp = Locale.ConvertTextKey("TXT_KEY_CL_KAMPUNG_CITY_VIEW_HELP", bonus*5)
	g_JFD_Malaysia_Kampung_TipControls.Heading:SetText(textDescription)
	g_JFD_Malaysia_Kampung_TipControls.Body:SetText(textHelp)
	g_JFD_Malaysia_Kampung_TipControls.Box:DoAutoSize()
	instance.IconFrame:SetHide(false)
end
--=======================================================================================================================
--=======================================================================================================================
