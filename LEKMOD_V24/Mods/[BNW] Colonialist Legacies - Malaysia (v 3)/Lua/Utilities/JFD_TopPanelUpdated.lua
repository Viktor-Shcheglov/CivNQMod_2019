-- JFD_TopPanelUpdated
-- Author: JFD
-- DateCreated: 11/6/2014 3:19:23 AM
--=======================================================================================================================
-- Prevent Duplicates
--=======================================================================================================================
if MapModData.JFD_TopPanelUpdated then return end
MapModData.JFD_TopPanelUpdated = true
Events.SequenceGameInitComplete.Add(function() MapModData.JFD_TopPanelUpdated = nil end)
--==========================================================================================================================
-- INCLUDES
--==========================================================================================================================
include("IconSupport")

for row in GameInfo.JFD_TopPanelIncludes() do
	include(row.FileName)
end
--==========================================================================================================================
-- UTILITIES
--==========================================================================================================================
-- Globals
---------------------------------------------------------------------------------------------------------------------------
local IconHookup = IconHookup
local L = Locale.ConvertTextKey
local tipControlTable = {};
TTManager:GetTypeControlTable("TooltipTypeTopPanel", tipControlTable);

-- JFD_IsUsingMercenaries
function JFD_IsUsingMercenaries()
	local mercenariesModID = "a19351c5-c0b3-4b07-8695-4affaa199949"
	local isUsingMercenaries = false
	for _, mod in pairs(Modding.GetActivatedMods()) do
		if (mod.ID == mercenariesModID) then
			isUsingMercenaries = true
			break
		end
	end
	return isUsingMercenaries
end

-- JFD_IsUsingPiety
function JFD_IsUsingPiety()
	local pietyModID = "eea66053-7579-481a-bb8d-2f3959b59974"
	local isUsingPiety = false
	for _, mod in pairs(Modding.GetActivatedMods()) do
		if (mod.ID == pietyModID) then
			isUsingPiety = true
			break
		end
	end
	return isUsingPiety
end

local isUsingMercenaries = JFD_IsUsingMercenaries()
local isUsingPiety = JFD_IsUsingPiety()
local isUsingEUITopPanel = false
---------------------------------------------------------------------------------------------------------------------------
-- JFD_GetYieldAddins
---------------------------------------------------------------------------------------------------------------------------
local JFD_YieldAddinMetatable = {}

function JFD_YieldAddinMetatable:YieldSum()
	local yieldSum = 0
	for _, entry in ipairs(self) do
		if entry.Yield then
			yieldSum = yieldSum + entry.Yield
		end
	end
	
	return yieldSum
end

function JFD_YieldAddinMetatable:YieldTooltips(tTooltips)
	local toolTipText = ""
	for _, entry in ipairs(self) do
		if entry.ToolTip and entry.Yield then
			local toolTip = "[NEWLINE][ICON_BULLET]" .. L(entry.ToolTip, entry.Yield)
			toolTipText = toolTipText .. toolTip
		end
	end
	
	return toolTipText
end

function JFD_YieldAddinMetatable:YieldTooltipsPositive(tTooltips)
	local toolTipText = ""
	for _, entry in ipairs(self) do
		if entry.Yield > 0 then
			local toolTip = "[NEWLINE][ICON_BULLET]" .. L(entry.ToolTip, entry.Yield)
			if entry.YieldType == "YIELD_GOLD" then
				toolTip = "[NEWLINE]  [ICON_BULLET]" .. L(entry.ToolTip, entry.Yield)
			end
			toolTipText = toolTipText .. toolTip
		end
	end
	
	return toolTipText
end

function JFD_YieldAddinMetatable:YieldTooltipsNegative(tTooltips)
	local toolTipText = ""
	for _, entry in ipairs(self) do
		if entry.Yield < 0 then
			local toolTip = "[NEWLINE][ICON_BULLET]" .. L(entry.ToolTip, entry.Yield)
			if entry.YieldType == "YIELD_GOLD" then
				toolTip = "[NEWLINE]  [ICON_BULLET]" .. L(entry.ToolTip, entry.Yield)
			end
			toolTipText = toolTipText .. toolTip
		end
	end
	
	return toolTipText
end

function JFD_GetYieldAddins(yieldType)

	local tableYieldAddins = {}
	setmetatable(tableYieldAddins, { __index = JFD_YieldAddinMetatable})
	
	for row in GameInfo.JFD_TopPanelAdditions("YieldType = '" .. yieldType .. "'") do
		local entry = {}
		local yieldSourceFunction = row.YieldSourceFunction
		if yieldSourceFunction ~= null then
			local yield = loadstring("return " .. yieldSourceFunction .. "(Game.GetActivePlayer())")()
			local civType = row.CivilizationType 
			if civType then
				if Players[Game.GetActivePlayer()]:GetCivilizationType() == GameInfoTypes[civType] then
					if yield ~= 0 then
						entry.YieldType = yieldType
						entry.Yield = yield
						entry.ToolTip = row.YieldSourceToolTip
					end
				end
			end
			
			if (not civType) then
				if yield ~= 0 then
					entry.YieldType = yieldType
					entry.Yield = yield
					entry.ToolTip = row.YieldSourceToolTip
				end
			end		
		end
		
		if entry.Yield then
			table.insert(tableYieldAddins, entry)
		end
	end
	
	return tableYieldAddins
end
---------------------------------------------------------------------------------------------------------------------------
-- JFD_GetYieldMiscToolTipAddins
---------------------------------------------------------------------------------------------------------------------------
function JFD_GetYieldMiscToolTipAddins(yieldType)
	local toolTipText
	for row in GameInfo.JFD_TopPanelAdditions("YieldType = '" .. yieldType .. "'") do
		local miscToolTipFunction = row.MiscToolTipFunction
		if miscToolTipFunction then
			toolTipText = ""
			local civType = row.CivilizationType 
			if civType then
				if Players[Game.GetActivePlayer()]:GetCivilizationType() == GameInfoTypes[civType] then
					local miscToolTip = loadstring("return " .. miscToolTipFunction .. "(Game.GetActivePlayer())")()
					if miscToolTip then
						toolTipText = toolTipText .. "[NEWLINE][NEWLINE]";
						toolTipText = toolTipText ..  miscToolTip
					end
				end
			end
			
			if (not civType) then
				local miscToolTip = loadstring("return " .. miscToolTipFunction .. "(Game.GetActivePlayer())")()
				if miscToolTip then
					toolTipText = toolTipText .. "[NEWLINE][NEWLINE]";
					toolTipText = toolTipText ..  miscToolTip
				end
			end
		end
	end
	
	return toolTipText
end
---------------------------------------------------------------------------------------------------------------------------
-- JFD_IsCommunityBalancePatchActive
---------------------------------------------------------------------------------------------------------------------------
function JFD_IsCommunityBalancePatchActive()
	local communityBalancePatchID = "8411a7a8-dad3-4622-a18e-fcc18324c799"
	local isUsingCBP = false
	
	for _, mod in pairs(Modding.GetActivatedMods()) do
	  if (mod.ID == communityBalancePatchID) then
	    isUsingCBP = true
	    break
	  end
	end

	return isUsingCBP
end

local isUsingCBP = JFD_IsCommunityBalancePatchActive()
--==========================================================================================================================
-- CORE FUNCTIONS
--========================================================================================================================
-- UpdateScienceTopPanelInfo
----------------------------------------------------------------------------------------------------------------------------
function UpdateScienceTopPanelInfo()
	local iPlayer = Game.GetActivePlayer()
	local pPlayer = Players[iPlayer]
	local strScienceText;
			
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)) then
		strScienceText = L("TXT_KEY_TOP_PANEL_SCIENCE_OFF");
	else
	
		local sciencePerTurn = pPlayer:GetScience();
	
		-- No Science
		if (sciencePerTurn <= 0) then
			strScienceText = string.format("[COLOR:255:60:60:255]" .. L("TXT_KEY_NO_SCIENCE") .. "[/COLOR]");
		-- We have science
		else
			--===============================
			--JFD's Top Panel Addins BEGIN
			--===============================
			--This is for adding extra Science Per Turn to the Top Panel
			local tJFDAddins = JFD_GetYieldAddins("YIELD_SCIENCE")
			sciencePerTurn = sciencePerTurn + (tJFDAddins:YieldSum())
			--===============================
			--JFD's Top Panel Addins END
			--===============================
			
			strScienceText = string.format("+%i", sciencePerTurn);

			local iGoldPerTurn = pPlayer:CalculateGoldRate();
		
			-- Gold being deducted from our Science
			if (pPlayer:GetGold() + iGoldPerTurn < 0) then
				strScienceText = "[COLOR:255:60:0:255]" .. strScienceText .. "[/COLOR]";
			-- Normal Science state
			else
				strScienceText = "[COLOR:33:190:247:255]" .. strScienceText .. "[/COLOR]";
			end
		end
	
		strScienceText = "[ICON_RESEARCH]" .. strScienceText;
	end
	
	ContextPtr:LookUpControl("/InGame/TopPanel/SciencePerTurn"):SetText(strScienceText);
end

-- Science Tooltip
function UpdatedScienceTipHandler( control )

	local strText = "";
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)) then
		strText = L("TXT_KEY_TOP_PANEL_SCIENCE_OFF_TOOLTIP");
	else
	
		local iPlayerID = Game.GetActivePlayer();
		local pPlayer = Players[iPlayerID];
		local pTeam = Teams[pPlayer:GetTeam()];
		local pCity = UI.GetHeadSelectedCity();
	
		local iSciencePerTurn = pPlayer:GetScience();
	
		if (pPlayer:IsAnarchy()) then
			strText = strText .. L("TXT_KEY_TP_ANARCHY", pPlayer:GetAnarchyNumTurns());
			strText = strText .. "[NEWLINE][NEWLINE]";
		end
	
		-- Science
		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for showing the total Science Per Turn in the tooltip
		local tJFDAddins = JFD_GetYieldAddins("YIELD_SCIENCE")
		iSciencePerTurn = iSciencePerTurn + (tJFDAddins:YieldSum())
		--===============================
		--JFD's Top Panel Addins END
		--===============================	
		
		if (not OptionsManager.IsNoBasicHelp()) then
			strText = strText .. L("TXT_KEY_TP_SCIENCE", iSciencePerTurn);
		
			if (pPlayer:GetNumCities() > 0) then
				strText = strText .. "[NEWLINE][NEWLINE]";
			end
		end
	
		local bFirstEntry = true;
	
		-- Science LOSS from Budget Deficits
		local iScienceFromBudgetDeficit = pPlayer:GetScienceFromBudgetDeficitTimes100();
		if (iScienceFromBudgetDeficit ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end

			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_BUDGET_DEFICIT", iScienceFromBudgetDeficit / 100);
			strText = strText .. "[NEWLINE]";
		end
	
		-- Science from Cities
		local iScienceFromCities = pPlayer:GetScienceFromCitiesTimes100(true);
		if (iScienceFromCities ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end

			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_CITIES", iScienceFromCities / 100);
		end
	
		-- Science from Trade Routes
		local iScienceFromTrade = pPlayer:GetScienceFromCitiesTimes100(false) - iScienceFromCities;
		if (iScienceFromTrade ~= 0) then
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end
			
			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_ITR", iScienceFromTrade / 100);
		end
	
		-- Science from Other Players
		local iScienceFromOtherPlayers = pPlayer:GetScienceFromOtherPlayersTimes100();
		if (iScienceFromOtherPlayers ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end

			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_MINORS", iScienceFromOtherPlayers / 100);
		end
	
		-- Science from Happiness
		local iScienceFromHappiness = pPlayer:GetScienceFromHappinessTimes100();
		if (iScienceFromHappiness ~= 0) then
			
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end
	
			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_HAPPINESS", iScienceFromHappiness / 100);
		end
	
		-- Science from Research Agreements
		local iScienceFromRAs = pPlayer:GetScienceFromResearchAgreementsTimes100();
		if (iScienceFromRAs ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				bFirstEntry = false;
			else
				strText = strText .. "[NEWLINE]";
			end
	
			strText = strText .. L("TXT_KEY_TP_SCIENCE_FROM_RESEARCH_AGREEMENTS", iScienceFromRAs / 100);
		end
		
		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any extra Science Per Turn addins
		local toolTipAddinsScience = JFD_GetYieldAddins("YIELD_SCIENCE")
		local toolTipAddinsPositive = toolTipAddinsScience:YieldTooltipsPositive(toolTipAddinsScience)
		local toolTipAddinsNegative = toolTipAddinsScience:YieldTooltipsNegative(toolTipAddinsScience)
		strText = strText .. toolTipAddinsPositive
		strText = strText .. toolTipAddinsNegative
		--===============================
		--JFD's Top Panel Addins END
		--===============================
			
		-- Let people know that building more cities makes techs harder to get
		if (not OptionsManager.IsNoBasicHelp()) then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_TECH_CITY_COST", Game.GetNumCitiesTechCostMod());
		end

		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any miscellaneous tooltip info you want to display
		local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_SCIENCE")
		if (miscToolTip and miscToolTip ~= "") then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  miscToolTip
		end
		--===============================
		--JFD's Top Panel Addins END
		--===============================
	end
	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdateGoldTopPanelInfo
----------------------------------------------------------------------------------------------------------------------------
function UpdateGoldTopPanelInfo()
	local iPlayer = Game.GetActivePlayer()
	local pPlayer = Players[iPlayer]
	local iTotalGold = pPlayer:GetGold();

	local iContractMaintenance = 0 
	if isUsingMercenaries then iContractMaintenance = JFD_GetTotalContractMaintenance(iPlayer) end
	local iGoldPerTurn = pPlayer:CalculateGoldRate() - iContractMaintenance
	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	local tJFDAddins = JFD_GetYieldAddins("YIELD_GOLD")
	iGoldPerTurn = iGoldPerTurn + tJFDAddins:YieldSum()
	--===============================
	--JFD's Top Panel Addins END
	--===============================	

	local strGoldStr = L("TXT_KEY_TOP_PANEL_GOLD", iTotalGold, iGoldPerTurn);

	ContextPtr:LookUpControl("/InGame/TopPanel/GoldPerTurn"):SetText(strGoldStr);
end

-- Gold Tooltip
function UpdatedGoldTipHandler( control )
	local strText = "";
	local iPlayerID = Game.GetActivePlayer();
	local pPlayer = Players[iPlayerID];
	local pTeam = Teams[pPlayer:GetTeam()];
	local pCity = UI.GetHeadSelectedCity();
	
	local iTotalGold = pPlayer:GetGold();

	local iGoldPerTurnFromOtherPlayers = pPlayer:GetGoldPerTurnFromDiplomacy();
	local iGoldPerTurnToOtherPlayers = 0;
	if (iGoldPerTurnFromOtherPlayers < 0) then
		iGoldPerTurnToOtherPlayers = -iGoldPerTurnFromOtherPlayers;
		iGoldPerTurnFromOtherPlayers = 0;
	end
	
	local iGoldPerTurnFromReligion = pPlayer:GetGoldPerTurnFromReligion();

	local fTradeRouteGold = (pPlayer:GetGoldFromCitiesTimes100() - pPlayer:GetGoldFromCitiesMinusTradeRoutesTimes100()) / 100;
	local fGoldPerTurnFromCities = pPlayer:GetGoldFromCitiesMinusTradeRoutesTimes100() / 100;
	local fCityConnectionGold = pPlayer:GetCityConnectionGoldTimes100() / 100;
	--local fInternationalTradeRouteGold = pPlayer:GetGoldPerTurnFromTradeRoutesTimes100() / 100;
	local fTraitGold = pPlayer:GetGoldPerTurnFromTraits();
	local fTotalIncome = fGoldPerTurnFromCities + iGoldPerTurnFromOtherPlayers + fCityConnectionGold + iGoldPerTurnFromReligion + fTradeRouteGold + fTraitGold;
	
	if (pPlayer:IsAnarchy()) then
		strText = strText .. L("TXT_KEY_TP_ANARCHY", pPlayer:GetAnarchyNumTurns());
		strText = strText .. "[NEWLINE][NEWLINE]";
	end
	
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. L("TXT_KEY_TP_AVAILABLE_GOLD", iTotalGold);
		strText = strText .. "[NEWLINE][NEWLINE]";
	end
	
	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	local tJFDAddins = JFD_GetYieldAddins("YIELD_GOLD")
	fTotalIncome = fTotalIncome + (tJFDAddins:YieldSum())
	--===============================
	--JFD's Top Panel Addins END
	--===============================	
	
	strText = strText .. "[COLOR:150:255:150:255]";
	strText = strText .. "+" .. L("TXT_KEY_TP_TOTAL_INCOME", math.floor(fTotalIncome));
	strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_CITY_OUTPUT", fGoldPerTurnFromCities);
	strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_FROM_CITY_CONNECTIONS", math.floor(fCityConnectionGold));
	strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_FROM_ITR", math.floor(fTradeRouteGold));
	if (math.floor(fTraitGold) > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_FROM_TRAITS", math.floor(fTraitGold));
	end
	if (iGoldPerTurnFromOtherPlayers > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_FROM_OTHERS", iGoldPerTurnFromOtherPlayers);
	end

	if (iGoldPerTurnFromReligion > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_FROM_RELIGION", iGoldPerTurnFromReligion);
	end
	
	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	--This is for any extra positive Gold Per Turn addins
	local toolTipAddinsGold = JFD_GetYieldAddins("YIELD_GOLD")
	local toolTipAddinsPositive = toolTipAddinsGold:YieldTooltipsPositive(toolTipAddinsGold)
	strText = strText .. toolTipAddinsPositive
	--===============================
	--JFD's Top Panel Addins END
	--===============================
	
	strText = strText .. "[/COLOR]";
	
	local iUnitCost = pPlayer:CalculateUnitCost();
	local iUnitSupply = pPlayer:CalculateUnitSupply();
	local iBuildingMaintenance = pPlayer:GetBuildingGoldMaintenance();
	local iImprovementMaintenance = pPlayer:GetImprovementGoldMaintenance();
	local iContractMaintenance = 0
	if isUsingMercenaries then
		iContractMaintenance = JFD_GetTotalMercenaryContractMaintenance(iPlayerID)
	end
	local iReformMaintenance = 0
	local iTotalExpenses = iUnitCost + iUnitSupply + iBuildingMaintenance + iImprovementMaintenance + iGoldPerTurnToOtherPlayers + iContractMaintenance + iReformMaintenance; 
	
	strText = strText .. "[NEWLINE]";
	strText = strText .. "[COLOR:255:150:150:255]";
	strText = strText .. "[NEWLINE]-" .. L("TXT_KEY_TP_TOTAL_EXPENSES", iTotalExpenses);
	if (iUnitCost ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_UNIT_MAINT", iUnitCost);
	end
	if (iUnitSupply ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_UNIT_SUPPLY", iUnitSupply);
	end
	if (iBuildingMaintenance ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_BUILDING_MAINT", iBuildingMaintenance);
	end
	if (iContractMaintenance > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_CONTRACT_MAINT", iContractMaintenance);
	end
	if (iReformMaintenance > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_REFORM_MAINT", iReformMaintenance);
	end
	if (iImprovementMaintenance ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_TILE_MAINT", iImprovementMaintenance);
	end
	if (iGoldPerTurnToOtherPlayers > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_GOLD_TO_OTHERS", iGoldPerTurnToOtherPlayers);
	end
	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	--This is for any extra negative Gold Per Turn addins
	local toolTipAddinsNegative = toolTipAddinsGold:YieldTooltipsNegative(toolTipAddinsGold)
	strText = strText .. toolTipAddinsNegative
	--===============================
	--JFD's Top Panel Addins END
	--===============================
	strText = strText .. "[/COLOR]";
	
	if (fTotalIncome + iTotalGold < 0) then
		strText = strText .. "[NEWLINE][COLOR:255:60:60:255]" .. L("TXT_KEY_TP_LOSING_SCIENCE_FROM_DEFICIT") .. "[/COLOR]";
	end
	
	-- Basic explanation of Happiness
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  L("TXT_KEY_TP_GOLD_EXPLANATION");
	end

	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	--This is for any miscellaneous tooltip info you want to display
	local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_GOLD")
	if (miscToolTip and miscToolTip ~= "") then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  miscToolTip
	end
	--===============================
	--JFD's Top Panel Addins END
	--===============================
	
	--Controls.GoldPerTurn:SetToolTipString(strText);
	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdatedHappinessTipHandler
----------------------------------------------------------------------------------------------------------------------------
-- Happiness Tooltip
function UpdatedHappinessTipHandler( control )

	local strText;
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)) then
		strText = L("TXT_KEY_TOP_PANEL_HAPPINESS_OFF_TOOLTIP");
	else
		local iPlayerID = Game.GetActivePlayer();
		local pPlayer = Players[iPlayerID];
		local pTeam = Teams[pPlayer:GetTeam()];
		local pCity = UI.GetHeadSelectedCity();
	
		local iHappiness = pPlayer:GetExcessHappiness();

		if (not pPlayer:IsEmpireUnhappy()) then
			strText = L("TXT_KEY_TP_TOTAL_HAPPINESS", iHappiness);
		elseif (pPlayer:IsEmpireVeryUnhappy()) then
			strText = L("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_4]", -iHappiness);
		else
			strText = L("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_3]", -iHappiness);
		end
	
		local iPoliciesHappiness = pPlayer:GetHappinessFromPolicies();
		local iResourcesHappiness = pPlayer:GetHappinessFromResources();
		local iExtraLuxuryHappiness = pPlayer:GetExtraHappinessPerLuxury();
		local iCityHappiness = pPlayer:GetHappinessFromCities();
		local iBuildingHappiness = pPlayer:GetHappinessFromBuildings();
		local iTradeRouteHappiness = pPlayer:GetHappinessFromTradeRoutes();
		local iReligionHappiness = pPlayer:GetHappinessFromReligion();
		local iNaturalWonderHappiness = pPlayer:GetHappinessFromNaturalWonders();
		local iExtraHappinessPerCity = pPlayer:GetExtraHappinessPerCity() * pPlayer:GetNumCities();
		local iMinorCivHappiness = pPlayer:GetHappinessFromMinorCivs();
		local iLeagueHappiness = pPlayer:GetHappinessFromLeagues();
	
		local iHandicapHappiness = pPlayer:GetHappiness() - iPoliciesHappiness - iResourcesHappiness - iCityHappiness - iBuildingHappiness - iTradeRouteHappiness - iReligionHappiness - iNaturalWonderHappiness - iMinorCivHappiness - iExtraHappinessPerCity - iLeagueHappiness;
	
		if (pPlayer:IsEmpireVeryUnhappy()) then
		
			if (pPlayer:IsEmpireSuperUnhappy()) then
				strText = strText .. "[NEWLINE][NEWLINE]";
				strText = strText .. "[COLOR:255:60:60:255]" .. L("TXT_KEY_TP_EMPIRE_SUPER_UNHAPPY") .. "[/COLOR]";
			end
		
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. "[COLOR:255:60:60:255]" .. L("TXT_KEY_TP_EMPIRE_VERY_UNHAPPY") .. "[/COLOR]";
		elseif (pPlayer:IsEmpireUnhappy()) then
		
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. "[COLOR:255:60:60:255]" .. L("TXT_KEY_TP_EMPIRE_UNHAPPY") .. "[/COLOR]";
		end
	
		local iTotalHappiness = iPoliciesHappiness + iResourcesHappiness + iCityHappiness + iBuildingHappiness + iMinorCivHappiness + iHandicapHappiness + iTradeRouteHappiness + iReligionHappiness + iNaturalWonderHappiness + iExtraHappinessPerCity + iLeagueHappiness;
	
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText .. "[COLOR:150:255:150:255]";
		strText = strText .. L("TXT_KEY_TP_HAPPINESS_SOURCES", iTotalHappiness);
	
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_FROM_RESOURCES", iResourcesHappiness);
	
		-- Individual Resource Info
	
		local iBaseHappinessFromResources = 0;
		local iNumHappinessResources = 0;

		for resource in GameInfo.Resources() do
			local resourceID = resource.ID;
			local iHappiness = pPlayer:GetHappinessFromLuxury(resourceID);
			if (iHappiness > 0) then
				strText = strText .. "[NEWLINE]";
				strText = strText .. "          +" .. L("TXT_KEY_TP_HAPPINESS_EACH_RESOURCE", iHappiness, resource.IconString, resource.Description);
				iNumHappinessResources = iNumHappinessResources + 1;
				iBaseHappinessFromResources = iBaseHappinessFromResources + iHappiness;
			end
		end
	
		-- Happiness from Luxury Variety
		local iHappinessFromExtraResources = pPlayer:GetHappinessFromResourceVariety();
		if (iHappinessFromExtraResources > 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "          +" .. L("TXT_KEY_TP_HAPPINESS_RESOURCE_VARIETY", iHappinessFromExtraResources);
		end
	
		-- Extra Happiness from each Luxury
		if (iExtraLuxuryHappiness >= 1) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "          +" .. L("TXT_KEY_TP_HAPPINESS_EXTRA_PER_RESOURCE", iExtraLuxuryHappiness, iNumHappinessResources);
		end
	
		-- Misc Happiness from Resources
		local iMiscHappiness = iResourcesHappiness - iBaseHappinessFromResources - iHappinessFromExtraResources - (iExtraLuxuryHappiness * iNumHappinessResources);
		if (iMiscHappiness > 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "          +" .. L("TXT_KEY_TP_HAPPINESS_OTHER_SOURCES", iMiscHappiness);
		end
	
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_CITIES", iCityHappiness);
		if (iPoliciesHappiness >= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_POLICIES", iPoliciesHappiness);
		end
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_BUILDINGS", iBuildingHappiness);
		if (iTradeRouteHappiness ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_CONNECTED_CITIES", iTradeRouteHappiness);
		end
		if (iReligionHappiness ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_STATE_RELIGION", iReligionHappiness);
		end
		if (iNaturalWonderHappiness ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_NATURAL_WONDERS", iNaturalWonderHappiness);
		end
		if (iExtraHappinessPerCity ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_CITY_COUNT", iExtraHappinessPerCity);
		end
		if (iMinorCivHappiness ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_CITY_STATE_FRIENDSHIP", iMinorCivHappiness);
		end
		if (iLeagueHappiness ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_LEAGUES", iLeagueHappiness);
		end

		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL", iHandicapHappiness);
		strText = strText .. "[/COLOR]";
	
		-- Unhappiness
		local iTotalUnhappiness = pPlayer:GetUnhappiness();
		local iUnhappinessFromUnits = Locale.ToNumber( pPlayer:GetUnhappinessFromUnits() / 100, "#.##" );
		local iUnhappinessFromCityCount = Locale.ToNumber( pPlayer:GetUnhappinessFromCityCount() / 100, "#.##" );
		local iUnhappinessFromCapturedCityCount = Locale.ToNumber( pPlayer:GetUnhappinessFromCapturedCityCount() / 100, "#.##" );
		
		local iUnhappinessFromPupetCities = pPlayer:GetUnhappinessFromPuppetCityPopulation();
		local unhappinessFromSpecialists = pPlayer:GetUnhappinessFromCitySpecialists();
		local unhappinessFromPop = pPlayer:GetUnhappinessFromCityPopulation() - unhappinessFromSpecialists - iUnhappinessFromPupetCities;
			
		local iUnhappinessFromPop = Locale.ToNumber( unhappinessFromPop / 100, "#.##" );
		local iUnhappinessFromOccupiedCities = Locale.ToNumber( pPlayer:GetUnhappinessFromOccupiedCities() / 100, "#.##" );
		local iUnhappinessPublicOpinion = pPlayer:GetUnhappinessFromPublicOpinion();
		
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText .. "[COLOR:255:150:150:255]";
		strText = strText .. L("TXT_KEY_TP_UNHAPPINESS_TOTAL", iTotalUnhappiness);
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_CITY_COUNT", iUnhappinessFromCityCount);
		if (iUnhappinessFromCapturedCityCount ~= "0") then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_CAPTURED_CITY_COUNT", iUnhappinessFromCapturedCityCount);
		end
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_POPULATION", iUnhappinessFromPop);
		
		if(iUnhappinessFromPupetCities > 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_PUPPET_CITIES", iUnhappinessFromPupetCities / 100);
		end
		
		if(unhappinessFromSpecialists > 0) then
			strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_SPECIALISTS", unhappinessFromSpecialists / 100);
		end
		
		if (iUnhappinessFromOccupiedCities ~= "0") then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_OCCUPIED_POPULATION", iUnhappinessFromOccupiedCities);
		end
		if (iUnhappinessFromUnits ~= "0") then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_UNITS", iUnhappinessFromUnits);
		end
		if (iPoliciesHappiness < 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_HAPPINESS_POLICIES", iPoliciesHappiness);
		end		
		if (iUnhappinessPublicOpinion > 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "  [ICON_BULLET]" .. L("TXT_KEY_TP_UNHAPPINESS_PUBLIC_OPINION", iUnhappinessPublicOpinion);
		end		
		strText = strText .. "[/COLOR]";
	
		-- Basic explanation of Happiness
		if (not OptionsManager.IsNoBasicHelp()) then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  L("TXT_KEY_TP_HAPPINESS_EXPLANATION");
		end

		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any miscellaneous tooltip info you want to display
		local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_HAPPINESS")
		if (miscToolTip and miscToolTip ~= "") then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  miscToolTip
		end
		--===============================
		--JFD's Top Panel Addins END
		--===============================
	end
	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdatedGoldenAgeTipHandler
----------------------------------------------------------------------------------------------------------------------------
-- Golden Age Tooltip
function UpdatedGoldenAgeTipHandler( control )

	local strText;
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)) then
		strText = L("TXT_KEY_TOP_PANEL_HAPPINESS_OFF_TOOLTIP");
	else
		local iPlayerID = Game.GetActivePlayer();
		local pPlayer = Players[iPlayerID];
		local pTeam = Teams[pPlayer:GetTeam()];
		local pCity = UI.GetHeadSelectedCity();
	
		if (pPlayer:GetGoldenAgeTurns() > 0) then
			strText = L("TXT_KEY_TP_GOLDEN_AGE_NOW", pPlayer:GetGoldenAgeTurns());
		else
			local iHappiness = pPlayer:GetExcessHappiness();

			strText = L("TXT_KEY_TP_GOLDEN_AGE_PROGRESS", pPlayer:GetGoldenAgeProgressMeter(), pPlayer:GetGoldenAgeProgressThreshold());
			strText = strText .. "[NEWLINE]";
		
			if (iHappiness >= 0) then
				strText = strText .. L("TXT_KEY_TP_GOLDEN_AGE_ADDITION", iHappiness);
			else
				strText = strText .. "[COLOR_WARNING_TEXT]" .. L("TXT_KEY_TP_GOLDEN_AGE_LOSS", -iHappiness) .. "[ENDCOLOR]";
			end

			--===============================
			--JFD's Top Panel Addins BEGIN
			--===============================
			local toolTipAddinsGoldenAge = JFD_GetYieldAddins("YIELD_GOLDEN_AGE")
			local toolTipAddinsPositive = toolTipAddinsGoldenAge:YieldTooltipsPositive(toolTipAddinsGoldenAge)
			local toolTipAddinsNegative = toolTipAddinsGoldenAge:YieldTooltipsNegative(toolTipAddinsGoldenAge)
			strText = strText .. toolTipAddinsPositive
			strText = strText .. toolTipAddinsNegative
			--===============================
			--JFD's Top Panel Addins END
			--===============================
		end
	
		strText = strText .. "[NEWLINE][NEWLINE]";
		if (pPlayer:IsGoldenAgeCultureBonusDisabled()) then
			strText = strText ..  L("TXT_KEY_TP_GOLDEN_AGE_EFFECT_NO_CULTURE");		
		else
			strText = strText ..  L("TXT_KEY_TP_GOLDEN_AGE_EFFECT");		
		end
		
		if (pPlayer:GetGoldenAgeTurns() > 0 and pPlayer:GetGoldenAgeTourismModifier() > 0) then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  L("TXT_KEY_TP_CARNIVAL_EFFECT");			
		end

	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	--This is for any miscellaneous tooltip info you want to display
	local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_GOLDEN_AGE")
	if (miscToolTip and miscToolTip ~= "") then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  miscToolTip
	end
	--===============================
	--JFD's Top Panel Addins END
	--===============================
	end
	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdateCultureTopPanelInfo
----------------------------------------------------------------------------------------------------------------------------
function UpdateCultureTopPanelInfo()
	local iPlayer = Game.GetActivePlayer()
	local pPlayer = Players[iPlayer]
	local strCultureStr;
			
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES)) then
		strCultureStr = L("TXT_KEY_TOP_PANEL_POLICIES_OFF");
	else
	
		local iCulturePerTurn = pPlayer:GetTotalJONSCulturePerTurn()
		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		local tJFDAddins = JFD_GetYieldAddins("YIELD_CULTURE")
		iCulturePerTurn = iCulturePerTurn + tJFDAddins:YieldSum()
		--===============================
		--JFD's Top Panel Addins END
		--===============================

		if (pPlayer:GetNextPolicyCost() > 0) then
			strCultureStr = string.format("%i/%i (+%i)", pPlayer:GetJONSCulture(), pPlayer:GetNextPolicyCost(), iCulturePerTurn);
		else
			strCultureStr = string.format("%i (+%i)", pPlayer:GetJONSCulture(), iCulturePerTurn);
		end
	
		strCultureStr = "[ICON_CULTURE][COLOR:255:0:255:255]" .. strCultureStr .. "[/COLOR]";
	end
	
	ContextPtr:LookUpControl("/InGame/TopPanel/CultureString"):SetText(strCultureStr);
end

-- Culture Tooltip
function UpdatedCultureTipHandler( control )

	local strText = "";
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES)) then
		strText = L("TXT_KEY_TOP_PANEL_POLICIES_OFF_TOOLTIP");
	else
	
		local iPlayerID = Game.GetActivePlayer();
		local pPlayer = Players[iPlayerID];
    
		local iTurns;
		local iCultureNeeded = pPlayer:GetNextPolicyCost() - pPlayer:GetJONSCulture();
	    if (iCultureNeeded <= 0) then
			iTurns = 0;
		else
			if (pPlayer:GetTotalJONSCulturePerTurn() == 0) then
				iTurns = "?";
			else
				iTurns = iCultureNeeded / pPlayer:GetTotalJONSCulturePerTurn();
				iTurns = math.ceil(iTurns);
			end
	    end
	    
	    if (pPlayer:IsAnarchy()) then
			strText = strText .. L("TXT_KEY_TP_ANARCHY", pPlayer:GetAnarchyNumTurns());
		end
	    
		strText = strText .. L("TXT_KEY_NEXT_POLICY_TURN_LABEL", iTurns);
	
		if (not OptionsManager.IsNoBasicHelp()) then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_ACCUMULATED", pPlayer:GetJONSCulture());
			strText = strText .. "[NEWLINE]";
		
			if (pPlayer:GetNextPolicyCost() > 0) then
				strText = strText .. L("TXT_KEY_TP_CULTURE_NEXT_POLICY", pPlayer:GetNextPolicyCost());
			end
		end

		if (pPlayer:IsAnarchy()) then
			tipControlTable.TooltipLabel:SetText( strText );
			tipControlTable.TopPanelMouseover:SetHide(false);
			tipControlTable.TopPanelMouseover:DoAutoSize();
			return;
		end

		local bFirstEntry = true;
		
		-- Culture for Free
		local iCultureForFree = pPlayer:GetJONSCulturePerTurnForFree();
		if (iCultureForFree ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FOR_FREE", iCultureForFree);
		end
	
		-- Culture from Cities
		local iCultureFromCities = pPlayer:GetJONSCulturePerTurnFromCities();
		if (iCultureFromCities ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_CITIES", iCultureFromCities);
		end
	
		-- Culture from Excess Happiness
		local iCultureFromHappiness = pPlayer:GetJONSCulturePerTurnFromExcessHappiness();
		if (iCultureFromHappiness ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_HAPPINESS", iCultureFromHappiness);
		end
	
		-- Culture from Traits
		local iCultureFromTraits = pPlayer:GetJONSCulturePerTurnFromTraits();
		if (iCultureFromTraits ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_TRAITS", iCultureFromTraits);
		end
	
		-- Culture from Minor Civs
		local iCultureFromMinors = pPlayer:GetCulturePerTurnFromMinorCivs();
		if (iCultureFromMinors ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_MINORS", iCultureFromMinors);
		end

		-- Culture from Religion
		local iCultureFromReligion = pPlayer:GetCulturePerTurnFromReligion();
		if (iCultureFromReligion ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_RELIGION", iCultureFromReligion);
		end
		
		-- Culture from a bonus turns (League Project)
		local iCultureFromBonusTurns = pPlayer:GetCulturePerTurnFromBonusTurns();
		if (iCultureFromBonusTurns ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			local iBonusTurns = pPlayer:GetCultureBonusTurns();
			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_BONUS_TURNS", iCultureFromBonusTurns, iBonusTurns);
		end
		
		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		local tJFDAddins = JFD_GetYieldAddins("YIELD_CULTURE"):YieldSum()
		--===============================
		--JFD's Top Panel Addins END
		--===============================

		-- Culture from Golden Age
		local iCultureFromGoldenAge = pPlayer:GetTotalJONSCulturePerTurn() - iCultureForFree - iCultureFromCities - iCultureFromHappiness - iCultureFromMinors - iCultureFromReligion - iCultureFromTraits - iCultureFromBonusTurns;
		if (iCultureFromGoldenAge ~= 0) then
		
			-- Add separator for non-initial entries
			if (bFirstEntry) then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end

			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_FROM_GOLDEN_AGE", iCultureFromGoldenAge);
		end

		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any extra positive Culture Per Turn addins
		local toolTipAddinsCulture = JFD_GetYieldAddins("YIELD_CULTURE")
		local toolTipAddinsPositive = toolTipAddinsCulture:YieldTooltipsPositive(toolTipAddinsCulture)
		local toolTipAddinsNegative = toolTipAddinsCulture:YieldTooltipsNegative(toolTipAddinsCulture)
		strText = strText .. toolTipAddinsPositive
		strText = strText .. toolTipAddinsNegative
		--===============================
		--JFD's Top Panel Addins END
		--===============================

		-- Let people know that building more cities makes policies harder to get
		if (not OptionsManager.IsNoBasicHelp()) then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_CULTURE_CITY_COST", Game.GetNumCitiesPolicyCostMod());
		end

		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any miscellaneous tooltip info you want to display
		local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_CULTURE")
		if (miscToolTip and miscToolTip ~= "") then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  miscToolTip
		end
		--===============================
		--JFD's Top Panel Addins END
		--===============================
	end
	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdatedTourismTipHandler
----------------------------------------------------------------------------------------------------------------------------
-- Tourism Tooltip
function UpdatedTourismTipHandler( control )

	local iPlayerID = Game.GetActivePlayer();
	local pPlayer = Players[iPlayerID];
	
	local iTotalGreatWorks = pPlayer:GetNumGreatWorks();
	local iTotalSlots = pPlayer:GetNumGreatWorkSlots();
	
	local strText1 = L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_1", iTotalGreatWorks);
	local strText2 = L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_2", (iTotalSlots - iTotalGreatWorks));
		
	local strText = strText1 .. "[NEWLINE]" .. strText2;
		
	local cultureVictory = GameInfo.Victories["VICTORY_CULTURAL"];
	if(cultureVictory ~= nil and PreGame.IsVictory(cultureVictory.ID)) then
	    local iNumInfluential = pPlayer:GetNumCivsInfluentialOn();
		local iNumToBeInfluential = pPlayer:GetNumCivsToBeInfluentialOn();
		local szText = L("TXT_KEY_CO_VICTORY_INFLUENTIAL_OF", iNumInfluential, iNumToBeInfluential);

		local strText3 = L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_3", szText);
		
		strText = strText .. "[NEWLINE][NEWLINE]" .. strText3;
	end	

	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	--This is for any miscellaneous tooltip info you want to display
	local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_TOURISM")
	if (miscToolTip and miscToolTip ~= "") then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  miscToolTip
	end
	--===============================
	--JFD's Top Panel Addins END
	--===============================

	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- UpdateFaithTopPanelInfo
----------------------------------------------------------------------------------------------------------------------------
function UpdateFaithTopPanelInfo()
	local iPlayer = Game.GetActivePlayer()
	local pPlayer = Players[iPlayer]
	local strFaithStr;
	
	local iFaithPerTurn = pPlayer:GetTotalFaithPerTurn()
	--===============================
	--JFD's Top Panel Addins BEGIN
	--===============================
	local tJFDAddins = JFD_GetYieldAddins("YIELD_FAITH")
	iFaithPerTurn = iFaithPerTurn + tJFDAddins:YieldSum()
	--===============================
	--JFD's Top Panel Addins END
	--===============================	
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		strFaithStr = L("TXT_KEY_TOP_PANEL_RELIGION_OFF");
	else
		strFaithStr = string.format("%i (+%i)", pPlayer:GetFaith(), iFaithPerTurn);
		strFaithStr = "[ICON_PEACE]" .. strFaithStr;
	end

	ContextPtr:LookUpControl("/InGame/TopPanel/FaithString"):SetText(strFaithStr);
end

-- FaithTooltip
function UpdatedFaithTipHandler( control )

	local strText = "";

	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		strText = L("TXT_KEY_TOP_PANEL_RELIGION_OFF_TOOLTIP");
	else
	
		local iPlayerID = Game.GetActivePlayer();
		local pPlayer = Players[iPlayerID];

	    if (pPlayer:IsAnarchy()) then
			strText = strText .. L("TXT_KEY_TP_ANARCHY", pPlayer:GetAnarchyNumTurns());
			strText = strText .. "[NEWLINE]";
			strText = strText .. "[NEWLINE]";
		end
	    
		strText = strText .. L("TXT_KEY_TP_FAITH_ACCUMULATED", pPlayer:GetFaith());
		strText = strText .. "[NEWLINE]";
	
		-- Faith from Cities
		local iFaithFromCities = pPlayer:GetFaithPerTurnFromCities();
		if (iFaithFromCities ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_FAITH_FROM_CITIES", iFaithFromCities);
		end
	
		-- Faith from Minor Civs
		local iFaithFromMinorCivs = pPlayer:GetFaithPerTurnFromMinorCivs();
		if (iFaithFromMinorCivs ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_FAITH_FROM_MINORS", iFaithFromMinorCivs);
		end

		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any extra Faith Per Turn addins
		local toolTipAddinsFaith = JFD_GetYieldAddins("YIELD_FAITH")
		local toolTipAddinsPositive = toolTipAddinsFaith:YieldTooltipsPositive(toolTipAddinsFaith)
		local toolTipAddinsNegative = toolTipAddinsFaith:YieldTooltipsNegative(toolTipAddinsFaith)
		strText = strText .. toolTipAddinsPositive
		strText = strText .. toolTipAddinsNegative
		--===============================
		--JFD's Top Panel Addins END
		--===============================
		
		-- Faith from Religion
		local iFaithFromReligion = pPlayer:GetFaithPerTurnFromReligion();
		if (iFaithFromReligion ~= 0) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. L("TXT_KEY_TP_FAITH_FROM_RELIGION", iFaithFromReligion);
		end
		
		--if (iFaithFromCities ~= 0 or iFaithFromMinorCivs ~= 0 or iFaithFromReligion ~= 0) then
			strText = strText .. "[NEWLINE]";
		--end
		
		strText = strText .. "[NEWLINE]";

		if (pPlayer:HasCreatedPantheon()) then
			if (Game.GetNumReligionsStillToFound() > 0 or pPlayer:HasCreatedReligion()) then
				if (pPlayer:GetCurrentEra() < GameInfo.Eras["ERA_INDUSTRIAL"].ID) then
					strText = strText .. L("TXT_KEY_TP_FAITH_NEXT_PROPHET", pPlayer:GetMinimumFaithNextGreatProphet());
					strText = strText .. "[NEWLINE]";
					strText = strText .. "[NEWLINE]";
				end
			end
		else
			if (pPlayer:CanCreatePantheon(false)) then
				strText = strText .. L("TXT_KEY_TP_FAITH_NEXT_PANTHEON", Game.GetMinimumFaithNextPantheon());
				strText = strText .. "[NEWLINE]";
			else
				strText = strText .. L("TXT_KEY_TP_FAITH_PANTHEONS_LOCKED");
				strText = strText .. "[NEWLINE]";
			end
			strText = strText .. "[NEWLINE]";
		end
		
		if (Game.GetNumReligionsStillToFound() < 0) then
			strText = strText .. L("TXT_KEY_TP_FAITH_RELIGIONS_LEFT", 0);
		else
			strText = strText .. L("TXT_KEY_TP_FAITH_RELIGIONS_LEFT", Game.GetNumReligionsStillToFound());
		end
		
		if (pPlayer:GetCurrentEra() >= GameInfo.Eras["ERA_INDUSTRIAL"].ID) then
		    local bAnyFound = false;
			strText = strText .. "[NEWLINE]";		
			strText = strText .. "[NEWLINE]";		
			strText = strText .. L("TXT_KEY_TP_FAITH_NEXT_GREAT_PERSON", pPlayer:GetMinimumFaithNextGreatProphet());	
			
			local capital = pPlayer:GetCapitalCity();
			if(capital ~= nil) then	
				for info in GameInfo.Units{Special = "SPECIALUNIT_PEOPLE"} do
					local infoID = info.ID;
					local faithCost = capital:GetUnitFaithPurchaseCost(infoID, true);
					if(faithCost > 0 and pPlayer:IsCanPurchaseAnyCity(false, true, infoID, -1, YieldTypes.YIELD_FAITH)) then
						if (pPlayer:DoesUnitPassFaithPurchaseCheck(infoID)) then
							strText = strText .. "[NEWLINE]";
							strText = strText .. "[ICON_BULLET]" .. L(info.Description);
							bAnyFound = true;
						end
					end
				end
			end
						
			if (not bAnyFound) then
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. L("TXT_KEY_RO_YR_NO_GREAT_PEOPLE");
			end
		end
		--===============================
		--JFD's Top Panel Addins BEGIN
		--===============================
		--This is for any miscellaneous tooltip info you want to display
		local miscToolTip = JFD_GetYieldMiscToolTipAddins("YIELD_FAITH") or JFD_GetYieldMiscToolTipAddins("YIELD_JFD_PIETY")
		if (miscToolTip and miscToolTip ~= "") then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText ..  miscToolTip
		end
		--===============================
		--JFD's Top Panel Addins END
		--===============================
	end

	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end
---------------------------------------------------------------------------------------------------------------------------
-- InitUpdatedTooltips
----------------------------------------------------------------------------------------------------------------------------
-- Initialise the updated Tool-tips
function InitUpdatedTooltips()
	local player = Players[Game.GetActivePlayer()]
	if player:GetNumCities() == 0 then return end
	if (not isUsingEUITopPanel) then
		ContextPtr:LookUpControl("/InGame/TopPanel/FaithString"):SetToolTipCallback(UpdatedFaithTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/CultureString"):SetToolTipCallback(UpdatedCultureTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/SciencePerTurn"):SetToolTipCallback(UpdatedScienceTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/GoldPerTurn"):SetToolTipCallback(UpdatedGoldTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/HappinessString"):SetToolTipCallback(UpdatedHappinessTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/GoldenAgeString"):SetToolTipCallback(UpdatedGoldenAgeTipHandler)
		ContextPtr:LookUpControl("/InGame/TopPanel/TourismString"):SetToolTipCallback(UpdatedTourismTipHandler)
	end
end
if ((not isUsingPiety) and (not isUsingCBP)) then
	Events.SerialEventGameDataDirty.Add(InitUpdatedTooltips)
	Events.ActivePlayerTurnStart.Add(InitUpdatedTooltips)
end
-------------------------------------------------
-- On Init
-------------------------------------------------
if (not isPietyActive) then
	Events.SequenceGameInitComplete.Add(
	function()
		if ContextPtr:LookUpControl("/InGame/TopPanel/ClockOptionsPanel") then
			-- EUI Active
			isUsingEUITopPanel = true
		end
	end
	)
end

function OnTopPanelDirty()
	if (not isUsingEUITopPanel) then
		UpdateScienceTopPanelInfo()
		UpdateGoldTopPanelInfo()
		UpdateCultureTopPanelInfo()
		UpdateFaithTopPanelInfo()
	end
end
-- Register Events
if ((not isUsingPiety) and (not isUsingEUITopPanel) and (not isUsingCBP)) then
	Events.SerialEventGameDataDirty.Add(OnTopPanelDirty);
	Events.SerialEventTurnTimerDirty.Add(OnTopPanelDirty);
	Events.SerialEventCityInfoDirty.Add(OnTopPanelDirty);
end
--==========================================================================================================================
--==========================================================================================================================