-- CL_Malaysia_Functions
-- Author: JFD, Chrisy15 and Neirai
-- DateCreated: 11/20/2015 9:21:01 AM
--==========================================================================================================================
-- INCLUDES
--==========================================================================================================================
include("IconSupport")
include("PlotIterators.lua")
include("C15_Malaysia_TopPanelSupport.lua")
--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
-- MOD CHECKS
--------------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------------
-- UTILS
--------------------------------------------------------------------------------------------------------------------------
-- JFD_GetKampungNavalBonus
local featureAtollID = GameInfoTypes["FEATURE_ATOLL"]
local improvementKampungID = GameInfoTypes["IMPROVEMENT_CL_KAMPUNG"]
function JFD_GetKampungNavalBonus(playerID, city)
    local cityPlot = city:Plot()
    local navalBonus = 0
    for adjacentPlot in PlotAreaSweepIterator(cityPlot, 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
        if adjacentPlot:GetImprovementType() == improvementKampungID then
            for kampungAdjacentPlot in PlotAreaSweepIterator(adjacentPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
                if (kampungAdjacentPlot:IsWater() and kampungAdjacentPlot:IsBeingWorked() and (kampungAdjacentPlot:GetResourceType() > -1 or kampungAdjacentPlot:GetFeatureType() == featureAtollID)) then
                    navalBonus = navalBonus + 1
                end
            end
        end
    end
    return navalBonus
end

function C15_NavalOnResource(playerID, pCity)
	local pPlayer = Players[playerID]
	local malaysiaMCISDummy = GameInfoTypes["BUILDING_C15_MALAY_MCIS_DUMMY"]
	local featureAtollID = GameInfoTypes["FEATURE_ATOLL"]
	local count = 0
	for pCityPlot = 0, pCity:GetNumCityPlots() - 1, 1 do
		local pSpecificPlot = pCity:GetCityIndexPlot(pCityPlot)
		if pCity:IsWorkingPlot(pSpecificPlot) then
			for i = 0, pSpecificPlot:GetNumUnits() - 1, 1 do
				local pUnit = pSpecificPlot:GetUnit(i)
				if pUnit then
					if pUnit:GetOwner() == playerID and pUnit:GetDomainType() == DomainTypes.DOMAIN_SEA then
						if pSpecificPlot:IsWater() and (pSpecificPlot:GetResourceType(-1) ~= -1 or pSpecificPlot:GetFeatureType() == featureAtollID) then
							count = count + 1
						end
					end
				end
			end
		end
	end
	return count
end

--==========================================================================================================================
-- UNIQUE FUNCTIONS
--==========================================================================================================================
-- GLOBALS
----------------------------------------------------------------------------------------------------------------------------
local activePlayerID        = Game.GetActivePlayer()
local activePlayer          = Players[activePlayerID]
local activePlayerTeam      = Teams[Game.GetActiveTeam()]
local civilizationID        = GameInfoTypes["CIVILIZATION_CL_MALAYSIA"]
local isMalaysiaCivActive   = JFD_IsCivilisationActive(civilizationID)
local isMalaysiaActivePlayer = activePlayer:GetCivilizationType() == civilizationID
local mathCeil              = math.ceil
local mathFloor             = math.floor
local malaysiaMCISDummy = GameInfoTypes["BUILDING_C15_MALAY_MCIS_DUMMY"]
if isMalaysiaCivActive then
    print("Sultan Parameswara is in this game")
end
----------------------------------------------------------------------------------------------------------------------------
-- PESILAT
----------------------------------------------------------------------------------------------------------------------------
-- JFD_Malaysia_BlockPesilat
local unitPesilatID = GameInfoTypes["UNIT_CL_PESILAT"]
function JFD_Malaysia_BlockPesilat(playerID, unitID)
    local player = Players[playerID]
    if player:IsHuman() and not player:HasPolicy(GameInfoTypes.POLICY_TRADE_UNIONS) then
        if unitID == unitPesilatID then
            return false
        end
    end
    return true
end
GameEvents.PlayerCanTrain.Add(JFD_Malaysia_BlockPesilat)

function C15_Malaysia_WorkerUpgrade(playerID)
	local pPlayer = Players[playerID]
	local workerID = GameInfoTypes["UNIT_WORKER"]
	local malayWorkerID = GameInfoTypes["UNIT_CL_MALAYSIA_WORKER"]
	local unitPesilat = GameInfo.Units[unitPesilatID]
	local unitPesilatePrereqTech = unitPesilat.PrereqTech
	local unitPesilatePrereqTechID = GameInfoTypes[unitPesilatePrereqTech]
	if pPlayer:GetCivilizationType() == civilizationID and Teams[pPlayer:GetTeam()]:IsHasTech(unitPesilatePrereqTechID) then
		for pUnit in pPlayer:Units() do
			if pUnit:GetUnitType() == workerID then
				local uPlot = pUnit:GetPlot()
				for SpecificPlot in PlotAreaSpiralIterator(uPlot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
					if SpecificPlot ~= nil then
						if SpecificPlot:GetNumUnits() > 0 then
							for i = 0, SpecificPlot:GetNumUnits() - 1 do
								local forUnit = SpecificPlot:GetUnit(i)
								if forUnit:GetOwner() ~= playerID then
									local ourTeam = Teams[pPlayer:GetTeam()]
									local forPlayer = Players[forUnit:GetOwner()]
									if ourTeam:IsAtWar(forPlayer:GetTeam()) then
										local iX = pUnit:GetX()
										local iY = pUnit:GetY()
										pUnit:Kill()
										pPlayer:InitUnit(malayWorkerID, iX, iY)
									end
								end
							end
						end
					end
				end
			elseif pUnit:GetUnitType() == malayWorkerID then
				local uPlot = pUnit:GetPlot()
				local isNearEnemy = false
				for SpecificPlot in PlotAreaSpiralIterator(uPlot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
					if SpecificPlot ~= nil then
						if SpecificPlot:GetNumUnits() > 0 then
							for i = 0, SpecificPlot:GetNumUnits() - 1 do
								local forUnit = SpecificPlot:GetUnit(i)
								if forUnit:GetOwner() ~= playerID then
									local ourTeam = Teams[pPlayer:GetTeam()]
									local forPlayer = Players[forUnit:GetOwner()]
									if ourTeam:IsAtWar(forPlayer:GetTeam()) then
										isNearEnemy = true
									end
								end
							end
						end
					end
				end
				if isNearEnemy == false then
					--local iX = pUnit:GetX()
					--local iY = pUnit:GetY()
					local iX = uPlot:GetX()
					local iY = uPlot:GetY()
					pUnit:Kill()
					pPlayer:InitUnit(workerID, iX, iY)
				end
			end
		end
	end
end

if isMalaysiaCivActive then
	GameEvents.PlayerDoTurn.Add(C15_Malaysia_WorkerUpgrade)
	print("Worker Upgrade added!")
end
 
local isCityViewOpen = false
 
local unitPesilat = GameInfo.Units[unitPesilatID]
local unitPesilatePrereqTech = unitPesilat.PrereqTech
local unitPesilatePrereqTechID = GameInfoTypes[unitPesilatePrereqTech]
-- JFD_Malaysia_Pesilat
function JFD_Malaysia_Pesilat()
    Controls.UnitBackground:SetHide(true)
    Controls.UnitImage:SetHide(true)
    Controls.UnitButton:SetDisabled(true)
    Controls.UnitButton:LocalizeAndSetToolTip(nil)
    if (not activePlayerTeam:IsHasTech(unitPesilatePrereqTechID)) then return end
    local city = UI.GetHeadSelectedCity()
    if city and city:GetOwner() == activePlayerID then
        local isDisabled = true
        local cultureCost = (city:GetUnitPurchaseCost(unitPesilatID)*0.5)
        local buttonText = Locale.ConvertTextKey("TXT_KEY_JFD_RECRUIT_PESILAT", cultureCost)
        local buttonToolTip = Locale.ConvertTextKey("TXT_KEY_JFD_RECRUIT_PESILAT_TT", cultureCost)
        if activePlayer:GetJONSCulture() < cultureCost then
            buttonText = Locale.ConvertTextKey("TXT_KEY_JFD_RECRUIT_PESILAT_DISABLED", cultureCost)
            buttonToolTip = Locale.ConvertTextKey("TXT_KEY_JFD_RECRUIT_PESILAT_TT_DISABLED", cultureCost)
        else
            isDisabled = false
        end
        IconHookup(unitPesilat.PortraitIndex, 64, unitPesilat.IconAtlas, Controls.UnitImage)
        Controls.UnitBackground:SetHide(false)
        Controls.UnitImage:SetHide(false)
        Controls.UnitButton:SetText(buttonText)
        Controls.UnitButton:SetToolTipString(buttonToolTip)
        Controls.UnitButton:SetDisabled(isDisabled)
    end
end
 
-- JFD_Malaysia_PesilatRecruit
function JFD_Malaysia_PesilatRecruit()
    Controls.UnitConfirm:SetHide(false)
end
Controls.UnitButton:RegisterCallback(Mouse.eLClick, JFD_Malaysia_PesilatRecruit)   
   
-- JFD_Malaysia_PesilatOnYes
function JFD_Malaysia_PesilatOnYes()
    Controls.UnitConfirm:SetHide(true)
	local city = UI.GetHeadSelectedCity(); --Creds to JFD for the fix
    if city then
        local cultureCost = (city:GetUnitPurchaseCost(unitPesilatID)*0.5)
        activePlayer:InitUnit(unitPesilatID, city:GetX(), city:GetY())
        activePlayer:ChangeJONSCulture(-cultureCost)
    end
    JFD_Malaysia_Pesilat()
    Events.AudioPlay2DSound("AS2D_INTERFACE_POLICY")
end
Controls.Yes:RegisterCallback(Mouse.eLClick, JFD_Malaysia_PesilatOnYes)
 
-- JFD_Malaysia_PesilatOnNo
function JFD_Malaysia_PesilatOnNo()
    Controls.UnitConfirm:SetHide(true)
end
Controls.No:RegisterCallback(Mouse.eLClick, JFD_Malaysia_PesilatOnNo)
 
-- JFD_Malaysia_PesilatOnEnterCityScreen
function JFD_Malaysia_PesilatOnEnterCityScreen()
    isCityViewOpen = true
    JFD_Malaysia_Pesilat()
end
 
-- JFD_Malaysia_PesilatOnExitCityScreen
function JFD_Malaysia_PesilatOnExitCityScreen()
    isCityViewOpen = false
    JFD_Malaysia_Pesilat()
end
 
-- JFD_Malaysia_PesilatOnNextCityScren
function JFD_Malaysia_PesilatOnNextCityScren()
    if isCityViewOpen then
        JFD_Malaysia_Pesilat()
    end
end
if (isMalaysiaCivActive and isMalaysiaActivePlayer) then
    Events.SerialEventEnterCityScreen.Add(JFD_Malaysia_PesilatOnEnterCityScreen)
    Events.SerialEventExitCityScreen.Add(JFD_Malaysia_PesilatOnExitCityScreen)
    Events.SerialEventCityScreenDirty.Add(JFD_Malaysia_PesilatOnNextCityScren)
end
----------------------------------------------------------------------------------------------------------------------------
-- KAMPUNG
----------------------------------------------------------------------------------------------------------------------------
-- JFD_Malaysia_Kampung
local buildingKampungID = GameInfoTypes["BUILDING_CL_KAMPUNG"]
function JFD_Malaysia_Kampung(playerID)
    local player = Players[playerID]
    if (player:IsAlive() and player:GetCivilizationType() == civilizationID) then
        for city in player:Cities() do
            city:SetNumRealBuilding(buildingKampungID, JFD_GetKampungNavalBonus(playerID, city))
        end
    end
end
if isMalaysiaCivActive then
    GameEvents.PlayerDoTurn.Add(JFD_Malaysia_Kampung)
	print("Malaysia Kampung Naval Production added!")
end
--==========================================================================================================================
--==========================================================================================================================
--A Unique Improvement of Bajau-Laut origin unique to Malaysia. The Kampung can only be built by embarked workers on Coastal ocean tiles adjacent to Sea Resources and Atolls, but not adjacent to each other. The improvement itself yields +1 Culture (and another +1 Culture at Compass), and adjacent Sea Resources provide +5% Naval Unit Production when worked. Comes at Optics.
--
--Malaysia's unique replacement for the Landschneckt. Unlike the Landschneckt it replaces however, the Pesilat does not require the Mercenary Army social policy and instead of Gold, requires Culture to purchase. Comes at Civil Service.

----------------------------------------------------------------------------------------------------------------------------
-- UA
----------------------------------------------------------------------------------------------------------------------------

function C15_Malaysia_Food_CityView()
    local pCity = UI.GetHeadSelectedCity()
	local playerID = pCity:GetOwner()
	if pCity and pCity:GetOwner() == activePlayerID then
		pCity:SetNumRealBuilding(malaysiaMCISDummy, C15_NavalOnResource(playerID, pCity))
	end
end

if isMalaysiaCivActive and isMalaysiaActivePlayer then
	Events.SerialEventEnterCityScreen.Add(C15_Malaysia_Food_CityView)
end

function NavalFoodProtectionism(playerID)
	local pPlayer = Players[playerID]
	if pPlayer:IsAlive() and pPlayer:GetCivilizationType() == civilizationID then
		for pCity in pPlayer:Cities() do
			pCity:SetNumRealBuilding(malaysiaMCISDummy, C15_NavalOnResource(playerID, pCity))
			if pCity:GetNumRealBuilding(malaysiaMCISDummy) > 0 then
				pCity:ChangeFood(pCity:GetNumRealBuilding(malaysiaMCISDummy))
			end
		end
	end
end

if isMalaysiaCivActive then
	GameEvents.PlayerDoTurn.Add(NavalFoodProtectionism)
	print("Naval Food Protectionism added!")
end

--[[function BonusFoodCulture(playerID) -- Prints one global message, rather than an unreadable message for each city
	local pPlayer = Players[playerID]
	if (pPlayer:IsAlive() and pPlayer:GetCivilizationType() == civilizationID) then
		local count = 0
		for pCity in pPlayer:Cities() do
			local food = pCity:FoodDifference() + pCity:GetNumRealBuilding(malaysiaMCISDummy)
			if food > 0 then
				count = count + (food / 2)
			end
		end
		if count > 0 then
			pPlayer:ChangeJONSCulture(count)
		end
		if pPlayer:IsHuman() then
			Events.GameplayAlertMessage('Extra food resulted in ' .. count .. ' [ICON_CULTURE] Culture')
		end
	end
end]]

function BonusFoodCulture(playerID)
	local pPlayer = Players[playerID]
	if pPlayer:IsAlive() and pPlayer:GetCivilizationType() == civilizationID then
		local count = C15_DTP_BonusFoodCulture(playerID)
		if count > 0 then
			pPlayer:ChangeJONSCulture(count)
			if pPlayer:IsHuman() then
				local sAlertMessage = Locale.ConvertTextKey("TXT_KEY_C15_MALAYSIA_CULTURE_FOOD_MESSAGE", count)
				Events.GameplayAlertMessage(sAlertMessage)
			end
		end
	end
end

if isMalaysiaCivActive then
	GameEvents.PlayerDoTurn.Add(BonusFoodCulture)
	print("Food Bonus Culture added!")
end