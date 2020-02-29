-- Author: EnormousApplePie

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
--"Start with a free Great General. Great Generals grant Combat Strenth against cities to nearby units, and you gain points towards Great Generals from repairing or improving tiles on conquered cities."
--Add PlotIterators to the mod (The Safavids have one, just copy it from there) and set it as import into VSF = True
--The free Great General can be done through SQL/XML, with Civilization_FreeUnits. 
--You also need to add a promotion that grant combat strength against cities and change the promotionID here.
--The local greatGeneralPoints defines how much you gain from improving tiles.
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

	-- Aesthetics Finisher
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