
-- Author: EnormousApplePie
-- Created: 28-11-2019


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


-- Ancient Ruins v23
-- AncientRuins
-- Author: monju125
-- DateCreated: 4/15/2015 4:32:49 PM
--------------------------------------------------------------

include("MT_Events.lua");
include("IconSupport");
include("InstanceManager");

print("AncientRuins.lua loaded");

local resourceManager = InstanceManager:new("AROverlayResourceInstance", "Anchor", Controls.AROverlayResourceContainer);
local resourceInstances = {};
local width, height;

MapModData.GoodyChoices = MapModData.GoodyChoices or {};
local db = Modding.OpenSaveData();

resourcesRevealed = 0;
savedRuins = 0;
ruinsPlots = {};
ruinsPlotIndex = 1;
ruinsExplored = 1;
rewardTracker = {};
rewardIDs = {};
rewardCount = 0;

local bGodsAndKings = ContentManager.IsActive("0E3751A1-F840-4e1b-9706-519BF484E59D", ContentType.GAMEPLAY);
local bBraveNewWorld= ContentManager.IsActive("6DA07636-4123-4018-B643-6575B4EC336B", ContentType.GAMEPLAY);

function Init()
	local pPlayer = Players[Game.GetActivePlayer()];
	local sqlVersionCheck = "";
	if not bGodsAndKings and not bBraveNewWorld then
		sqlVersionCheck = " AND Compatibility = 'Vanilla'";
	end

	-- Build ruins plots array
	width, height = Map.GetGridSize();
	for i=0,width-1,1 do
		for j=0,height-1,1 do
			local pPlot = Map.GetPlot(i, j);
			if pPlot:IsGoody() then
				print("Found Ancient Ruins at: " .. i .. "," .. j);
				ruinsPlots[ruinsPlotIndex] = {i, j, 0};
				ruinsPlotIndex = ruinsPlotIndex+1;
				--pPlot:SetRevealed(pPlayer:GetTeam(), true);
				--pPlot:UpdateFog();
			end
		end
	end

	-- Build reward tracker and reward ID arrays for each player, including saved game data
	for id, player in pairs(Players) do
		rewardCount = 0;
		if player:IsEverAlive() then
			if id < 22 then
				rewardTracker[id] = {};
				local handicapType;	
				-- Get difficulty setting
				for row in DB.Query("SELECT Type FROM HandicapInfos WHERE ID=" .. Game.GetHandicapType()) do
					handicapType = row.Type;
					print("Difficulty setting: " .. handicapType);
				end
				-- Initialize reward tracker array
				for row in DB.Query("SELECT ID FROM AncientRuinsRewards") do
					rewardTracker[id][row.ID] = -1;
				end
				-- Set the reward tracker and reward IDs for each available reward
				for row in DB.Query("SELECT RewardType FROM HandicapInfo_AncientRuins WHERE " .. string.gsub(handicapType, "HANDICAP_", "") .. "=1") do
					for row in DB.Query("SELECT ID FROM AncientRuinsRewards WHERE Type ='" .. row.RewardType .. "'" .. sqlVersionCheck) do
						rewardTracker[id][row.ID] = 0;
						rewardIDs[rewardCount] = row.ID;
						rewardCount = rewardCount+1;
					
						-- Set the reward to used if false in saved data (not on first load)
						if Game.GetElapsedGameTurns() > 0 then
							local savedReward = db.GetValue("savedReward" .. id .. "," .. row.ID);
							if savedReward ~= nil then
								if savedReward == 1 then
									rewardTracker[id][row.ID] = 1;
								end
							end
						end
						print("rewardTracker PlayerID " .. id .. " rewardID " .. row.ID .. " " .. rewardTracker[id][row.ID]);
					end
				end
				print("rewardCount: " .. rewardCount);
			end
		end
	end
	
	-- Load resource overlay for revealed strategic resources
	resourcesRevealed = db.GetValue("savedResources");
	if resourcesRevealed ~=nil then
		for i=0,resourcesRevealed,1 do
			local resourcePlot = db.GetValue("savedResource" .. i);
			local resourceID = db.GetValue("savedResourceType" .. i);
			if resourcePlot ~= nil and resourceID ~= nil then
				local comma = string.find(resourcePlot, ",");
				local rx = tonumber(string.sub(resourcePlot,1,comma-1));
				local ry = tonumber(string.sub(resourcePlot,comma+1));
				local rPlot = Map.GetPlot(rx,ry);
				rPlot:SetRevealed(pPlayer:GetTeam(),true)
				rPlot:UpdateFog();
				if resourceID < 6 then
					UpdateResourceOverlay(pPlayer,rPlot);
				end
			end
		end
	else
		resourcesRevealed = 0;
	end
end
Events.LoadScreenClose.Add(Init)

-- Function to check if a unit is on an ancient ruin called whenever a unit moves
function HandleRuin(player, unit, x, y)
	-- Exit if all ruins have been explored
	if ruinsExplored == ruinsPlotIndex then
		--print("All ruins explored");
		return;
	end
	local pPlayer = Players[player];
	local uUnit = pPlayer:GetUnitByID(unit);
	local pathfinderID = -1;
	for row in DB.Query("SELECT ID FROM UnitPromotions WHERE Type ='PROMOTION_GOODY_HUT_PICKER'") do
		pathfinderID = row.ID;
	end
	local uPlot = uUnit:GetPlot();

	--[[ Only run reward code if a single unit is on the plot (prevents rewards that spawn another unit on the plot from
	     forcing an infinite loop) and the unit is not a barbarian/minor civ --]]
	if uPlot ~= nil then
		if uPlot:GetNumUnits() == 1 and uUnit:GetOwner() < GameDefines.MAX_MAJOR_CIVS-1 then
			local aPlayerID = Game.GetActivePlayer();
			for index=1,ruinsPlotIndex-1,1 do
				local ruinsx = ruinsPlots[index][1];
				local ruinsy = ruinsPlots[index][2];
				local uX = uPlot:GetX();
				local uY = uPlot:GetY();

				-- On ruins and ruins plot is unexplored
				if ruinsx == uX and ruinsy == uY and ruinsPlots[index][3] == 0 then
					print("Player " .. player .. " unit is on ruins at: " .. ruinsx .. "," .. ruinsy);

					-- If unit has the pathfinder promotion and the unit belongs to the active player, use choose reward code
					if uUnit:IsHasPromotion(pathfinderID) and player == aPlayerID then
						print("Pathfinder unit " .. unit);
						local rewardAvailable = false;
						-- Check to see if any rewards are still available
						for iReward,vReward in ipairs(rewardTracker[player]) do
							if rewardTracker[player][iReward] == 0 then
								rewardAvailable = true;
							end
						end
						--[[ If no rewards are still available, reset used rewards to available and to deferred
							 if the player/unit cannot currently receive it --]]
						for iReward,vReward in ipairs(rewardTracker[player]) do
							for row in DB.Query("SELECT Type FROM AncientRuinsRewards WHERE ID = " .. iReward) do
								if not rewardAvailable then
									if rewardTracker[player][iReward] == 1 then
										rewardTracker[player][iReward] = 0;
										db.SetValue("savedReward" .. player .. "," .. iReward, 0);
									end
								end
								local canReceive = CanReceiveReward(pPlayer, uUnit, uPlot, row.Type);
								if not canReceive and rewardTracker[player][iReward] == 0 then
									rewardTracker[player][iReward] = 2;
									db.SetValue("savedReward" .. player .. "," .. iReward, 0);
								elseif canReceive and rewardTracker[player][iReward] == 2 then
									rewardTracker[player][iReward] = 0;
									db.SetValue("savedReward" .. player .. "," .. iReward, 0);
								end
							end
						end
						-- Pass the player's reward tracker to MapModData and then call the ChooseGoodyHutReward popup
						MapModData.GoodyChoices = rewardTracker[player];
						local popupInfo = {
							Type = ButtonPopupTypes.BUTTONPOPUP_CHOOSE_GOODY_HUT_REWARD,
							Data1 = player,
							Data2 = unit;
							}
						print("ChooseGoodyHut popupInfo: " .. ButtonPopupTypes.BUTTONPOPUP_CHOOSE_GOODY_HUT_REWARD .. " " .. popupInfo.Data1 .. " " .. popupInfo.Data2);
						Events.SerialEventGameMessagePopup(popupInfo);
					else
						-- Non-pathfinder unit/pathfinder unit but not active player runs random reward code
						local rewardGiven = false
						-- Get random reward type until a valid reward is found/given
						while not rewardGiven do
							local rewardID = GetRewardType(player);
							local rewardType;
							for row in DB.Query("SELECT Type FROM AncientRuinsRewards WHERE ID=" .. rewardID) do
								rewardType = row.Type;
							end
							local fstReceivedValue, sndReceivedValue, rewardState = ReceiveRuinsReward(pPlayer, uUnit, uPlot, rewardType);
							rewardGiven = rewardState;
					
							DisplayRewardPopup(pPlayer, rewardID, fstReceivedValue, sndReceivedValue);
						
							if rewardGiven then
								ruinsPlots[index][3] = 1;
								ruinsExplored = ruinsExplored+1;
							else
								db.SetValue("savedReward" .. player .. "," .. rewardID, 0);
							end
						end
					end
				end
			end
		end
	end
end
GameEvents.UnitSetXY.Add(HandleRuin)

-- Handles custom Lua event called by GoodyChooseHutReward when a reward is chosen
function HandleRewardChosen(pPlayer, uUnit, uPlot, rewardType)
	local rewardID;
	print("RewardChosen for player " .. pPlayer:GetID() .. " unit " .. uUnit:GetName() .. " plot " .. uPlot:GetX() .. "," .. uPlot:GetY() .. " " .. rewardType);

	for row in DB.Query("SELECT ID FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
		rewardID = row.ID;
	end
	-- Receive selected reward
	local fstReceivedValue, sndReceivedValue, rewardState = ReceiveRuinsReward(pPlayer, uUnit, uPlot, rewardType);
	local aPlayerID = Game.GetActivePlayer();
	local iPlayer = pPlayer:GetID();
	-- Set reward tracker for selected reward to used (1) and find unit's current plot and set it to explored
	rewardTracker[iPlayer][rewardID] = 1;
	db.SetValue("savedReward" .. iPlayer .. "," .. rewardID, 1);
	for index=1,ruinsPlotIndex-1,1 do
		local ruinsx = ruinsPlots[index][1];
		local ruinsy = ruinsPlots[index][2];
		local uX = uPlot:GetX();
		local uY = uPlot:GetY();
		
		if ruinsx == uX and ruinsy == uY then
			ruinsPlots[index][3] = 1;
			ruinsExplored = ruinsExplored+1;
		end
	end
	DisplayRewardPopup(pPlayer, rewardID, fstReceivedValue, sndReceivedValue);
end
LuaEvents.RewardChosenEvent.Add(HandleRewardChosen)

function DisplayRewardPopup(pPlayer, rewardID, popupValue, popupText)
	local aPlayerID = Game.GetActivePlayer();
	
	-- Only show popup if the player is non-AI
	if (aPlayerID == pPlayer:GetID()) then
		local popupInfo = {
			Type = ButtonPopupTypes.BUTTONPOPUP_GOODY_HUT_REWARD,
			Data1 = rewardID,
			Data2 = popupValue,
			Text = popupText,
			Data4 = 1000000;
			}
			Events.SerialEventGameMessagePopup(popupInfo);
	end
end

function CanReceiveReward(pPlayer, uUnit, uPlot, rewardType)
	local playerID = pPlayer:GetID();
	local rewardID;
	for row in DB.Query("SELECT ID FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
		rewardID = row.ID;
	end
	if (rewardType == "GOODY_SETTLER") then
		local veniceID = GameInfo.Civilizations{Type="CIVILIZATION_VENICE"}().ID;
		local playerCivID = pPlayer:GetCivilizationType();
		-- Civ must not be Venice and OCC must not be enabled
		if (playerCivID == veniceID or Game.IsOption(GameOptionTypes.GAMEOPTION_ONE_CITY_CHALLENGE)) then
			rewardTracker[playerID][rewardID] = -1;
			return false;
		end
	elseif (rewardType == "GOODY_POPULATION" or rewardType == "GOODY_FOOD" or rewardType == "GOODY_PRODUCTION") then
		-- Must have founded a capital city
		local capCity = pPlayer:GetCapitalCity();
		if capCity == nil then
			return false;
		end
		-- Must be constructing a building in capital city
		if rewardType == "GOODY_PRODUCTION" then
			local buildingProd = capCity:GetProductionBuilding();
			if buildingProd == nil or buildingProd == -1 then
				return false;
			end
		end
		-- Empire must not be unhappy
		if rewardType == "GOODY_POPULATION" or rewardType == "GOODY_FOOD" then
			if pPlayer:IsEmpireUnhappy() then
				return false;
			end
		end
	elseif (rewardType == "GOODY_PROPHET_FAITH") then
		-- Must have created a pantheon
		if not pPlayer:HasCreatedPantheon() then
			return false;
		end
	elseif (rewardType == "GOODY_TECH" or rewardType == "GOODY_SCIENCE") then
		-- Must have at least one goody tech still available
		local techAvailable = false;
		for row in DB.Query("SELECT ID, Type, Cost FROM Technologies WHERE GoodyTech=1") do
			local goodyTechID = row.ID;
			local goodyTechType = row.Type;
			local goodyTechCost = row.Cost;
			local pTeamTechs = Teams[pPlayer:GetTeam()]:GetTeamTechs();
			if not pTeamTechs:HasTech(goodyTechID) then
				techAvailable = true;
			end
		end
		if not techAvailable then
			rewardTracker[playerID][rewardID] = -1;
			return false;
		end
	elseif (rewardType == "GOODY_UPGRADE_UNIT") then
		-- Must have a unit upgrade class defined and it must not be an era > ancient/classical
		local upgradeFound = false;
		local upgradeClass;
		for row in DB.Query("SELECT GoodyHutUpgradeUnitClass FROM Units WHERE ID = " .. uUnit:GetUnitType()) do
			upgradeFound = true;
			upgradeClass = row.GoodyHutUpgradeUnitClass;
		end
		if upgradeFound then
			local defaultUnit = GameInfo.UnitClasses{Type=upgradeClass}().DefaultUnit;
			local unitTech = GameInfo.Units{Type=defaultUnit}().PrereqTech;
			local techEra = GameInfo.Technologies{Type=unitTech}().Era;
			print(defaultUnit .. " " .. unitTech .. " " .. techEra);
			if (techEra ~= "ERA_ANCIENT" and techEra ~= "ERA_CLASSICAL") then
				return false;
			end
		else
			return false;
		end
	elseif (rewardType == "GOODY_HEALING") then
		-- Must have less HP than the damage prerequisite
		local damagePrereq;
		for row in DB.Query("SELECT DamagePrereq FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
			damagePrereq = row.DamagePrereq;
		end
		local currHP = uUnit:GetCurrHitPoints();
		local maxHP = uUnit:GetMaxHitPoints();
		if currHP == maxHP or ((currHP/maxHP)*100) > damagePrereq then
			return false;
		end
	elseif (rewardType == "GOODY_BARBARIANS_WEAK") or (rewardType == "GOODY_BARBARIANS_STRONG") then
		-- Must not be a scout unit and game must have barbarians enabled
		local classType = GameInfo.UnitClasses[uUnit:GetUnitClassType()].Type;
		if Game.IsOption(GameOptionTypes.GAMEOPTION_NO_BARBARIANS) then
			rewardTracker[playerID][rewardID] = -1;
			return false;
		end
		if classType == "UNITCLASS_SCOUT" then
			return false;
		end
	elseif (rewardType == "GOODY_REVEAL_NEARBY_BARBS") then
		-- Must have barbarians enabled
		if Game.IsOption(GameOptionTypes.GAMEOPTION_NO_BARBARIANS) then
			rewardTracker[playerID][rewardID] = -1;
			return false;
		end
	elseif (rewardType == "GOODY_REVEAL_RUINS") then
		local numReveals = CanRevealRuins(pPlayer);
		if numReveals == 0 then
			rewardTracker[playerID][rewardID] = -1;
			return false;
		end
	end
	return true;
end

-- Applies the selected reward if the player/unit can receive it
function ReceiveRuinsReward(pPlayer, uUnit, uPlot, rewardType)
	local playerID = pPlayer:GetID();
	if CanReceiveReward(pPlayer, uUnit, uPlot, rewardType) then
		local currHandicap = 7-Game.GetHandicapType();
		local scaleTurn = Game.GetGameTurn();
		if (rewardType == "GOODY_WARRIOR" or rewardType == "GOODY_SETTLER" or rewardType == "GOODY_SCOUT" or rewardType == "GOODY_WORKER") then
			local unitType = string.gsub(rewardType, "GOODY_", "UNIT_");
			local unitSpawned = RewardUnit(pPlayer, uUnit, uPlot, GameInfoTypes[unitType]);
			return -1,-1,unitSpawned;
		elseif (rewardType == "GOODY_POPULATION") then
			local popGrowth;
			for row in DB.Query("SELECT Population FROM AncientRuinsRewards WHERE Type='GOODY_POPULATION'") do
				popGrowth = row.Population;
			end
			RewardPopulation(pPlayer, popGrowth);
			return popGrowth,-1,true;
		elseif (rewardType == "GOODY_CULTURE") and scaleTurn > 8 then
			local cultureGrowth;
			local handicapModifier;
			local gamespeedModifier;
			for row in DB.Query("SELECT Culture, HandicapModifier, GamespeedModifier, FROM AncientRuinsRewards WHERE Type='GOODY_CULTURE'") do
				cultureGrowth = row.Culture;
				handicapModifier = row.HandicapModifier;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			cultureGrowth = (cultureGrowth+(currHandicap*handicapModifier))*(gamespeedModifier/100);
			RewardCulture(pPlayer, cultureGrowth);
			return cultureGrowth,-1,true;
		elseif (rewardType == "GOODY_PANTHEON_FAITH") then
			RewardFaith(pPlayer, rewardType, 30);
			for row in DB.Query("SELECT ID FROM AncientRuinsRewards WHERE Type='GOODY_PROPHET_FAITH'") do
				if (rewardTracker[playerID][row.ID] == 2) then
					rewardTracker[playerID][row.ID] = 0;
				end
			end
			return 30,-1,true;
		elseif (rewardType == "GOODY_PROPHET_FAITH") then
			RewardFaith(pPlayer, rewardType, 80, uUnit, uPlot);
			return 80,-1,true;
		elseif (rewardType == "GOODY_REVEAL_NEARBY_BARBS") then
			local barbsFound = RewardRevealBarbarians(pPlayer, uUnit, uPlot);
			return -1,-1,barbsFound;
		elseif (rewardType == "GOODY_GOLD" or rewardType == "GOODY_LOW_GOLD" or rewardType == "GOODY_HIGH_GOLD") then
			local baseGold;
			local numRolls;
			local rollAmount;
			local gamespeedModifier;
			for row in DB.Query("SELECT Gold, NumGoldRandRolls, GoldRandAmount, GamespeedModifier FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
				baseGold = row.Gold;
				numRolls = row.NumGoldRandRolls;
				rollAmount = row.GoldRandAmount;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			local goldAmount = RewardGold(pPlayer, baseGold, numRolls, rollAmount, gamespeedModifier);
			return goldAmount,-1,true;
		elseif (rewardType == "GOODY_MAP") then
			local mapOffset;
			local mapRange;
			local mapProb;
			for row in DB.Query("SELECT MapOffset, MapRange, MapProb FROM AncientRuinsRewards WHERE Type='GOODY_MAP'") do
				mapOffset = row.MapOffset;
				mapRange = row.MapRange;
				mapProb = row.MapProb;
			end
			RewardMap(pPlayer, uPlot, mapOffset, mapRange, mapProb);
			return -1,-1,true;
		elseif (rewardType == "GOODY_TECH") then
			local techRewarded = RewardTech(pPlayer, true);
			return -1,-1,techRewarded;
		elseif (rewardType == "GOODY_REVEAL_RESOURCE") then
			local resourceFound = RewardRevealResource(pPlayer, uPlot);
			return -1,-1,resourceFound;
		elseif (rewardType == "GOODY_UPGRADE_UNIT") then
			local upgradeRewarded = RewardUpgrade(pPlayer, uUnit, uPlot);
			return -1,-1,upgradeRewarded;
		elseif (rewardType == "GOODY_BARBARIANS_WEAK" or rewardType == "GOODY_BARBARIANS_STRONG") then
			local numBarbs;
			local barbClass;
			for row in DB.Query("SELECT MinBarbarians, MaxBarbarians, BarbarianUnitClass FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
				minBarbs = row.MinBarbarians;
				maxBarbs = row.MaxBarbarians;
				barbClass = row.BarbarianUnitClass;
			end
			local barbSpawned = RewardBarbarians(pPlayer, uUnit, uPlot, minBarbs, maxBarbs, barbClass);
			return -1,-1,barbSpawned;
		elseif (rewardType == "GOODY_EXPERIENCE") then
			local rewardExp;
			local handicapModifier;
			for row in DB.Query("SELECT Experience, HandicapModifier FROM AncientRuinsRewards WHERE Type='GOODY_EXPERIENCE'") do
				rewardExp = row.Experience;
				handicapModifier = row.HandicapModifier;
			end
			rewardExp = rewardExp+(currHandicap*handicapModifier);
			RewardExperience(pPlayer, uUnit, rewardExp);
			return rewardExp,-1,true;
		elseif (rewardType == "GOODY_HEALING") then
			local damagePrereq;
			local healingAmount;
			for row in DB.Query("SELECT DamagePrereq, Healing FROM AncientRuinsRewards WHERE Type='GOODY_HEALING'") do
				damagePrereq = row.DamagePrereq;
				healingAmount = row.Healing;
			end
			local unitHealed = RewardHealing(pPlayer, uUnit, damagePrereq, healingAmount);
			return -1,-1,unitHealed;
		elseif (rewardType == "GOODY_FOOD") then
			local foodAmount;
			local handicapModifier;
			local gamespeedModifier;
			for row in DB.Query("SELECT Food, HandicapModifier, GamespeedModifier FROM AncientRuinsRewards WHERE Type='GOODY_FOOD'") do
				foodAmount = row.Food;
				handicapModifier = row.HandicapModifier;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			foodAmount = (foodAmount+(currHandicap*handicapModifier))*(gamespeedModifier/100);
			RewardFood(pPlayer, foodAmount);
			return foodAmount,-1,true;
		elseif (rewardType == "GOODY_SCIENCE") then
			local scienceAmount;
			local handicapModifier;
			local gamespeedModifier;
			for row in DB.Query("SELECT Science, HandicapModifier, GamespeedModifier FROM AncientRuinsRewards WHERE Type='GOODY_SCIENCE'") do
				scienceAmount = row.Science;
				handicapModifier = row.HandicapModifier;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			scienceAmount = (scienceAmount+(currHandicap*handicapModifier))*(gamespeedModifier/100);
			local techRewarded = RewardTech(pPlayer, false, scienceAmount);
			if techRewarded ~= "none" then
				for row in DB.Query("SELECT Description FROM Technologies WHERE Type='" .. techRewarded .."'") do
					techRewarded = Locale.ConvertTextKey(row.Description);
				end
				return scienceAmount,techRewarded,true;
			else
				return -1,-1,false;
			end
		elseif (rewardType == "GOODY_PRODUCTION") then
			local productionAmount;
			local handicapModifier;
			local gamespeedModifier;
			for row in DB.Query("SELECT Production, HandicapModifier, GamespeedModifier FROM AncientRuinsRewards WHERE Type='GOODY_PRODUCTION'") do
				productionAmount = row.Production;
				handicapModifier = row.HandicapModifier;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			productionAmount = (productionAmount+(currHandicap*handicapModifier))*(gamespeedModifier/100);
			local currentProduction = RewardProduction(pPlayer, productionAmount);
			if currentProduction == -1 then
				return -1,-1,false;
			else
				currentProduction = GameInfo.Buildings{ID=currentProduction}().Description;
				return productionAmount,currentProduction,true;
			end
		elseif (rewardType == "GOODY_FAITH") then
			local faithGrowth;
			local handicapModifier;
			local gamespeedModifier;
			for row in DB.Query("SELECT Faith, HandicapModifier, GamespeedModifier FROM AncientRuinsRewards WHERE Type='GOODY_FAITH'") do
				faithGrowth = row.Faith;
				handicapModifier = row.HandicapModifier;
				for gsrow in DB.Query("SELECT " .. row.GamespeedModifier .. " 'Modifier' FROM GameSpeeds WHERE ID = " .. Game.GetGameSpeedType()) do
					gamespeedModifier = gsrow.Modifier;
				end
			end
			faithGrowth = (faithGrowth+(currHandicap*handicapModifier))*(gamespeedModifier/100);
			RewardFaith(pPlayer, rewardType, faithGrowth, uUnit, uPlot);
			return faithGrowth,-1,true;
		elseif (rewardType == "GOODY_REVEAL_RUINS") then
			local revealProb;
			for row in DB.Query("SELECT RevealProb FROM AncientRuinsRewards WHERE Type='GOODY_REVEAL_RUINS'") do
				revealProb = row.RevealProb;
			end
			local ruinsRevealed = RewardRevealRuins(pPlayer, revealProb);
			return -1,-1,ruinsRevealed;
		end
		return -1,-1,true;
	else
		local rewardID;
		for row in DB.Query("SELECT ID FROM AncientRuinsRewards WHERE Type='" .. rewardType .. "'") do
			rewardID = row.ID;
		end
		if rewardTracker[playerID][rewardID] == 0 then
			rewardTracker[playerID][rewardID] = 2;
		end
		return -1,-1,false;
	end
end

function RewardUnit(pPlayer, uUnit, uPlot, unitType)
	local newUnit;
	local newUnitType;
	for row in DB.Query("SELECT CombatLimit FROM Units WHERE ID = " .. unitType) do
		newUnitType = row.CombatLimit;
	end
	newUnit = pPlayer:InitUnit(unitType, uPlot:GetX(), uPlot:GetY());
	if (uUnit:IsCombatUnit() and newUnitType ~= 0) or (not uUnit:IsCombatUnit() and newUnitType == 0) then
		newUnit:JumpToNearestValidPlot();
	end
	newUnit:SetMoves(0);
	return true;
end

function RewardPopulation(pPlayer, popGrowth)
	local capCity = pPlayer:GetCapitalCity();
	capCity:ChangePopulation(popGrowth, true);
end

function RewardCulture(pPlayer, cultureGrowth)
	pPlayer:ChangeJONSCulture(cultureGrowth);
end

function RewardFaith(pPlayer, faithType, faithGrowth, uUnit, uPlot)
	local currentFaith = pPlayer:GetFaith();
	pPlayer:SetFaith(currentFaith+faithGrowth);
	if faithType == "GOODY_PROPHET_FAITH" then
		local prophetChance;
		for row in DB.Query("SELECT ProphetPercent FROM AncientRuinsRewards WHERE Type = '" .. faithType .. "'") do
			prophetChance = row.ProphetPercent;
		end
		if prophetChance > 0 then
			local rProphet = math.random(100);
			if rProphet <= prophetChance then
				RewardUnit(pPlayer, uUnit, uPlot, GameInfoTypes["UNIT_PROPHET"]);
			end
		end
	end
end

function RewardRevealBarbarians(pPlayer, uUnit, uPlot)
	local improvementType = GameInfo.Improvements.IMPROVEMENT_BARBARIAN_CAMP.ID;
	local nearestPlot;
	local nearestDistance = 10000;
	for index=0,Map.GetNumPlots()-1,1 do
		local pPlot = Map.GetPlotByIndex(index);
		if pPlot:GetImprovementType() == improvementType then
			local distanceTo = Map.PlotDistance(uPlot:GetX(), uPlot:GetY(), pPlot:GetX(), pPlot:GetY());
			if distanceTo < nearestDistance then
				if not pPlot:IsRevealed(pPlayer:GetTeam(), true) then
					nearestPlot = pPlot;
					nearestDistance = distanceTo;
				end
			end
		end
	end
	if nearestPlot ~= nil then
		nearestPlot:SetRevealed(pPlayer:GetTeam(), true);
		nearestPlot:UpdateFog();
		if Game.GetActivePlayer() == pPlayer:GetID() then
			UI.LookAt(nearestPlot, 0);
		end
		return true;
	end
	return false;
end

function RewardGold(pPlayer, baseGold, numRolls, rollAmount, gamespeedModifier)
	local goldAmount = baseGold;
	for i=1,numRolls,1 do
		goldAmount = goldAmount+(math.random(0,rollAmount));
	end
	goldAmount = goldAmount*(gamespeedModifier/100);
	local currGold = pPlayer:GetGold();
	pPlayer:SetGold(currGold+goldAmount);
	return goldAmount;
end

function RewardMap(pPlayer, uPlot, mapOffset, mapRange, mapProb)
	local numDirections = DirectionTypes.NUM_DIRECTION_TYPES;
	local direction = math.random(0,numDirections-1);
	local centerPlot = uPlot;
	for i=1,mapOffset,1 do
		centerPlot = Map.PlotDirection(centerPlot:GetX(), centerPlot:GetY(), direction);
	end
	if Game.GetActivePlayer() == pPlayer:GetID() then
		UI.LookAt(centerPlot, 0);
	end
	local centerRand = math.random(1,100);
	if centerRand <= mapProb then
		centerPlot:SetRevealed(pPlayer:GetTeam(), true);
		centerPlot:UpdateFog();
	end
	for iDX=-mapRange,mapRange,1 do
		for iDY=-mapRange,mapRange,1 do
			local pTargetPlot = Map.GetPlotXY(centerPlot:GetX(), centerPlot:GetY(), iDX, iDY);
			if pTargetPlot ~= nil then
				local randShow = math.random(1,100);
				if randShow <= mapProb then
					pTargetPlot:SetRevealed(pPlayer:GetTeam(), true);
					pTargetPlot:UpdateFog();
				end
			end
		end
	end
end

function RewardTech(pPlayer, fullTech, scienceAmount)
	local countTechs;
	for row in DB.Query("SELECT Count(ID) 'Count' FROM Technologies WHERE GoodyTech=1") do
		countTechs = row.Count;
	end
	local goodyTechs = {};
	local goodyIndex = 0;
	for row in DB.Query("SELECT ID, Type, Cost FROM Technologies WHERE GoodyTech=1") do
		goodyTechs[goodyIndex] = row;
		goodyIndex = goodyIndex+1;
	end
	local techsChecked = 0;
	while techsChecked < countTechs do
		local randomTech = math.random(countTechs-1);
		local goodyTechID = goodyTechs[randomTech].ID;
		local goodyTechType = goodyTechs[randomTech].Type;
		local goodyTechCost = goodyTechs[randomTech].Cost;
		local pTeamTechs = Teams[pPlayer:GetTeam()]:GetTeamTechs();
		if not pTeamTechs:HasTech(goodyTechID) then
			local prereqsMet = true;
			for row in DB.Query("SELECT PrereqTech FROM Technology_PrereqTechs WHERE TechType = '" .. goodyTechType .. "'") do
				local prereqTechID = GameInfo.Technologies{Type=row.PrereqTech}().ID;
				if not pTeamTechs:HasTech(prereqTechID) then
					prereqsMet = false;
				end
			end
			if prereqsMet then
				if fullTech then
					local techTooFar = false;
					local researchingTech = false;
					if (pPlayer:GetCurrentResearch() == goodyTechID) then
						researchingTech = true;
						local iProgress = pPlayer:GetResearchProgress(goodyTechID);
						if iProgress/goodyTechCost > .33 then
							techTooFar = true;
						end
					end
					if not techTooFar then
						if researchingTech then
							pPlayer:AddNotification(NotificationTypes.NOTIFICATION_TECH, "Choose Research", "Choose Research");
						end
						Teams[pPlayer:GetTeam()]:SetHasTech(goodyTechID, true);
						return goodyTechType;
					else
						techsChecked = techsChecked+1;
					end
				else
					pTeamTechs:ChangeResearchProgress(goodyTechID, scienceAmount, pPlayer:GetID());
					return goodyTechType;
				end
			else
				techsChecked = techsChecked+1;
			end
		else
			techsChecked = techsChecked+1;
		end
	end
	return "none";
end

function RewardRevealResource(pPlayer, uPlot)
	local playerID = pPlayer:GetID();
	local countResources;
	local nearestPlot;
	local nearestDistance = 10000;
	for row in DB.Query("SELECT Count(Type) 'Count' FROM Resources WHERE Happiness > 0 OR TechReveal is not NULL") do
		countResources = row.Count;
	end
	local resourceTypes = {};
	local resourceTypesChecked = {};
	local resourceIndex = 0;
	local resourcesChecked = 0;
	for row in DB.Query("SELECT ID, Type, Happiness, TechReveal FROM Resources WHERE Happiness > 0 OR TechReveal is not NULL") do
		resourceTypes[resourceIndex] = row;
		resourceTypesChecked[resourceIndex] = false;
		resourceIndex = resourceIndex+1;
	end
	local resourceFound = false;
	while not resourceFound do
		local randResource = math.random(countResources-1);
		if not resourceTypesChecked[resourceIndex] then
			local resourceID = resourceTypes[randResource].ID;
			local resourceType = resourceTypes[randResource].Type;
			local isLuxury = resourceTypes[randResource].Happiness;
			for index=0,Map.GetNumPlots()-1,1 do
				local pPlot = Map.GetPlotByIndex(index);
				local plotOwner = pPlot:GetOwner();
				if (plotOwner == -1 and isLuxury > 0) or isLuxury == 0 then
					if pPlot:GetResourceType() == resourceID then
						local distanceTo = Map.PlotDistance(uPlot:GetX(), uPlot:GetY(), pPlot:GetX(), pPlot:GetY());
						if distanceTo < nearestDistance then
							if not pPlot:IsRevealed(pPlayer:GetTeam(), true) then
								nearestPlot = pPlot;
								nearestDistance = distanceTo;
							end
						end
					end
				end
			end
			if nearestPlot ~= nil then
				nearestPlot:SetRevealed(pPlayer:GetTeam(), true);
				nearestPlot:UpdateFog();
				if Game.GetActivePlayer() == pPlayer:GetID() then
					UI.LookAt(nearestPlot, 0);
				end
				if resourceID < 6 then
					db.SetValue("savedResource" .. resourcesRevealed,nearestPlot:GetX() .. "," .. nearestPlot:GetY());
					db.SetValue("savedResourceType" .. resourcesRevealed,resourceID);
					resourcesRevealed = resourcesRevealed+1;
					db.SetValue("savedResources",resourcesRevealed);
					UpdateResourceOverlay(pPlayer, nearestPlot);
				end
				return true;
			else
				resourceTypesChecked[randResource] = true;
				resourcesChecked = resourcesChecked+1;
			end
		end
		if (resourcesChecked == resourceIndex) then
			print("Didn't find any resources");
			return false;
		end
	end
	return false;
end

function RewardUpgrade(pPlayer, uUnit, uPlot)
	local civID = pPlayer:GetCivilizationType();
	local civType;
	local newUnitClass;
	local newUnitType;
	local newUnit;
	for row in DB.Query("SELECT GoodyHutUpgradeUnitClass FROM Units WHERE ID = " .. uUnit:GetUnitType()) do
		newUnitClass = row.GoodyHutUpgradeUnitClass;
	end
	for row in DB.Query("SELECT Type FROM Civilizations WHERE ID = " .. civID) do
		civType = row.Type;
	end
	for row in DB.Query("SELECT UnitType FROM Civilization_UnitClassOverrides WHERE CivilizationType = '" .. civType .. "' AND UnitClassType = '" .. newUnitClass .. "'") do
		newUnitType = row.UnitType;
	end
	if newUnitType == nil then
		for row in DB.Query("SELECT DefaultUnit FROM UnitClasses WHERE Type = '" .. newUnitClass .. "'") do
			newUnitType = row.DefaultUnit;
		end
	end
	if newUnitType ~= nil then
		newUnit = pPlayer:InitUnit(GameInfoTypes[newUnitType], uPlot:GetX(), uPlot:GetY());
		newUnit:Convert(uUnit);
		return true;
	end
	return false;
end

function RewardBarbarians(pPlayer, uUnit, uPlot, minBarbs, maxBarbs, barbClass)
	local defaultBarbType;
	for row in DB.Query("SELECT UnitType FROM Civilization_UnitClassOverrides WHERE CivilizationType ='CIVILIZATION_BARBARIAN' AND UnitClassType = '" .. barbClass .. "'") do
		defaultBarbType = row.UnitType;
	end
	if defaultBarbType == nil then
		for row in DB.Query("SELECT DefaultUnit FROM UnitClasses WHERE Type ='" .. barbClass .. "'") do
			defaultBarbType = row.DefaultUnit;
		end
	end
	local numBarbs = math.random(minBarbs,maxBarbs);
	local iDistanceToCity = 10000;
	for iDX=-10,10,1 do
		for iDY=-10,10,1 do
			local pTargetPlot = Map.GetPlotXY(uPlot:GetX(), uPlot:GetY(), iDX, iDY);
			if pTargetPlot ~= nil then
				if pTargetPlot:GetOwner() ~= -1 then
					local iNewDistance = Map.PlotDistance(uPlot:GetX(), uPlot:GetY(), pTargetPlot:GetX(), pTargetPlot:GetY());
					if iDistanceToCity > iNewDistance then
						iDistanceToCity = iNewDistance;
					end
				end
			end
		end
	end
	if iDistanceToCity < 5 then
		numBarbs = numBarbs-3;
	elseif iDistanceToCity < 10 then
		numBarbs = numBarbs-2;
	elseif iDistanceToCity < 20 then
		numBarbs = numBarbs-1;
	end
	if numBarbs < minBarbs then
		numBarbs = minBarbs;
	end
	local aRandomUnits = {defaultBarbType};
	local iRandomUnit = 2;
	for row in DB.Query("SELECT Class, Type FROM Units WHERE CombatClass IS NOT NULL AND Domain='DOMAIN_LAND'") do
		if pPlayer:CanTrain(row.Type, false, false, false, true) then
			local barbType;
			local barbDisabled = false;
			for uRow in DB.Query("SELECT UnitType FROM Civilization_UnitClassOverrides WHERE CivilizationType = 'CIVILIZATION_BARBARIAN' AND UnitClassType = '" .. row.Class .. "'") do
				barbType = uRow.UnitType;
				if uRow.UnitType == nil then
					barbDisabled = true;
				else
					barbType = uRow.UnitType;
				end
			end
			if barbType == nil and not barbDisabled then
				for dRow in DB.Query("SELECT DefaultUnit FROM UnitClasses WHERE Type ='" .. row.Class .. "'") do
					barbType = dRow.DefaultUnit;
				end
			end
			if barbType ~= nil then
				local prereqTechName = GameInfo.Units{Class=row.Class}().PrereqTech;
				if prereqTechName ~= nil then
					local prereqTechID = GameInfo.Technologies{Type=prereqTechName}().ID;
					if Teams[pPlayer:GetTeam()]:IsHasTech(prereqTechID) then
						aRandomUnits[iRandomUnit] = barbType;
						iRandomUnit = iRandomUnit+1;
					end
				end
			end
		end
	end
	if aRandomUnits ~= nil then
		for i=1,numBarbs,1 do
			local barbType = aRandomUnits[math.random(1,iRandomUnit-1)];
			local barbUnit = Players[63]:InitUnit(GameInfoTypes[barbType], uPlot:GetX(), uPlot:GetY(), UNITAI_ATTACK);
			if i > 1 then
				barbUnit:JumpToNearestValidPlot();
			end
			barbUnit:SetMoves(0);
		end
		return true;
	end
end

function RewardExperience(pPlayer, uUnit, expRewarded)
	uUnit:ChangeExperience(expRewarded);
end

function RewardHealing(pPlayer, uUnit, damagePrereq, healingAmount)
	local currHP = uUnit:GetCurrHitPoints();
	local maxHP = uUnit:GetMaxHitPoints();
	if maxHP-currHP <= healingAmount then
		uUnit:SetDamage(0);
	else
		uUnit:ChangeDamage(-healingAmount);
	end
	return true;
end

function RewardFood(pPlayer, foodAmount)
	local capCity = pPlayer:GetCapitalCity();
	capCity:ChangeFood(foodAmount);
end

function RewardProduction(pPlayer, productionAmount)
	local capCity = pPlayer:GetCapitalCity();
	local buildingProd = capCity:GetProductionBuilding();
	if buildingProd ~= nil then
		capCity:ChangeProduction(productionAmount);
		return buildingProd;
	else
		return -1;
	end
end

function CanRevealRuins(pPlayer)
	local numRuinsLeft = 0;
	for index=1,ruinsPlotIndex-1,1 do
		local pPlot = Map.GetPlot(ruinsPlots[index][1], ruinsPlots[index][2]);
		if not pPlot:IsRevealed(pPlayer:GetTeam(), true) then
			numRuinsLeft = numRuinsLeft+1;
		end
	end
	return numRuinsLeft;
end

function RewardRevealRuins(pPlayer, revealProb)
	local improvementType = GameInfo.Improvements.IMPROVEMENT_GOODY_HUT.ID;
	local anyFound = false;
	local numRevealed = 0;
	for index=1,ruinsPlotIndex-1,1 do
		local pPlot = Map.GetPlot(ruinsPlots[index][1], ruinsPlots[index][2]);
		if not pPlot:IsRevealed(pPlayer:GetTeam(), true) then
			local randReveal = math.random(1,100);
			if numRevealed == 0 and index == ruinsPlotIndex-1 then
				revealProb = 0;
			end
			if randReveal <= revealProb then
				numRevealed = numRevealed+1;
				pPlot:SetRevealed(pPlayer:GetTeam(), true);
				anyFound = true;
			end
		end
	end
	return anyFound;
end

-- Returns a random reward ID from the reward tracker
function GetRewardType(playerID)
	local availableRewards = {};
	local numAvailable = 0;
	local rewardAvailable = false;
	for i=0,rewardCount-1,1 do
		local rewardID = rewardIDs[i];
		if rewardTracker[playerID][rewardID] == 0 then
			rewardAvailable = true;
			availableRewards[numAvailable] = rewardID;
			numAvailable = numAvailable+1;
		elseif rewardTracker[playerID][rewardID] == 2 then
			availableRewards[numAvailable] = rewardID;
			numAvailable = numAvailable+1;
		end
	end
	if rewardAvailable == false then
		for i=0,rewardCount-1,1 do
			local rewardID = rewardIDs[i];
			if rewardTracker[playerID][rewardID] == 1 then
				rewardTracker[playerID][rewardID] = 0;
				availableRewards[numAvailable] = rewardID;
				numAvailable = numAvailable+1;
				db.SetValue("savedReward" .. playerID .. "," .. rewardID, 0);
			end
		end
	end
	local rewardGiven = false;
	while not rewardGiven do
		local rewardIndex = availableRewards[math.random(numAvailable)-1];
		print("GetRewardType playerID " .. playerID .. " rewardIndex " .. rewardIndex);
		if rewardTracker[playerID][rewardIndex] == 0 or rewardTracker[playerID][rewardIndex] == 2 then
			rewardTracker[playerID][rewardIndex] = 1;
			db.SetValue("savedReward" .. playerID .. "," .. rewardIndex, 1);
			return rewardIndex;
		end
	end
end

-- Overlay functions used by RewardRevealResource
function GetPlotIndex(plot)
	return plot:GetY() * width + plot:GetX();
end

function UpdateResourceOverlay(pPlayer, pPlot)
	if pPlayer:GetID() == Game.GetActivePlayer() then
		local index = GetPlotIndex(pPlot);
		local resourceType = pPlot:GetResourceType();
		local instance = resourceInstances[index] or resourceManager:GetInstance();
		local resourceInfo = GameInfo.Resources[resourceType];
		resourceInstances[index] = instance;

		IconHookup(resourceInfo.PortraitIndex, 64, resourceInfo.IconAtlas, instance.ARResourceIcon);

		local strToolTip = BuildResourceToolTip(pPlot);
		instance.ARResourceIcon:SetToolTipString(strToolTip or "");
		local wx, wy, wz = GridToWorld(pPlot:GetX(), pPlot:GetY());
		instance.Anchor:SetWorldPositionVal(wx-30,wy+15,wz);
	end
end

function BuildResourceToolTip(plot)
	-- Resource
    local iResourceID = plot:GetResourceType();
    local pResourceInfo = GameInfo.Resources[iResourceID];
    if (pResourceInfo == nil) then
		return nil;
	end
    -- Quantity
    local strQuantity = "";
    if (plot:GetNumResource() > 1) then
		strQuantity = plot:GetNumResource() .. " ";
    end
    -- Name
    local strToolTip = "[COLOR_POSITIVE_TEXT]" .. strQuantity .. Locale.ToUpper(Locale.ConvertTextKey(pResourceInfo.Description)) .. "[ENDCOLOR]";
	-- Extra Help Text (e.g. for strategic resources)
	if (pResourceInfo.Help) then
		-- Basic tooltips get extra info
		if (not OptionsManager.IsNoBasicHelp()) then
			strToolTip = strToolTip .. "[NEWLINE]";
			strToolTip = strToolTip .. "[ICON_BULLET]" .. Locale.ConvertTextKey(pResourceInfo.Help);
			strToolTip = strToolTip .. "[NEWLINE]---------------------";
		end
	end
	-- Happiness
	if (pResourceInfo.Happiness) then
		if (pResourceInfo.Happiness ~= 0) then
			local strHappinessToolTip = "";
			-- Basic tooltips get extra info
			if (not OptionsManager.IsNoBasicHelp()) then
				strHappinessToolTip = Locale.ConvertTextKey("TXT_KEY_RESOURCE_TOOLTIP_IMPROVED");
				strHappinessToolTip = strHappinessToolTip .. "[NEWLINE]";
			end
			strHappinessToolTip = strHappinessToolTip .. "[ICON_BULLET]+" .. pResourceInfo.Happiness .. " [ICON_HAPPINESS_1]";
			-- Basic tooltips get extra info
			if (not OptionsManager.IsNoBasicHelp()) then
				strHappinessToolTip = strHappinessToolTip .. " " .. Locale.ConvertTextKey("TXT_KEY_GAME_CONCEPT_SECTION_10");	-- This is the text key for Happiness... don't ask
			end
			strToolTip = strToolTip .. "[NEWLINE]";
			strToolTip = strToolTip .. strHappinessToolTip;
		end
	end
	-- Yield
	local strYieldToolTip = "";
	local condition = "ResourceType = '" .. pResourceInfo.Type .. "'";
	local pYieldInfo;
	local bFirst = true;
	for row in GameInfo.Resource_YieldChanges( condition ) do
		pYieldInfo = GameInfo.Yields[row.YieldType];
		-- Add bullet in front of first entry, space in front of all others
		if (bFirst) then
			bFirst = false;
			strYieldToolTip = strYieldToolTip .. "[ICON_BULLET]";
		else
			strYieldToolTip = strYieldToolTip .. " ";
		end
		if row.Yield > 0 then
			strYieldToolTip = strYieldToolTip.."+";
		end
		strYieldToolTip = strYieldToolTip .. tostring(row.Yield) .. pYieldInfo.IconString;
		-- Basic tooltips get extra info
		if (not OptionsManager.IsNoBasicHelp()) then
			strYieldToolTip = strYieldToolTip .. " " .. Locale.ConvertTextKey(pYieldInfo.Description);
		end
	end
	-- Something in the yield tooltip?
	if (strYieldToolTip ~= "") then
		-- Basic tooltips get extra info
		if (not OptionsManager.IsNoBasicHelp()) then
			strYieldToolTip = Locale.ConvertTextKey("TXT_KEY_RESOURCE_TOOLTIP_IMPROVED_WORKED") .. "[NEWLINE]" .. strYieldToolTip;
		end
		strToolTip = strToolTip .. "[NEWLINE]";
		strToolTip = strToolTip .. strYieldToolTip;
	end
	return strToolTip;
end
