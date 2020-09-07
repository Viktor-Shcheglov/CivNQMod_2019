-- C15_Malaysia_TopPanelSupport
-- Author: Chrisy15
-- DateCreated: 4/30/2016 3:39:55 PM
--------------------------------------------------------------

function C15_DTP_BonusFoodCulture(playerID)
	local pPlayer = Players[playerID]
	local malaysiaMCISDummy = GameInfoTypes["BUILDING_C15_MALAY_MCIS_DUMMY"]
	local count = 0
	for pCity in pPlayer:Cities() do
		local food = pCity:FoodDifference() + pCity:GetNumRealBuilding(malaysiaMCISDummy)
		if food > 0 then
			count = count + (food / 2)
		end
	end
	return count
end

