
-- Author: EnormousApplePie
-- Created: 28-11-2019

----------------------------------------------------------
-------------------- UA, UU, UB ----------------------
----------------------------------------------------------

-- Kilwa UA 
-- Ah, Optimization! Thanks JFD!
local civilissationID = GameInfoTypes["CIVILIZATION_AKSUM"]

function JFD_IsCivilisationActive(civilissationID)
	for iSlot = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local slotStatus = PreGame.GetSlotStatus(iSlot)
		if (slotStatus == SlotStatus["SS_TAKEN"] or slotStatus == SlotStatus["SS_COMPUTER"]) then
			if PreGame.GetCivilization(iSlot) == civilissationID then
				return true
			end
		end
	end

	return false
end

if JFD_IsCivilisationActive(civilissationID) then
	print("Aksum is in this game")
end

-- Kilwa UA function 
function GetTradeRoutesNumberAksum(player, city)
	print("working: aksum 1")
	local tradeRoutes = player:GetTradeRoutes()
	local numRoutesAksum = 0
	for i, v in ipairs(tradeRoutes) do
		local originatingCity = v.FromCity
		if (originatingCity == city) then
			numRoutesAksum = numRoutesAksum + 1
		end
	end
	
	return numRoutesAksum
end


local buildingTraitAksumID = GameInfoTypes["BUILDING_AKSUM_TRAIT"]
function AksumTrait(playerID)
	print("working: aksum 2")
	local player = Players[playerID]
    if player:IsEverAlive() and player:GetCivilizationType() == civilissationID then 
		for city in player:Cities() do
			city:SetNumRealBuilding(buildingTraitAksumID, math.min(GetTradeRoutesNumberAksum(player, city), 1)) -- it does!
		end
	end
end

if JFD_IsCivilisationActive(civilissationID) then
	GameEvents.PlayerDoTurn.Add(AksumTrait)
end

-- Kilwa UA 
-- Ah, Optimization! Thanks JFD!
local civilisationID = GameInfoTypes["CIVILIZATION_MC_KILWA"]

function JFD_IsCivilisationActive(civilisationID)
	for iSlot = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local slotStatus = PreGame.GetSlotStatus(iSlot)
		if (slotStatus == SlotStatus["SS_TAKEN"] or slotStatus == SlotStatus["SS_COMPUTER"]) then
			if PreGame.GetCivilization(iSlot) == civilisationID then
				return true
			end
		end
	end

	return false
end

if JFD_IsCivilisationActive(civilisationID) then
	print("Kilwa is in this game")
end

-- Kilwa UA function 
function GetTradeRoutesNumber(player, city)
	print("working: kilwa 1")
	local tradeRoutes = player:GetTradeRoutes()
	local numRoutes = 0
	for i, v in ipairs(tradeRoutes) do
		local originatingCity = v.FromCity
		if (originatingCity == city) and (v.FromID ~= v.ToID) then -- Thnx TophatPalading for fixing my stuff <3 
			numRoutes = numRoutes + 1
		end
	end
	
	return numRoutes
end

local buildingCoralPortID = GameInfoTypes["BUILDING_CORALSHOP"]
local buildingTraitKilwaID = GameInfoTypes["BUILDING_KILWA_TRAIT"]
function KilwaTrait(playerID)
	print("working: kilwa 2")
	local player = Players[playerID]
    if player:IsEverAlive() and player:GetCivilizationType() == civilisationID then 
		for city in player:Cities() do
			city:SetNumRealBuilding(buildingTraitKilwaID, math.min(GetTradeRoutesNumber(player, city), 420)) -- I wonder if this will work
		end
	end
end

if JFD_IsCivilisationActive(civilisationID) then
	GameEvents.PlayerDoTurn.Add(KilwaTrait)
end

-- Ukraine UA 
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: ukraine ontechbonus")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_UKRAINE"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_THE_WHEEL"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_UKRAINE_TRAIT"], 1);
					for pCity in player:Cities() do
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_UKRAINE_TRAIT"], 1) end
				end
			end
		end
	end
end);

-- From Chrisy15, thanks a lot! :-)

local iUkraineTraitDummy = GameInfoTypes["BUILDING_UKRAINE_TRAIT"]
local iWheel = GameInfoTypes["TECH_THE_WHEEL"]
local iUkraineLeader = GameInfoTypes["LEADER_YAROSLAV"] 

function Ukraine_CityFounded(playerID, iX, iY)
	print("working: ukraine oncityfoundbonus")
    local pPlayer = Players[playerID]
    if pPlayer:GetLeaderType() == iUkraineLeader then
        local pTeam = Teams[pPlayer:GetTeam()] -- Techs are handled on a Team level, because Teams are a thing that exist in this game for some reason
        if pTeam:IsHasTech(iWheel) then
            local pPlot = Map.GetPlot(iX, iY)
            local pCity = pPlot:GetPlotCity()
            pCity:SetNumRealBuilding(iUkraineTraitDummy, 1)
        end
    end
end

GameEvents.PlayerCityFounded.Add(Ukraine_CityFounded)

function Ukraine_CityCaptured(oldPlayerID, bCapital, iPlotX, iPlotY, newPlayerID) -- Thanks TopHatPaladin
    print("working: ukraine oncitycapturebonus")
	local pPlayer = Players[newPlayerID]
    if pPlayer:GetLeaderType() == iUkraineLeader then
        local pTeam = Teams[pPlayer:GetTeam()]
        if pTeam:IsHasTech(iWheel) then
            local pPlot = Map.GetPlot(iPlotX, iPlotY)
            local pCity = pPlot:GetPlotCity()
            pCity:SetNumRealBuilding(iUkraineTraitDummy, 1)
        end
    end
end

GameEvents.CityCaptureComplete.Add(Ukraine_CityCaptured)

-- Turks Unit Promotion 

include("PlotIterators")
local civID = GameInfoTypes["CIVILIZATION_UC_TURKEY"]
local promoID = GameInfoTypes["PROMOTION_UNIT_TURKISH_GWI"]
function TurksGeneralreset(playerID)
	local player = Players[playerID]
	if player:GetCivilizationType() == civID then
		local greatGenerals = {}
		for unit in player:Units() do
			if unit:IsHasPromotion(promoID) then
				unit:SetHasPromotion(promoID, false)
			end
			if unit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
				table.insert(greatGenerals, unit)
			end
		end
		for key,greatGeneral in pairs(greatGenerals) do 
			local plot = greatGeneral:GetPlot()
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsCombatUnit() then
						otherUnit:SetHasPromotion(promoID, true)
					end
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(TurksGeneralreset)

function TurksGeneralbonus(playerID, unitID, unitX, unitY)
	local player = Players[playerID]
	if player:GetCivilizationType() == civID and (player:GetUnitClassCount(GameInfoTypes["UNITCLASS_GREAT_GENERAL"]) > 0) then
		local unit = player:GetUnitByID(unitID)
		local plot = unit:GetPlot()
		if unit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsCombatUnit() and unit:IsHasPromotion(GameInfoTypes.PROMOTION_FREE_UPGRADE_TURKISH) then
						otherUnit:SetHasPromotion(promoID, true)
					end
				end
			end
		elseif unit:IsCombatUnit() and unit:IsHasPromotion(GameInfoTypes.PROMOTION_FREE_UPGRADE_TURKISH) then
			unit:SetHasPromotion(promoID, false)
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
						unit:SetHasPromotion(promoID, true)
					end
				end
			end
		end
	end
end
GameEvents.UnitSetXY.Add(TurksGeneralbonus)

-- Ottoman new UA addition
-- Code by Uighur_Caesar

include("FLuaVector.lua")

local ottoID = GameInfoTypes.CIVILIZATION_OTTOMAN

function OttoPromotion(ownerId, unitId, ePromotion)
local player = Players[ownerId]
	if player:IsAlive() and player:GetCivilizationType() == ottoID then
	local unit = player:GetUnitByID(unitId)
	local xp = unit:GetExperience()
	local needed = unit:ExperienceNeeded()
	local faith = math.ceil(needed / 3)
	player:ChangeFaith(faith)
	if player:IsHuman() then
		local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()))
		Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ENDCOLOR] [ICON_PEACE]", faith), true)
			end
		end
	end
GameEvents.UnitPromoted.Add(OttoPromotion)



-- Tibet new Trait UA
print("loaded tibet ua")
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: tibet UA 25%")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_TIBET"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_DRAMA"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_TIBET"], 1);
				end
			end
		end
	end
end)
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: tibet UA 50%")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_TIBET"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_ACOUSTICS"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_TIBET2"], 1);
				end
			end
		end
	end
end)
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: tibet UA 75%")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_TIBET"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_RADIO"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_TIBET3"], 1);
				end
			end
		end
	end
end)
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: tibet UA 100%")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_TIBET"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_GLOBALIZATION"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_TIBET4"], 1);
				end
			end
		end
	end
end)

-- Venez trait tech research
print("loaded venez ua")
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: venez UA")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_VENEZ"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_COMPASS"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_VENEZ_TRAIT"], 1);
				end
			end
		end
	end
end)

-- Horde free building 

print("loaded horde ua")
GameEvents.TeamSetHasTech.Add(function(iTeam, iTech, bAdopted)
	print("working: horde UA")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_HORDE"] then
			if player:GetTeam() == iTeam then
				if (iTech == GameInfoTypes["TECH_PHILOSOPHY"]) then
					local pCity = player:GetCapitalCity();
					pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_JARLIQ"], 1);
				end
			end
		end
	end
end)

----------------------------------------------------------
-------------------- DUMMY POLICIES ----------------------
----------------------------------------------------------

-- Kilwa Dummy policy

print("dummy policy loaded - Kilwa")
function DummyPolicy(player)
	print("working - Kilwa")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_MC_KILWA"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_KILWA"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_KILWA"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Turkey dummy Policy
print("dummy policy loaded - Turkey")
function DummyPolicy(player)
	print("working - Turkey")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_UC_TURKEY"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_TURKEY"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_TURKEY"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)


-- Ireland dummy Policy
print("dummy policy loaded - Ireland")
function DummyPolicy(player)
	print("working - Ireland")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_IRELAND"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_IRELAND"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_IRELAND"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Ireland dummy Policy
print("dummy policy loaded - Ireland")
function DummyPolicy(player)
	print("working - Ireland")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_IRELAND"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_IRELAND"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_IRELAND"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Scotland dummy Policy
print("dummy policy loaded - Scotland")
function DummyPolicy(player)
	print("working - Wales")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_MC_SCOTLAND"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_SCOTLAND"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_SCOTLAND"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Romania dummy Policy
print("dummy policy loaded - Romania")
function DummyPolicy(player)
	print("working - Romania")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_MC_ROMANIA"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_ROMANIA"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_ROMANIA"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Goth dummy Policy
print("dummy policy loaded - Goth")
function DummyPolicy(player)
	print("working - Goth")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_GOTH"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_GOTH"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_GOTH"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)
-- Korea dummy policy
print("dummy policy loaded - Germany")
function DummyPolicy(player)
	print("working - Germany")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_GERMANY"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_GERMANY"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_GERMANY"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Korea dummy policy
print("dummy policy loaded - Korea")
function DummyPolicy(player)
	print("working - Korea")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_KOREA"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_KOREA"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_KOREA"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Akkad dummy policy
print("dummy policy loaded - Akkad")
function DummyPolicy(player)
	print("working - Akkad")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_LITE_AKKAD"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_AKKAD"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_AKKAD"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)

-- Prussia dummy policy
print("dummy policy loaded - Prussia")
function DummyPolicy(player)
	print("working - Prussia")
	for playerID, player in pairs(Players) do
		local player = Players[playerID];
		if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_PRUSSIA"] then
			if not player:HasPolicy(GameInfoTypes["POLICY_DUMMY_PRUSSIA"]) then
				
				player:SetNumFreePolicies(1)
				player:SetNumFreePolicies(0)
				player:SetHasPolicy(GameInfoTypes["POLICY_DUMMY_PRUSSIA"], true)	
			end
		end
	end 
end
Events.SequenceGameInitComplete.Add(DummyPolicy)


-- Akkad_Laputtu
-- Author: Tomatekh
-- DateCreated: 6/22/2015 6:11:46 PM
--------------------------------------------------------------
print ("Laputtu Workrate Bonus")

local Laputtu = GameInfoTypes.UNIT_LITE_AKKAD_LAPUTTU;
local Pyramids = GameInfoTypes.BUILDINGCLASS_PYRAMID;

function AkkadOverseer(iPlayer)
	local pPlayer = Players[iPlayer];
	local pTeam = pPlayer:GetTeam();
	if (pPlayer:IsAlive()) then
		for pUnit in pPlayer:Units() do
			if (pUnit:GetUnitType() == Laputtu) then
				if not pUnit:IsEmbarked() then 
					local uPlot = pUnit:GetPlot();
					local WorkBonus = 100;
					if pPlayer:GetBuildingClassCount(Pyramids) >= 1 then
						WorkBonus = 125;
					end
					for pBuildInfo in GameInfo.Builds() do
						local BuildTurns = uPlot:GetBuildTurnsLeft(pBuildInfo.ID, 0, 0);
						local BuildProgress = uPlot:GetBuildProgress(pBuildInfo.ID)
						if (BuildTurns >= 1) and (BuildProgress > WorkBonus) then
							uPlot:ChangeBuildProgress(pBuildInfo.ID, WorkBonus, pTeam)
						end
					end
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(AkkadOverseer)


-- AKKAD UA --

include("PlotIterators")
--_________________________________________________________________________________________________________________________________________________________________________________________________________

--_________________________________________________________________________________________________________________________________________________________________________________________________________
local civilizationID = GameInfoTypes["CIVILIZATION_LITE_AKKAD"]
local promotionID = GameInfoTypes["PROMOTION_LITE_AKKAD_CITY_BONUS"]
local greatGeneralPoints = 2
--_________________________________________________________________________________________________________________________________________________________________________________________________________
--GREAT GENERAL BONUS AGAINST CITIES
--_________________________________________________________________________________________________________________________________________________________________________________________________________
function liteGreatGeneralBonusReset(playerID)
	local player = Players[playerID]
	if player:GetCivilizationType() == civilizationID then
		local greatGenerals = {}
		for unit in player:Units() do
			if unit:IsHasPromotion(promotionID) then
				unit:SetHasPromotion(promotionID, false)
			end
			if unit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
				table.insert(greatGenerals, unit)
			end
		end
		for key,greatGeneral in pairs(greatGenerals) do 
			local plot = greatGeneral:GetPlot()
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsCombatUnit() and not(otherUnit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
						otherUnit:SetHasPromotion(promotionID, true)
					end
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(liteGreatGeneralBonusReset)

function liteGreatGeneralBonusAgainstCities(playerID, unitID, unitX, unitY)
	local player = Players[playerID]
	if player:GetCivilizationType() == civilizationID and (player:GetUnitClassCount(GameInfoTypes["UNITCLASS_GREAT_GENERAL"]) > 0) then
		local unit = player:GetUnitByID(unitID)
		local plot = unit:GetPlot()
		if unit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsCombatUnit() and not(otherUnit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
						otherUnit:SetHasPromotion(promotionID, true)
					end
				end
			end
		elseif unit:IsCombatUnit() and not(unit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
			unit:SetHasPromotion(promotionID, false)
			for loopPlot in PlotAreaSweepIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_INCLUDE) do
				for i = 0, loopPlot:GetNumUnits() - 1, 1 do  
					local otherUnit = loopPlot:GetUnit(i)
					if otherUnit and otherUnit:GetOwner() == playerID and otherUnit:IsHasPromotion(GameInfoTypes["PROMOTION_GREAT_GENERAL"]) then
						unit:SetHasPromotion(promotionID, true)
					end
				end
			end
		end
	end
end
GameEvents.UnitSetXY.Add(liteGreatGeneralBonusAgainstCities)
--_________________________________________________________________________________________________________________________________________________________________________________________________________
--GREAT GENERAL POINTS FROM IMPROVEMENTS
--_________________________________________________________________________________________________________________________________________________________________________________________________________
function liteGreatGeneralPointsfromImproving(playerID, plotX, plotY, improvementID) 
	local player = Players[playerID]
	if improvementID then
		if player:GetCivilizationType() == civilizationID then
			local plot = Map.GetPlot(plotX, plotY)
			local city = plot:GetWorkingCity()
			if city and city:IsOccupied() then
				player:ChangeCombatExperience(greatGeneralPoints)
			end
		end
	end
end
GameEvents.BuildFinished.Add(liteGreatGeneralPointsfromImproving)
--_________________________________________________________________________________________________________________________________________________________________________________________________________






-- ProphetReplacer
-- Author: LastSword
-- DateCreated: 8/24/2013 2:56:18 PM
--------------------------------------------------------------
local sUnitType = "UNIT_PROPHET"
local iProphetID = GameInfo.Units.UNIT_PROPHET.ID
local iProphetOverride = GameInfo.Units.UNIT_DALAILAMA.ID
local iCivType = GameInfo.Civilizations["CIVILIZATION_TIBET"].ID

function TibetOverride(iPlayer, iUnit)
    local pPlayer = Players[iPlayer];
    if (pPlayer:IsEverAlive()) then
        if (pPlayer:GetCivilizationType() == iCivType) then
      	    if pPlayer:GetUnitByID(iUnit) ~= nil then
		pUnit = pPlayer:GetUnitByID(iUnit);
               if (pUnit:GetUnitType() == iProphetID) then
                   local newUnit = pPlayer:InitUnit(iProphetOverride, pUnit:GetX(), pUnit:GetY())
                    newUnit:Convert(pUnit);
                end
            end
        end
    end
end

Events.SerialEventUnitCreated.Add(TibetOverride)


-- krivis
-- Author: lek10
-- DateCreated: 4/25/2018 8:23:15 PM
--------------------------------------------------------------

local sUnitType = "UNIT_PROPHET"
local iProphetID = GameInfo.Units.UNIT_PROPHET.ID
local iProphetOverride = GameInfo.Units.UNIT_KRIVIS.ID
local iCivType = GameInfo.Civilizations["CIVILIZATION_LITHUANIA"].ID

function KriviOverride(iPlayer, iUnit)
    local pPlayer = Players[iPlayer];
    if (pPlayer:IsEverAlive()) then
        if (pPlayer:GetCivilizationType() == iCivType) then
       	    if pPlayer:GetUnitByID(iUnit) ~= nil then
		pUnit = pPlayer:GetUnitByID(iUnit);
                if (pUnit:GetUnitType() == iProphetID) then
                    local newUnit = pPlayer:InitUnit(iProphetOverride, pUnit:GetX(), pUnit:GetY())
                    newUnit:Convert(pUnit);
                end
            end
        end
    end
end

Events.SerialEventUnitCreated.Add(KriviOverride)


-- mpiambina
-- Author: lek10
-- DateCreated: 11/21/2018 5:29:36 PM
--------------------------------------------------------------
local sUnitType = "UNIT_INQUISITOR"
local iProphetID = GameInfo.Units.UNIT_INQUISITOR.ID
local iProphetOverride = GameInfo.Units.UNIT_MPIAMBINA.ID
local iCivType = GameInfo.Civilizations["CIVILIZATION_MALAGASY"].ID

function MadaOverride(iPlayer, iUnit)
    local pPlayer = Players[iPlayer];
    if (pPlayer:IsEverAlive()) then
        if (pPlayer:GetCivilizationType() == iCivType) then
       	    if pPlayer:GetUnitByID(iUnit) ~= nil then
		pUnit = pPlayer:GetUnitByID(iUnit);
                if (pUnit:GetUnitType() == iProphetID) then
                    local newUnit = pPlayer:InitUnit(iProphetOverride, pUnit:GetX(), pUnit:GetY())
                    newUnit:Convert(pUnit);
                end
            end
        end
    end
end

Events.SerialEventUnitCreated.Add(MadaOverride)
---------------------
-- On Policy Adopted stuff (uncludes UA's , easier for me to copy pasta stuff <3)
---------------

-- Notes, do realize that this is coded keeping policy requirements/paths in mind, so if you change any of the policy paths in the future, so if anyone besides me is doing policies stuff, DONT FORGET TO CHECK THIS! thnx!

-- Italy ua


function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Piety finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_THEOCRACY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
			(policyID == GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
			(policyID == GameInfo.Policies["POLICY_FREE_RELIGION"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
			(policyID == GameInfo.Policies["POLICY_REFORMATION"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_PIETY"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Tradition Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_ARISTOCRACY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_LANDED_ELITE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MONARCHY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_OLIGARCHY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_LANDED_ELITE"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_ARISTOCRACY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MONARCHY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_OLIGARCHY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_MONARCHY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_LANDED_ELITE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_ARISTOCRACY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_OLIGARCHY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_OLIGARCHY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_LANDED_ELITE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MONARCHY"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_ARISTOCRACY"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_TRADITION"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Liberty Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_COLLECTIVE_RULE"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_REPRESENTATION"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MERITOCRACY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_REPRESENTATION"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_COLLECTIVE_RULE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MERITOCRACY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_MERITOCRACY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_COLLECTIVE_RULE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_REPRESENTATION"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_LIBERTY"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Honor Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_MILITARY_CASTE"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_DISCIPLINE"].ID)) or
			(policyID == GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_CASTE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_DISCIPLINE"].ID)) or
			(policyID == GameInfo.Policies["POLICY_DISCIPLINE"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_CASTE"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_HONOR"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Patronage Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_CONSULATES"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_SCHOLASTICISM"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_PHILANTHROPY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_SCHOLASTICISM"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_CONSULATES"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_PHILANTHROPY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_PHILANTHROPY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_CONSULATES"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_SCHOLASTICISM"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_PATRONAGE"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Aesthetics Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_FINE_ARTS"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_FLOURISHING_OF_ARTS"].ID)) or
			(policyID == GameInfo.Policies["POLICY_FLOURISHING_OF_ARTS"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_FINE_ARTS"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_AESTHETICS"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Exploration Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_TREASURE_FLEETS"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_MERCHANT_NAVY"].ID)) or
			(policyID == GameInfo.Policies["POLICY_MERCHANT_NAVY"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_TREASURE_FLEETS"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_EXPLORATION"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Rationalism Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_SECULARISM"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_HUMANISM"].ID)) or
			(policyID == GameInfo.Policies["POLICY_HUMANISM"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_SECULARISM"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_RATIONALISM"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);

function Italy_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Commerce Finished
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_ITALY"] then

		if	(policyID == GameInfo.Policies["POLICY_ENTREPRENEURSHIP"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_PROTECTIONISM"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_TRADE_UNIONS"].ID)) or
			(policyID == GameInfo.Policies["POLICY_PROTECTIONISM"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_ENTREPRENEURSHIP"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_TRADE_UNIONS"].ID)) or
			(policyID == GameInfo.Policies["POLICY_TRADE_UNIONS"].ID 
			and player:HasPolicy(GameInfo.Policies["POLICY_ENTREPRENEURSHIP"].ID)
			and player:HasPolicy(GameInfo.Policies["POLICY_PROTECTIONISM"].ID)) then

			-- Finished Policy Tree, now add the building
			local pCity = player:GetCapitalCity();
			pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_ITALY_TRAIT_COMMERCE"], 1);
		end
	end 
end
GameEvents.PlayerAdoptPolicy.Add(Italy_OnPolicyAdopted);



-- PietyChanges
-- Author: Cirra
-- DateCreated: 10/17/2019 1:22:18 AM
--------------------------------------------------------------

function Piety_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Piety finisher

	if	(policyID == GameInfo.Policies["POLICY_THEOCRACY"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
		(policyID == GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
		(policyID == GameInfo.Policies["POLICY_FREE_RELIGION"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_REFORMATION"].ID)) or
		(policyID == GameInfo.Policies["POLICY_REFORMATION"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_MANDATE_OF_HEAVEN"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_FREE_RELIGION"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_THEOCRACY"].ID)) then

		-- The player has finished Piety. Add a Grand Monument to the capital, gives allows buying great people.
		local pCity = player:GetCapitalCity();
		pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_PIETY_FINISHER"], 1);

		local i = 0
		local iIndo = GameInfo.Civilizations["CIVILIZATION_INDONESIA"].ID
		local iKhmer = GameInfo.Civilizations["CIVILIZATION_KHMER"].ID
		local iRoma = GameInfo.Civilizations["CIVILIZATION_MC_ROMANIA"].ID
		for pCity in player:Cities() do
			if i >= 4 then break end
			if (player:GetCivilizationType() == iIndo) then pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_CANDI"], 1) 
			elseif (player:GetCivilizationType() == iKhmer) then pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_BARAY"], 1)
			elseif (player:GetCivilizationType() == iRoma) then pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_MC_ROMANIAN_PAINTED_MONASTERY"], 1)
			else pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_GARDEN"], 1) end
			i = i + 1
		end
	end
end
GameEvents.PlayerAdoptPolicy.Add(Piety_OnPolicyAdopted);

-- HonorChanges
-- Author: Cirra
-- DateCreated: 7/27/2019 1:22:18 AM
--------------------------------------------------------------

function Honor_OnPolicyAdopted(playerID, policyID)

	local player = Players[playerID]

	-- Honor Finisher
	if	(policyID == GameInfo.Policies["POLICY_DISCIPLINE"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_CASTE"].ID)) or
		(policyID == GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_DISCIPLINE"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_CASTE"].ID)) or
		(policyID == GameInfo.Policies["POLICY_MILITARY_CASTE"].ID 
		and player:HasPolicy(GameInfo.Policies["POLICY_MILITARY_TRADITION"].ID)
		and player:HasPolicy(GameInfo.Policies["POLICY_DISCIPLINE"].ID)) then

		-- The player has finished Honor. Add old ToA to the capital, which gives +10% food everywhere.
		local pCity = player:GetCapitalCity();
		pCity:SetNumRealBuilding(GameInfoTypes["BUILDING_HONOR_FINISHER"], 1);

	end

end
GameEvents.PlayerAdoptPolicy.Add(Honor_OnPolicyAdopted);
