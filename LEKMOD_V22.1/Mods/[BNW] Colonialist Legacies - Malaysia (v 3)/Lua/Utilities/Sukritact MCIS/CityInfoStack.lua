-- Sukritact_ModularCityInfoStack
-- Author: Sukritact
--=======================================================================================================================
-- Prevent Duplicates
--=======================================================================================================================
if MapModData.Sukritact_ModularCityInfoStack then return end
MapModData.Sukritact_ModularCityInfoStack = true
Events.SequenceGameInitComplete.Add(function() MapModData.Sukritact_ModularCityInfoStack = nil end)
--=======================================================================================================================

print("loaded")

--=======================================================================================================================
-- Globals
--=======================================================================================================================
include("InstanceManager")

tCityInfoAddins = {}
tCityInfoStack = InstanceManager:new("IconInstance", "IconFrame", Controls.IconStack)

bCityScreenOpen = false
--=======================================================================================================================
-- Main Code
--=======================================================================================================================
-- Importing City Info Addins
-------------------------------------------------------------------------------------------------------------------------
function RequestCityInfoStackDataRefresh()
	tCityInfoAddins = {}
	tEventsToHook = {}
	LuaEvents.CityInfoStackDataRefresh(tCityInfoAddins, tEventsToHook)
	
	table.sort(tCityInfoAddins, Sort)
	
	for iKey, tEvent in pairs(tEventsToHook) do
		tEvent.Remove(CityInfoStackDirty)
		tEvent.Add(CityInfoStackDirty)
	end
end
LuaEvents.RequestCityInfoStackDataRefresh.Add(RequestCityInfoStackDataRefresh)

function Sort(a, b)
	if a.SortOrder == nil then a.SortOrder = 0 end
	if b.SortOrder == nil then b.SortOrder = 0 end
	
	if a.SortOrder == b.SortOrder then
		return Locale.Compare(a.Key, b.Key) < 0
	else
		return a.SortOrder < b.SortOrder
	end
end
-------------------------------------------------------------------------------------------------------------------------
-- Opening the City Screen
-------------------------------------------------------------------------------------------------------------------------
function ProcessCityScreen()
	Controls.IconStackPanel:SetHide(false)
	tCityInfoStack:ResetInstances()
	
	for iKey, tTable in ipairs(tCityInfoAddins) do
		tCityInfoStack:BuildInstance()
		local pInstance = tCityInfoStack:GetInstance()
		LuaEvents.CityInfoStackDirty(tTable.Key, pInstance)
		Controls.IconStack:ReprocessAnchoring()
		Controls.IconStackScroll:CalculateInternalSize()
	end
	
	Controls.IconStack:ReprocessAnchoring()
	Controls.IconStackScroll:CalculateInternalSize()
end

function EventEnterCityScreen()
	bCityScreenOpen = true
	ProcessCityScreen()
end
Events.SerialEventEnterCityScreen.Add(EventEnterCityScreen)

function CityInfoStackDirty()
	if bCityScreenOpen then
		ProcessCityScreen()
	end
end
-------------------------------------------------------------------------------------------------------------------------
-- EventExitCityScreen
-------------------------------------------------------------------------------------------------------------------------
function EventExitCityScreen()
	bCityScreenOpen = false
	Controls.IconStackPanel:SetHide(true)
end
Events.SerialEventExitCityScreen.Add(EventExitCityScreen)
--=======================================================================================================================
-- Initialise
--=======================================================================================================================
if not(OptionsManager.GetSmallUIAssets()) then Controls.IconStackPanel:SetOffsetX(279) end

Events.LoadScreenClose.Add(
	function()
		LuaEvents.RequestCityInfoStackDataRefresh()
	end
)
--=======================================================================================================================
--=======================================================================================================================