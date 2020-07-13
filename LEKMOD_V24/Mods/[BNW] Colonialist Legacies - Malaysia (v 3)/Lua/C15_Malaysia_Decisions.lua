-- C15_Malaysia_Decisions
-- Author: Chrisy15
-- DateCreated: 4/9/2016 9:50:38 AM
--------------------------------------------------------------

--Malay Decisions support
--Author  :           Mewr11
--Created : 22 December 2015

print('loading Malay decisions!')
local sMalaysiaName = GameInfoTypes["CIVILIZATION_CL_MALAYSIA"]
 
--========================================================================================================
--Call upon the services of the Laksamana
--      COSTS:
--      X Culture
--      2 Magistrates
--      REQS:
--      Naval unit in capital(Coastal Capital)
--      2 International Trade Routes
--      GIVES:
--      Naval unit in capital becomes Great Admiral
--      +15 XP on all newly constructed Naval units
--======================================== ================================================================
 
local iLaksamanaCultureCost = 500
local iLaksamanaTradeRouteReq = 2
local iLaksamanaMagistrateReq = 2
local iLaksamanaXPBoost = 15
local bLaksamanaOnlyOnce = true
local isNaval = false
 
local Decisions_CL_MALAYSIA_Laksamana = {}
	print('Decisions_CL_MALAYSIA_Laksamana loaded')
    Decisions_CL_MALAYSIA_Laksamana.Name = "TXT_KEY_DECISIONS_CL_MALAYSIA_LAKSAMANA_NAME"
    Decisions_CL_MALAYSIA_Laksamana.Desc = "TXT_KEY_DECISIONS_CL_MALAYSIA_LAKSAMANA_DESC"
	HookDecisionCivilizationIcon(Decisions_CL_MALAYSIA_Laksamana, "CIVILIZATION_CL_MALAYSIA")
    Decisions_CL_MALAYSIA_Laksamana.CanFunc = (
        function(pPlayer)
            if(pPlayer:GetCivilizationType() ~= sMalaysiaName) then return false, false end
          --[[  if(load(pPlayer, "Decisions_CL_MALAYSIA_Laksamana") == true and bLaksamanaOnlyOnce == true) then
                Decisions_CL_MALAYSIA_Laksamana.Desc = Locale.ConvertTextKey("TXT_KEY_DECISIONS_CL_MALAYSIA_LAKSAMANA_ENACTED_DESC")
                return false, false, true
            end]]
			if load(pPlayer, "Decisions_CL_MALAYSIA_Laksamana") == true then
				Decisions_CL_MALAYSIA_Laksamana.Desc = Locale.ConvertTextKey("TXT_KEY_DECISIONS_CL_MALAYSIA_LAKSAMANA_ENACTED_DESC")
				return false, false, true
			end
			
           
            local iCultureCost = math.ceil(iLaksamanaCultureCost * iMod)
            Decisions_CL_MALAYSIA_Laksamana.Desc = Locale.ConvertTextKey("TXT_KEY_DECISIONS_CL_MALAYSIA_LAKSAMANA_DESC", iCultureCost, iLaksamanaMagistrateReq, iLaksamanaTradeRouteReq, iLaksamanaXPBoost)
           
            local pCapital = pPlayer:GetCapitalCity()
			local iX = pCapital:GetX()
			local iY = pCapital:GetY()
			--local pPlot = pCapital:Plot()
			local pPlot = Map.GetPlot(iX, iY)
			local playerID = pPlayer:GetID()
			local tPlayerTradeRoutes = pPlayer:GetTradeRoutes()
			local iCount = 0
			--local isNaval = false
           
            if not pCapital:IsCoastal(1) then return true, false end
           -- if(pPlayer:GetNumInternationalTradeRoutesUsed() < iLaksamanaTradeRouteReq) then return true, false end
			if #tPlayerTradeRoutes > 0 then
				for i = 1, #tPlayerTradeRoutes do
					if (tPlayerTradeRoutes[i]["FromID"] == playerID) and not (tPlayerTradeRoutes[i]["ToID"] == playerID) then
						iCount = iCount + 1
						print("Num of trade routes:", iCount)
					end
				end
			end
			if iCount < iLaksamanaTradeRouteReq then return true, false end
            if(pPlayer:GetNumResourceAvailable(iMagistrate, false) < iLaksamanaMagistrateReq) then return true, false end
            if(pPlayer:GetJONSCulture() < iCultureCost) then return true, false end
			--Check to see that the cached unit hasn't moved on
			--[[local target = pPlayer:GetUnitByID(load(pPlayer, "Decisions_CL_MALAYSIA_LaksamanaTarget"))
			if target ~= nil then
				for i = 0, pPlot:GetNumUnits() - 1, 1 do
					local unit = pPlot:GetUnit(i)
					if unit ~= nil then
						if unit == target then
						return true, true
					end
				end
			end
			save(pPlayer, "Decisions_CL_MALAYSIA_LaksamanaTarget", nil)
			--Cache a naval unit.
			for i = 0, pPlot:GetNumUnits() - 1, 1 do
				local unit = pPlot:GetUnit(i)
                if unit ~= nil then
					if unit:GetDomainType() == DomainTypes.DOMAIN_SEA then
						save(pPlayer, "Decisions_CL_MALAYSIA_LaksamanaTarget", unit:GetID())
					    return true, true
					end
				end
			end]]
			if pPlot:GetNumUnits() == 0 then 
				print("No units")
				return true, false 
			end
			if pPlot:GetNumUnits() > 0 then
				print("Number of units == ", pPlot:GetNumUnits())
				--for pUnit in pPlot:GetNumUnits() do
				for i = 0, pPlot:GetNumUnits() do
					local pUnit = pPlot:GetUnit(i)
					print("pUnit == ", pUnit)
					if pUnit then
						print("pUnit is still ", pUnit)
						if (pUnit:GetDomainType() == DomainTypes.DOMAIN_SEA) and pUnit:IsCombatUnit() then
							isNaval = true
							print("isNaval ==" , isNaval)
							break
						else
							isNaval = false
						end
					end
				end
			end
			
			if not isNaval then return true, false end			
				
			return true, true
        end
    )
	
    Decisions_CL_MALAYSIA_Laksamana.DoFunc = (
        function(pPlayer)
            local iCultureCost = math.ceil(iLaksamanaCultureCost * iMod)
            pPlayer:ChangeNumResourceTotal(iMagistrate, -iLaksamanaMagistrateReq)
            pPlayer:ChangeJONSCulture(-iCultureCost)
			pCapital = pPlayer:GetCapitalCity()
			local pNewUnit = pPlayer:InitUnit(GameInfoTypes.UNIT_GREAT_ADMIRAL, pCapital:GetX(), pCapital:GetY())
            --local pUnit = pPlayer:GetUnitByID(load(pPlayer, "Decisions_CL_MALAYSIA_LaksamanaTarget"))
			--for pUnit in pPlot:GetNumUnits() do
			local pPlot = Map.GetPlot(pCapital:GetX(), pCapital:GetY())
			for i = 0, pPlot:GetNumUnits() do
				local pUnit = pPlot:GetUnit(i)
				if (pUnit:GetDomainType() == DomainTypes.DOMAIN_SEA) and (pUnit:IsCombatUnit()) then
					pUnit:SetName("Hang Tuah")
					pNewUnit:Convert(pUnit)
					--pUnit:SetName("Hang Tuah")
					--pUnit:Kill()
					--pPlayer:InitUnit(GameInfoTypes.UNIT_GREAT_ADMIRAL, pCapital:GetX(), pCapital:GetY())
					break
				end
			end
            save(pPlayer, "Decisions_CL_MALAYSIA_Laksamana", true)
			--save(pPlayer, "Decisions_CL_MALAYSIA_LaksamanaTarget", nil)
        end
    )
 
function Moderate_Laksamana(iPlayer, iCity, iUnit, bBought, bFaith)
    local pPlayer = Players[iPlayer]
    if(pPlayer:GetCivilizationType() == sMalaysiaName) then
        if(load(pPlayer, "Decisions_CL_MALAYSIA_Laksamana") == true) then
            local pUnit = pPlayer:GetUnitByID(iUnit)
            if(pUnit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
                pUnit:ChangeExperience(iLaksamanaXPBoost)
            end
        end
    end
end
GameEvents.CityTrained.Add(Moderate_Laksamana)
 
Decisions_AddCivilisationSpecific(GameInfoTypes["CIVILIZATION_CL_MALAYSIA"], "Decisions_CL_MALAYSIA_Laksamana", Decisions_CL_MALAYSIA_Laksamana)
       
 
--Malay Decisions support
--Author  :           Neirai
--Created : 25 December 2015 Merry Christmas!
 
--========================================================================================================
--Celebrate the Kongsi Raya
--      COSTS:
--      1/2 a policy of Culture
--      REQS:
--      >2 full trees of policies
--      Can be enacted once per era
--      GIVES:
--      A WTLKD in the capital and a golden age
--      Length of Kongsi Raya depends on number of policies
--========================================================================================================
 
local Decisions_CL_MALAYSIA_Kongsi = {}
print('Decisions_CL_MALAYSIA_Kongsi loaded')
    Decisions_CL_MALAYSIA_Kongsi.Name = "TXT_KEY_DECISIONS_CL_MALAYSIA_KONGSI_NAME"
    Decisions_CL_MALAYSIA_Kongsi.Desc = "TXT_KEY_DECISIONS_CL_MALAYSIA_KONGSI_DESC"
	HookDecisionCivilizationIcon(Decisions_CL_MALAYSIA_Kongsi, "CIVILIZATION_CL_MALAYSIA")
    Decisions_CL_MALAYSIA_Kongsi.CanFunc = (
        function(pPlayer)
            if(pPlayer:GetCivilizationType() ~= GameInfoTypes.CIVILIZATION_CL_MALAYSIA) then return false, false end
            if load(pPlayer, "Decisions_CL_MALAYSIA_Kongsi") == true then
                Decisions_CL_MALAYSIA_Kongsi.Desc = Locale.ConvertTextKey("TXT_KEY_DECISIONS_CL_MALAYSIA_KONGSI_ENACTED_DESC")
                return false, false, true
            end
           
            local iCultureCost = math.ceil(pPlayer:GetNextPolicyCost() / 2)
            local iLength = (pPlayer:GetNumPolicyBranchesFinished() * 5)
            Decisions_CL_MALAYSIA_Kongsi.Desc = Locale.ConvertTextKey("TXT_KEY_DECISIONS_CL_MALAYSIA_KONGSI_DESC", iCultureCost, iLength)
           
            local pCapital = pPlayer:GetCapitalCity()
            if pCapital == nil then return true, false end
            if (pPlayer:GetJONSCulture() < iCultureCost) then return true, false end
            if pPlayer:GetNumPolicyBranchesFinished() < 2 then return true, false end
            return true, true
        end
    )
    Decisions_CL_MALAYSIA_Kongsi.DoFunc = (
        function(pPlayer)
            local iCultureCost = math.ceil(pPlayer:GetNextPolicyCost() / 2)
            local iLength = (pPlayer:GetNumPolicyBranchesFinished() * 5)
            pPlayer:ChangeJONSCulture(-iCultureCost)
            local pCapital = pPlayer:GetCapitalCity()
            pPlayer:ChangeGoldenAgeTurns(iLength)
            if pCapital:GetWeLoveTheKingDayCounter() > 0 then
                pCapital:ChangeWeLoveTheKingDayCounter(iLength)
            else
                pCapital:SetWeLoveTheKingDayCounter(iLength)
            end
            save(pPlayer, "Decisions_CL_MALAYSIA_Kongsi", true)
        end
    )
 
function resetKongsi(iTeam)
    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1, 1 do
        local pPlayer = Players[iPlayer]
        if pPlayer:IsEverAlive() then
            if pPlayer:GetTeam() == iTeam then
                if(pPlayer:GetCivilizationType() == sMalaysiaName) then
                    if(load(pPlayer, "Decisions_CL_MALAYSIA_Kongsi") == true) then
                        save(pPlayer, "Decisions_CL_MALAYSIA_Kongsi", false)
                    end
                end
            end
        end
    end
end
GameEvents.TeamSetEra.Add(resetKongsi)

Decisions_AddCivilisationSpecific(GameInfoTypes["CIVILIZATION_CL_MALAYSIA"], "Decisions_CL_MALAYSIA_Kongsi", Decisions_CL_MALAYSIA_Kongsi)