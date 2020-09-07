------------------------------------------------------------------------------
--	FILE:	 Modified Pangaea_Plus.lua
--	AUTHOR:  Original Bob Thomas, Changes HellBlazer
--	PURPOSE: Global map script - Simulates a Pan-Earth Supercontinent, with
--           numerous tectonic island chains.
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include("HBMapGenerator");
include("HBFractalWorld");
include("HBFeatureGenerator");
include("HBTerrainGenerator");
include("IslandMaker");
include("MultilayeredFractal");

------------------------------------------------------------------------------
function GetMapScriptInfo()
	local world_age, temperature, rainfall, sea_level, resources = GetCoreMapOptions()
	return {
		Name = "Lekmap v1.4",
		Description = "A map script made for Lekmod based of HB's Mapscript v8.1 containing different map types selectable from the map set up screen.",
		IsAdvancedMap = false,
		IconIndex = 0,
		SortIndex = 2,
		SupportsMultiplayer = true,
	CustomOptions = {
			{
				Name = "TXT_KEY_MAP_OPTION_WORLD_AGE", -- 1
				Values = {
					"TXT_KEY_MAP_OPTION_THREE_BILLION_YEARS",
					"TXT_KEY_MAP_OPTION_FOUR_BILLION_YEARS",
					"TXT_KEY_MAP_OPTION_FIVE_BILLION_YEARS",
					"No Mountains",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 2,
				SortPriority = -99,
			},
		{
				Name = "TXT_KEY_MAP_OPTION_TEMPERATURE",	-- 2 add temperature defaults to random
				Values = {
					"TXT_KEY_MAP_OPTION_COOL",
					"TXT_KEY_MAP_OPTION_TEMPERATE",
					"TXT_KEY_MAP_OPTION_HOT",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 2,
				SortPriority = -96,
			},
		{
				Name = "TXT_KEY_MAP_OPTION_RAINFALL",	-- 3 add rainfall defaults to random
				Values = {
					"TXT_KEY_MAP_OPTION_ARID",
					"TXT_KEY_MAP_OPTION_NORMAL",
					"TXT_KEY_MAP_OPTION_WET",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 2,
				SortPriority = -97,
			},
		{
				Name = "TXT_KEY_MAP_OPTION_SEA_LEVEL",	-- 4 add sea level defaults to random.
				Values = {
					"Very Low",
					"TXT_KEY_MAP_OPTION_LOW",
					"TXT_KEY_MAP_OPTION_MEDIUM",
					"TXT_KEY_MAP_OPTION_HIGH",
					"Very High",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 3,
				SortPriority = -93,
			},
		{
				Name = "Start Locations",	-- 5 add resources defaults to random
				Values = {
					"Legendary Start - Strat Balance",
					"Legendary - Strat Balance + Uranium",
					"TXT_KEY_MAP_OPTION_STRATEGIC_BALANCE",
					"Strategic Balance With Coal",
					"Strategic Balance With Aluminum",
					"Strategic Balance With Coal & Aluminum",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 2,
				SortPriority = -90,
			},

			{
				Name = "Natural Wonders", -- 6 number of natural wonders to spawn
				Values = {
					"0",
					"1",
					"2",
					"3",
					"4",
					"5",
					"6",
					"7",
					"8",
					"9",
					"10",
					"11",
					"12",
					"Random",
					"Default",
				},
				DefaultValue = 15,
				SortPriority = -88,
			},

			{
				Name = "Grass Moisture",	-- add setting for grassland mositure (7)
				Values = {
					"Wet",
					"Normal",
					"Dry",
				},

				DefaultValue = 2,
				SortPriority = -98,
			},

			{
				Name = "Rivers",	-- add setting for rivers (8)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 2,
				SortPriority = -95,
			},

			{
				Name = "Lakes",	-- add setting for Lakes (9)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 1,
				SortPriority = -94,
			},

			{
				Name = "Tundra",	-- add setting for tundra (10)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 1,
				SortPriority = -92,
			},

			{
				Name = "Islands",	-- add setting for islands (11)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
					"Abundant",
				},

				DefaultValue = 2,
				SortPriority = -89,
			},

			{
				Name = "Land Type",	-- add setting for land type (12)
				Values = {
					"Pangaea",
					"Continents",
					"Oval",
				},

				DefaultValue = 1,
				SortPriority = -102,
			},

			{
				Name = "Land Size X",	-- add setting for land type (13)
				Values = {
					"36",
					"38",
					"40",
					"42",
					"44",
					"46",
					"48",
					"50",
					"52",
					"54",
					"56",
					"58",
					"60",
					"62",
					"64",
					"66",
					"68",
					"70",
					"72",
					"74",
					"76",
					"78",
					"80",
					"82",
					"84",
					"86",
					"88",
					"90",
					"92",
					"94",
					"96",
					"98",
					"100",
					"102",
					"104",
					"106",
					"108",
					"110",
					"112",
					"114",
					"116",
					"118",
					"120",
					"122",
					"124",
				},

				DefaultValue = 11,
				SortPriority = -101,
			},

			{
				Name = "Land Size Y",	-- add setting for land type (14)
				Values = {
					"20",
					"22",
					"24",
					"26",
					"28",
					"30",
					"32",
					"34",
					"36",
					"38",
					"40",
					"42",
					"44",
					"46",
					"48",
					"50",
					"52",
					"54",
					"56",
					"58",
					"60",
					"62",
					"64",
					"66",
					"68",
					"70",
					"72",
					"74",
					"76",

				},

				DefaultValue = 15,
				SortPriority = -100,
			},

			{
				Name = "TXT_KEY_MAP_OPTION_RESOURCES",	-- add setting for resources (15)
				Values = {
					"Sparse",
					"Mediocre",
					"Standard",
					"Plenty",
					"Abundant",
				},

				DefaultValue = 3,
				SortPriority = -91,
			},

			{
				Name = "Coastal Spawns",	-- Can inland civ spawn on the coast (16)
				Values = {
					"Coastal Civs Only",
					"Random",
					"Mixed bias",
				},

				DefaultValue = 3,
				SortPriority = -87,
			},

			{
				Name = "Coastal Luxes",	-- Can inland civ spawn on the coast (17)
				Values = {
					"Guaranteed",
					"Random (80% Chance Coastal)",
				},

				DefaultValue = 1,
				SortPriority = -86,
			},

			{
				Name = "Pangaea Bays",	-- Determines how harsh the bays are for mainland (18)
				Values = {
					"Minimal",
					"Standard",
					"Harsh",
				},

				DefaultValue = 2,
				SortPriority = -85,
			},
		},
	};
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)
	
	local MapShape = Map.GetCustomOption(12);
	local LandSizeX = 34 + (Map.GetCustomOption(13) * 2);
	local LandSizeY = 18 + (Map.GetCustomOption(14) * 2);

	local worldsizes = {};

	if MapShape == 1 then

		worldsizes = {

			[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {LandSizeX, LandSizeY}, -- 720
			[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {LandSizeX, LandSizeY}, -- 1664
			[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {LandSizeX, LandSizeY}, -- 2480
			[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {LandSizeX, LandSizeY}, -- 3900
			[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {LandSizeX, LandSizeY}, -- 6076
			[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {LandSizeX, LandSizeY} -- 9424
			}
		
	elseif MapShape == 2 or MapShape == 3 then
		worldsizes = {

				[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {LandSizeX, LandSizeY}, -- 960
				[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {LandSizeX, LandSizeY}, -- 2016
				[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {LandSizeX, LandSizeY}, -- 2772
				[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {LandSizeX, LandSizeY}, -- 4160
				[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {LandSizeX, LandSizeY}, -- 6656
				[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {LandSizeX, LandSizeY} -- 10240
				}
	end

	local grid_size = worldsizes[worldSize];
	--
	local world = GameInfo.Worlds[worldSize];
	if (world ~= nil) then
		return {
			Width = grid_size[1],
			Height = grid_size[2],
			WrapX = true,
		}; 
	end

end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- START OF PANGAEA CREATION CODE
------------------------------------------------------------------------------
PangaeaFractalWorld = {};
------------------------------------------------------------------------------
function PangaeaFractalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();
	local landHeight = (gridHeight - math.floor(gridHeight * 0.20));
	
	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = PangaeaFractalWorld.GeneratePlotTypes,	-- Custom method
		
		iFlags = Map.GetFractalFlags(),
		
		fracXExp = fracXExp,
		fracYExp = fracYExp,

		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		--iNumPlotsY = landHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight)
	};
		
	return data;
end

------------------------------------------------------------------------------
function PangaeaFractalWorld:GeneratePlotTypes(args)
	if(args == nil) then args = {}; end
	
	local iW, iH = Map.GetGridSize();

	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ MAP SIZE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	print("Map X: " .. iW);
	print("Map Y: " .. iH);
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

	local allcomplete = false;

	while allcomplete == false do
		local waterBorder = 7
		local smallBaysLow = 2;
		local smallBaysHigh = 3;
		local largeBaysLow = 5;
		local largeBaysHigh = 7;
		local smallBaysNS = 15;
		local smallBaysEW = 10;
		local largeBaysNS = 4;
		local largeBaysEW = 2;

		local world_age_old = 2;
		local world_age_normal = 3;
		local world_age_new = 15;
		--
		local extra_mountains = 25;
		local grain_amount = 0;
		local adjust_plates = 1.3;
		local shift_plot_types = true;
		local tectonic_islands = true;
		local hills_ridge_flags = self.iFlags;
		local peaks_ridge_flags = self.iFlags;
		local has_center_rift = true;
		local adjadj = 1.4;
		local xshift = 0;
		local yshift = 0;
		local yshiftamt = 0;
		local xshiftamt = 0;
		local xstart, xend = 0,0;
		local ystart, yend = 0,0;

		local sea_level = Map.GetCustomOption(4)
		if sea_level == 6 then
			sea_level = 1 + Map.Rand(5, "Random Sea Level - Lua");
		end
		local world_age = Map.GetCustomOption(1)
		if world_age == 5 then
			world_age = 1 + Map.Rand(3, "Random World Age - Lua");
		end

		-- Set Sea Level according to user selection.
		if sea_level == 1 then -- Very Low Sea Level
			waterBorder = 5;
		elseif sea_level == 2 then -- Low Sea Level
			waterBorder = 6;
		elseif sea_level == 4 then -- High Sea Level
			waterBorder = 8;
		elseif sea_level == 5 then -- Very High Sea Level
			waterBorder = 9;
		end

		local waterCenter = waterBorder;

		--set the bays roughness based on user setting
		local Roughness = Map.GetCustomOption(18)

		if Roughness == 1 then
			smallBaysLow = 1;
			smallBaysHigh = 2;
			largeBaysLow = 3;
			largeBaysHigh = 5;
			smallBaysNS = 7;
			smallBaysEW = 5;
			largeBaysNS = 2;
			largeBaysEW = 1;
		elseif Roughness == 3 then
			smallBaysLow = 4;
			smallBaysHigh = 6;
			largeBaysLow = 8;
			largeBaysHigh = 10;
			smallBaysNS = 20;
			smallBaysEW = 15;
			largeBaysNS = 6;
			largeBaysEW = 4;
		end

		-- Set values for hills and mountains according to World Age chosen by user.
		local adjustment = world_age_normal;
		if world_age == 4 then -- No Moutains
			adjustment = world_age_old;
			adjust_plates = adjust_plates * 0.5;
		elseif world_age == 3 then -- 5 Billion Years
			adjustment = world_age_old;
			adjust_plates = adjust_plates * 0.5;
		elseif world_age == 1 then -- 3 Billion Years
			adjustment = world_age_new;
			adjust_plates = adjust_plates * 1;
		else -- 4 Billion Years
		end
		-- Apply adjustment to hills and peaks settings.
		local hillsBottom1 = 20 - (adjustment * adjadj);
		local hillsTop1 = 20 + (adjustment * adjadj);
		local hillsBottom2 = 62 - (adjustment * adjadj);
		local hillsTop2 = 62 + (adjustment * adjadj);
		local hillsClumps = 1 + (adjustment * adjadj);
		local hillsNearMountains = 120 - (adjustment * 2) - extra_mountains;
		local mountains = 100 - adjustment - extra_mountains;
	
		if world_age == 4 then
			mountains = 300 - adjustment - extra_mountains;
		end

		-- Hills and Mountains handled differently according to map size - Bob
		local WorldSizeTypes = {};
		for row in GameInfo.Worlds() do
			WorldSizeTypes[row.Type] = row.ID;
		end
		local sizekey = Map.GetWorldSize();
		-- Fractal Grains
		local sizevalues = {
			[WorldSizeTypes.WORLDSIZE_DUEL]     = 3,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 3,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 3,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 3,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 3,
			[WorldSizeTypes.WORLDSIZE_HUGE]		= 3
		};
		local grain = sizevalues[sizekey] or 3;
		-- Tectonics Plate Counts
		local platevalues = {
			[WorldSizeTypes.WORLDSIZE_DUEL]		= 100,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 100,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 100,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 100,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 100,
			[WorldSizeTypes.WORLDSIZE_HUGE]     = 100
		};
		local numPlates = platevalues[sizekey] or 5;
		-- Add in any plate count modifications passed in from the map script. - Bob
		numPlates = numPlates * adjust_plates;

		-- Generate continental fractal layer and examine the largest landmass. Reject
		-- the result until the largest landmass occupies 90% or more of the total land.
		local iWaterThreshold, biggest_area, iNumTotalLandTiles, iNumBiggestAreaTiles, iBiggestID;
		local grain_dice = Map.Rand(7, "Continental Grain roll - LUA Pangaea");
		if grain_dice < 4 then
			grain_dice = 1;
		else
			grain_dice = 2;
		end
		local rift_dice = Map.Rand(3, "Rift Grain roll - LUA Pangaea");
		if rift_dice < 1 then
			rift_dice = -1;
		end

		rift_dice = -1;
		grain_dice = 5;

		self.continentsFrac = nil;
		self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = self.continentsFrac:GetHeight(water_percent);

		iNumTotalLandTiles = 0;
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_LAND;
					iNumTotalLandTiles = iNumTotalLandTiles + 1;
			end
		end

		SetPlotTypes(self.plotTypes);
		Map.RecalculateAreas();

		-- Generate fractals to govern hills and mountains
		self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
		self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
		self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 2, 1);
		self.mountainsFrac:BuildRidges((numPlates * 2) / 3, peaks_ridge_flags, 4, 1);
		-- Get height values
		local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
		local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
		local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
		local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
		local iHillsClumps = self.mountainsFrac:GetHeight(hillsClumps);
		local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
		local iMountainThreshold = self.mountainsFrac:GetHeight(mountains);
		local iPassThreshold = self.hillsFrac:GetHeight(hillsNearMountains);
		-- Get height values for tectonic islands
		local iMountain100 = self.mountainsFrac:GetHeight(100);
		local iMountain99 = self.mountainsFrac:GetHeight(99);
		local iMountain97 = self.mountainsFrac:GetHeight(97);
		local iMountain95 = self.mountainsFrac:GetHeight(95);

		-- Because we haven't yet shifted the plot types, we will not be able to take advantage 
		-- of having water and flatland plots already set. We still have to generate all data
		-- for hills and mountains, too, then shift everything, then set plots one more time.
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
	
				local i = y * self.iNumPlotsX + x;
				local val = self.continentsFrac:GetHeight(x, y);
				local mountainVal = self.mountainsFrac:GetHeight(x, y);
				local hillVal = self.hillsFrac:GetHeight(x, y);

				if (mountainVal >= iMountainThreshold) then
					if (hillVal >= iPassThreshold) then -- Mountain Pass though the ridgeline - Brian
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else -- Mountain
						-- set some randomness to moutains next to each other
						local iIsMount = Map.Rand(100, "Mountain Spwan Chance");
						--print("-"); print("Mountain Spawn Chance: ", iIsMount);
						local iIsMountAdj = 83 - adjustment;
						if iIsMount >= iIsMountAdj then
							self.plotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
						else
							-- set some randomness to hills or flat land next to the mountain
							local iIsHill = Map.Rand(100, "Hill Spwan Chance");
							--print("-"); print("Mountain Spawn Chance: ", iIsMount);
							local iIsHillAdj = 67 - adjustment;
							if iIsHillAdj >= iIsHill then
								self.plotTypes[i] = PlotTypes.PLOT_HILLS;
							else
								self.plotTypes[i] = PlotTypes.PLOT_LAND;
							end
						end
					end
				elseif (mountainVal >= iHillsNearMountains) then
					self.plotTypes[i] = PlotTypes.PLOT_HILLS; -- Foot hills - Bob
				else
					if ((hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2)) then
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else
						self.plotTypes[i] = PlotTypes.PLOT_LAND;
					end
				end
			end
		end
		-- Add water around top and bottom of map 
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, waterBorder do
				local i = y * self.iNumPlotsX + x;
				self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
			end
		end

		local mapTop = self.iNumPlotsY - 1;

		for x = 0, self.iNumPlotsX - 1 do
			for y = (mapTop - waterBorder), mapTop do
				local i = y * self.iNumPlotsX + x;
				self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
			end
		end

		-- add water at the edges of the map (W & E) to split the land
		for x = 0, waterCenter do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
				self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
			end
		end

		local edgeBorder = self.iNumPlotsX - 1;

		for x = (edgeBorder - waterCenter), edgeBorder do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
				self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
			end
		end

		-- Now add some variance to the edge of the map
		local baysBorder = Map.Rand((smallBaysHigh + 1) - smallBaysLow, "") + smallBaysLow;
		
		local nsBays = smallBaysNS;
		local ewBays = smallBaysEW;

		local baysInsetNorth = (mapTop - waterBorder - baysBorder);
		local baysInsetNorth2 = mapTop - (waterBorder + 1);

		local baysInsetSouth = (waterBorder + baysBorder);
		local baysInsetSouth2 = (waterBorder + 1);

		local bayInsetEast = ((iW - 1) - waterCenter - baysBorder);
		local bayInsetEast2 = 	(iW - 1) - (waterCenter + 1);

		local bayInsetWest = (waterCenter + 1  + baysBorder);
		local bayInsetWest2 = (waterCenter + 1);

		-- add some bays in the north
		for bayCount = 1, nsBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetNorth2 + 2) - baysInsetNorth, "") + baysInsetNorth;
			local x2 = x1;

			for y = y1, baysInsetNorth2 do
				for x = x1, x2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				x1 = x1 - 1;
				x2 = x2 + 1;
			end
		end

		-- add some bays in the south
		for bayCount = 1, nsBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetSouth + 2) - baysInsetSouth2, "") + baysInsetSouth2;
			local x2 = x1;

			for y = y1, baysInsetSouth2, -1 do
				for x = x1, x2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				x1 = x1 - 1;
				x2 = x2 + 1;
			end
		end

		-- add some bays in the west
		for bayCount = 1, ewBays do

			local x1 = Map.Rand((bayInsetWest + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetNorth2 + 1) - baysInsetSouth2, "") + baysInsetSouth2;
			local y2 = y1;

			for x = x1, bayInsetWest2, -1 do
				for y = y1, y2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				y1 = y1 - 1;
				y2 = y2 + 1;
			end
		end

		-- add some bays in the east
		for bayCount = 1, ewBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetEast, "") + bayInsetEast;
			local y1 = Map.Rand((baysInsetNorth2 + 1) - baysInsetSouth2, "") + baysInsetSouth2;
			local y2 = y1;

			for x = x1, bayInsetEast2 do
				for y = y1, y2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				y1 = y1 - 1;
				y2 = y2 + 1;
			end
		end

		--#####################

		-- Now add some variance to the edge of the map
		local baysBorder = Map.Rand((largeBaysHigh + 1) - largeBaysLow, "") + largeBaysLow;
		
		local nsBays = largeBaysNS;
		local ewBays = largeBaysEW;

		local baysInsetNorth = (mapTop - waterBorder - baysBorder);
		local baysInsetNorth2 = mapTop - (waterBorder + 1);

		local baysInsetSouth = (waterBorder + baysBorder);
		local baysInsetSouth2 = (waterBorder + 1);

		local bayInsetEast = ((iW - 1) - waterCenter - baysBorder);
		local bayInsetEast2 = 	(iW - 1) - (waterCenter + 1);

		local bayInsetWest = (waterCenter + 1  + baysBorder);
		local bayInsetWest2 = (waterCenter + 1);

		-- add some bays in the north
		for bayCount = 1, nsBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetNorth2 + 2) - baysInsetNorth, "") + baysInsetNorth;
			local x2 = x1;

			for y = y1, baysInsetNorth2 do
				for x = x1, x2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				x1 = x1 - 1;
				x2 = x2 + 1;
			end
		end

		-- add some bays in the south
		for bayCount = 1, nsBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetSouth + 2) - baysInsetSouth2, "") + baysInsetSouth2;
			local x2 = x1;

			for y = y1, baysInsetSouth2, -1 do
				for x = x1, x2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				x1 = x1 - 1;
				x2 = x2 + 1;
			end
		end

		-- add some bays in the west
		for bayCount = 1, ewBays do

			local x1 = Map.Rand((bayInsetWest + 1) - bayInsetWest2, "") + bayInsetWest2;
			local y1 = Map.Rand((baysInsetNorth2 + 1) - baysInsetSouth2, "") + baysInsetSouth2;
			local y2 = y1;

			for x = x1, bayInsetWest2, -1 do
				for y = y1, y2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				y1 = y1 - 1;
				y2 = y2 + 1;
			end
		end

		-- add some bays in the east
		for bayCount = 1, ewBays do

			local x1 = Map.Rand((bayInsetEast2 + 1) - bayInsetEast, "") + bayInsetEast;
			local y1 = Map.Rand((baysInsetNorth2 + 1) - baysInsetSouth2, "") + baysInsetSouth2;
			local y2 = y1;

			for x = x1, bayInsetEast2 do
				for y = y1, y2 do
					local i = y * self.iNumPlotsX + x;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end

				y1 = y1 - 1;
				y2 = y2 + 1;
			end
		end

		self:ShiftPlotTypes();

		--#####################

		-- Create islands. Try to make more useful islands than the default code.
		-- pick a random tile and check if it is ocean, if it is check tiles around it
		-- to see how big an island we can make, then make an island from size 1 up to the biggest we can make

		-- Hex Adjustment tables. These tables direct plot by plot scans in a radius 
		-- around a center hex, starting to Northeast, moving clockwise.
		local islandQty = {
			[WorldSizeTypes.WORLDSIZE_DUEL]		= 5,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 16,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 24,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 32,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 52,
			[WorldSizeTypes.WORLDSIZE_HUGE]		= 77
		}

		local firstRingYIsEven = {{0, 1}, {1, 0}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

		local secondRingYIsEven = {
		{1, 2}, {1, 1}, {2, 0}, {1, -1}, {1, -2}, {0, -2},
		{-1, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-1, 2}, {0, 2}
		};

		local thirdRingYIsEven = {
		{1, 3}, {2, 2}, {2, 1}, {3, 0}, {2, -1}, {2, -2},
		{1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-2, -2}, {-3, -1},
		{-3, 0}, {-3, 1}, {-2, 2}, {-2, 3}, {-1, 3}, {0, 3}
		};

		local firstRingYIsOdd = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {0, 1}};

		local secondRingYIsOdd = {		
		{1, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -2}, {0, -2},
		{-1, -2}, {-1, -1}, {-2, 0}, {-1, 1}, {-1, 2}, {0, 2}
		};

		local thirdRingYIsOdd = {		
		{2, 3}, {2, 2}, {3, 1}, {3, 0}, {3, -1}, {2, -2},
		{2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -2}, {-2, -1},
		{-3, 0}, {-2, 1}, {-2, 2}, {-1, 3}, {0, 3}, {1, 3}
		};

		-- Direction types table, another method of handling hex adjustments, in combination with Map.PlotDirection()
		local direction_types = {
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST
			};


		plotTypesTwo = self.plotTypes;

		local iW, iH = Map.GetGridSize();
		local islMax = islandQty[sizekey] or 24;
		local mapSize = iW * iH;
		local islCount = 0;
		local islLandInRing = 0;
		local goodX = 0;
		local goodY = 0;

		local wrapX = Map:IsWrapX();
		local wrapY = false; --Map:IsWrapY();
		local nextX, nextY, plot_adjustments;
		local odd = firstRingYIsOdd;
		local even = firstRingYIsEven;
		local failedattemps = 0;
		local bIslandsFailure = false;

		local minIslandSize = 1;
		local maxIslandSize = 5;
		local escapeRedo = 500;
		local redoMap = false;

		print("######### Creating Islands #########");

		islandSetting = Map.GetCustomOption(11);

		islCount =  12;

		if islandSetting == 1 then --sparse
			islCount =  8;
		elseif islandSetting == 3 then -- plentiful
			islCount =  15;
		elseif islandSetting == 3 then -- abundant
			islCount =  22;
		end

		while islCount > 0 and escapeRedo > 0 do

			local islLandInRing = 0;
			local startingPlot = 0;
			local landX = 0;
			local landY = 0;
			local landPlot = 0;

			--pick random location
			local x = Map.Rand(iW, "");
			local y = 3 + Map.Rand((iH-6), "");	
			local plotIndex = y * iW + x + 1;

			local radius = Map.Rand(4, "");
			--print("----------------------------------------------------------------------------------------");
			--print("Count: ", islCount);
			--print ("Radius: ", radius);
			--print("X=", x);
			--print("Y=", y);		
		
			--print("--------");
			--print("Random Plot Is: ", plotIndex);

			--check if random location is ocean
			if self.plotTypes[plotIndex] == PlotTypes.PLOT_OCEAN then
				
				startingPlot = plotIndex;

				--print("Location is Ocean");
				local radiuschk = 5;

				for ripple_radius = 1, radiuschk do
					local ripple_value = radiuschk - ripple_radius + 1;
					local currentX = x - ripple_radius;
					local currentY = y;
					for direction_index = 1, 6 do
						for plot_to_handle = 1, ripple_radius do
				 			if currentY / 2 > math.floor(currentY / 2) then
								plot_adjustments = odd[direction_index];
							else
								plot_adjustments = even[direction_index];
							end
							nextX = currentX + plot_adjustments[1];
							nextY = currentY + plot_adjustments[2];
							if wrapX == false and (nextX < 0 or nextX >= iW) then
								-- X is out of bounds.
							elseif wrapY == false and (nextY < 0 or nextY >= iH) then
								-- Y is out of bounds.
							else
								local realX = nextX;
								local realY = nextY;
								if wrapX then
									realX = realX % iW;
								end
								if wrapY then
									realY = realY % iH;
								end
								-- We've arrived at the correct x and y for the current plot.
								--local plot = Map.GetPlot(realX, realY);
								local plotIndex = realY * iW + realX + 1;
	
								--print("--------");
								--print("Plot Is: ", plotIndex);
	
								-- Check this plot for land.

								if self.plotTypes[plotIndex] == PlotTypes.PLOT_LAND then
									islLandInRing = ripple_radius;
									
									landPlot = plotIndex;

									landX = realX;
									landY = realY;

									--print("PlotID: " .. tostring(plotIndex));
									--print("RealX: " .. tostring(realX));
									--print("RealY: " .. tostring(realY));
									break;
								end

								currentX, currentY = nextX, nextY;
							end
						end

						if islLandInRing ~= 0 then
							break;
						end
					end
	
					if islLandInRing ~= 0 then
						break;
					end

				end


				if islLandInRing ~= 0 then

					--print("We hit land, check if it is the Mainland");

					local biggest_area = Map.FindBiggestArea(false);
					local biggest_ID = biggest_area:GetID();
					local plotCheck = Map.GetPlot(landX, landY);
					local plotArea = plotCheck:Area();
					local iAreaID = plotArea:GetID();
					local pullBack = 3;

					-- pull back the radius by 2 to 3 tiles and as long as island will be a radius of 2 then plunk it in da water init bruv!
					if plotTypesTwo[landPlot] == PlotTypes.PLOT_LAND then

						-- create us an island
						islLandInRing = islLandInRing - pullBack;

						--self.plotTypes[startingPlot] = PlotTypes.PLOT_LAND

						if islLandInRing > minIslandSize and islLandInRing < maxIslandSize then

							local islThresh = 0;
							local landvarDefault = 10;

							local locationRnd = Map.Rand(100, "");

							if (locationRnd > 49) then
								self.plotTypes[startingPlot] = PlotTypes.PLOT_LAND;
							else
								self.plotTypes[startingPlot] = PlotTypes.PLOT_HILLS;
							end

							for ripple_radius = 1, islLandInRing do
								local ripple_value = islLandInRing - ripple_radius + 1;
								local currentX = x - ripple_radius;
								local currentY = y;
								for direction_index = 1, 6 do
									for plot_to_handle = 1, ripple_radius do
							 			if currentY / 2 > math.floor(currentY / 2) then
											plot_adjustments = odd[direction_index];
										else
											plot_adjustments = even[direction_index];
										end
										nextX = currentX + plot_adjustments[1];
										nextY = currentY + plot_adjustments[2];
										if wrapX == false and (nextX < 0 or nextX >= iW) then
											-- X is out of bounds.
										elseif wrapY == false and (nextY < 0 or nextY >= iH) then
											-- Y is out of bounds.
										else
											local realX = nextX;
											local realY = nextY;
											if wrapX then
												realX = realX % iW;
											end
											if wrapY then
												realY = realY % iH;
											end
											-- We've arrived at the correct x and y for the current plot.
											--local plot = Map.GetPlot(realX, realY);
											local plotIndex = realY * iW + realX + 1;
											
											local thisislandvar = Map.Rand(60, "") + landvarDefault;

											-- closer we get to outer edge increase chance of ocean.
											if ripple_radius == 1  then --100%
												islThresh = Map.Rand(50, "") + thisislandvar;
											elseif ripple_radius == 2 then -- 57% to 74%
												islThresh = Map.Rand(45, "") + (thisislandvar / 1.25);
											elseif ripple_radius == 3 then --40% to 57%
												islThresh = Map.Rand(37, "") + (thisislandvar / 1.5);
											else --30% to 50%
												islThresh = Map.Rand(30, "") + (thisislandvar / 2);
											end

											local islRand = Map.Rand(100, "");
											local islHill = Map.Rand(100, "");

											--print("Rand: ", islRand, "Thresh: ", islThresh);

											if islRand > islThresh then
												self.plotTypes[plotIndex] = PlotTypes.PLOT_OCEAN
												landvarDefault = landvarDefault + 5;
											else
												if islHill <= 40 then
													self.plotTypes[plotIndex] = PlotTypes.PLOT_LAND
												else
													self.plotTypes[plotIndex] = PlotTypes.PLOT_HILLS
												end
											end

											currentX, currentY = nextX, nextY;
										end
									end
								end
							end
							islCount = islCount -1;
						end
					end
				end
			end
			
			escapeRedo = escapeRedo - 1;

		end

		-- make sure islands were created
		if escapeRedo == 0 then
			--oh boy something went wrong, regen a new map
			redoMap = true
		end

		print("######### Finished Islands #########");

		--check to make sure map has not failed
		local iNumLandTilesInUse = 0;
		local iW, iH = Map.GetGridSize();
		local iPercent = (iW * iH) * 0.35;

		for y = 0, iH - 1 do
			for x = 0, iW - 1 do
				local i = iW * y + x;
				if self.plotTypes[i] ~= PlotTypes.PLOT_OCEAN then
					iNumLandTilesInUse = iNumLandTilesInUse + 1;
				end
			end
		end

		redoMap = false;

		print("######### Map Failure Check #########");
		print("35% Of Map Area: ", iPercent);
		print("Map Land Tiles: ", iNumLandTilesInUse);

		if iNumLandTilesInUse >= iPercent and redoMap == false then
			allcomplete = true;
			print("######### Map Pass #########");
		else
			print("######### Map Failure #########");
		end
	end

	return self.plotTypes;
end









------------------------------------------------------------------------------
-- START OF CONTINENTS CREATION CODE
------------------------------------------------------------------------------
ContinentsFractalWorld = {};
------------------------------------------------------------------------------
function ContinentsFractalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();
	
	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = ContinentsFractalWorld.GeneratePlotTypes,	-- Custom method
		
		iFlags = Map.GetFractalFlags(),
		
		fracXExp = fracXExp,
		fracYExp = fracYExp,
		
		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight)
	};
		
	return data;
end	

------------------------------------------------------------------------------
function ContinentsFractalWorld:GeneratePlotTypes(args)
	if(args == nil) then args = {}; end
	
	local sea_level_low = 67;
	local sea_level_normal = 72;
	local sea_level_high = 76;
	local world_age_old = 2;
	local world_age_normal = 5;
	local world_age_new = 15;
	--
	local extra_mountains = 25;
	local grain_amount = 0;
	local adjust_plates = 1.3;
	local shift_plot_types = true;
	local tectonic_islands = false;
	local hills_ridge_flags = self.iFlags;
	local peaks_ridge_flags = self.iFlags;
	local has_center_rift = true;
	local adjadj = 1.4;

	local sea_level = Map.GetCustomOption(4)
	if sea_level == 4 then
		sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local world_age = Map.GetCustomOption(1)
	if world_age == 5 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end

	-- Set Sea Level according to user selection.
	local water_percent = sea_level_normal;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
	else -- Normal Sea Level
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age_normal;
	if world_age == 4 then -- No Moutains
			adjustment = world_age_old;
			adjust_plates = adjust_plates * 0.5;
	elseif world_age == 3 then -- 5 Billion Years
		adjustment = world_age_old;
		adjust_plates = adjust_plates * 0.5;
	elseif world_age == 1 then -- 3 Billion Years
		adjustment = world_age_new;
		adjust_plates = adjust_plates * 1;
	else -- 4 Billion Years
	end
	-- Apply adjustment to hills and peaks settings.
	local hillsBottom1 = 28 - (adjustment * adjadj);
	local hillsTop1 = 28 + (adjustment * adjadj);
	local hillsBottom2 = 72 - (adjustment * adjadj);
	local hillsTop2 = 72 + (adjustment * adjadj);
	local hillsClumps = 1 + (adjustment * adjadj);
	local hillsNearMountains = 120 - (adjustment * 2) - extra_mountains;
	local mountains = 100 - adjustment - extra_mountains;

	if world_age == 4 then
		mountains = 300 - adjustment - extra_mountains;
	end

	-- Hills and Mountains handled differently according to map size
	local WorldSizeTypes = {};
	for row in GameInfo.Worlds() do
		WorldSizeTypes[row.Type] = row.ID;
	end
	local sizekey = Map.GetWorldSize();
	-- Fractal Grains
	local sizevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL]     = 3,
		[WorldSizeTypes.WORLDSIZE_TINY]     = 3,
		[WorldSizeTypes.WORLDSIZE_SMALL]    = 3,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 3,
		[WorldSizeTypes.WORLDSIZE_LARGE]    = 3,
		[WorldSizeTypes.WORLDSIZE_HUGE]		= 3
	};
	local grain = sizevalues[sizekey] or 3;
	-- Tectonics Plate Counts
	local platevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL]		= 100,
		[WorldSizeTypes.WORLDSIZE_TINY]     = 100,
		[WorldSizeTypes.WORLDSIZE_SMALL]    = 100,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 100,
		[WorldSizeTypes.WORLDSIZE_LARGE]    = 100,
		[WorldSizeTypes.WORLDSIZE_HUGE]     = 100
	};
	local numPlates = platevalues[sizekey] or 5;
	-- Add in any plate count modifications passed in from the map script.
	numPlates = numPlates * adjust_plates;

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 45% to 55% of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold, biggest_area, iNumTotalLandTiles, iNumBiggestAreaTiles, iBiggestID;
	while done == false do
		local plusminus = 0.3;
		local grain_dice = Map.Rand(7, "Continental Grain roll - LUA Continents");
		if grain_dice < 4 then
			grain_dice = 1;
		else
			grain_dice = 2;
		end
		local rift_dice = Map.Rand(3, "Rift Grain roll - LUA Continents");
		if rift_dice < 1 then
			rift_dice = -1;
		end
		
		rift_dice = -1;
		grain_dice = 1;

		self.continentsFrac = nil;
		self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = self.continentsFrac:GetHeight(water_percent);
		
		iNumTotalLandTiles = 0;
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
				local val = self.continentsFrac:GetHeight(x, y);
				if(val <= iWaterThreshold) then
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				else
					self.plotTypes[i] = PlotTypes.PLOT_LAND;
					iNumTotalLandTiles = iNumTotalLandTiles + 1;
				end
			end
		end

		self:ShiftPlotTypes();
		self:GenerateCenterRift()

		SetPlotTypes(self.plotTypes);
		Map.RecalculateAreas();
		
		biggest_area = Map.FindBiggestArea(false);
		iNumBiggestAreaTiles = biggest_area:GetNumTiles();
		-- Now test the biggest landmass to see if it is large enough.
		if (iNumBiggestAreaTiles <= (iNumTotalLandTiles * 0.53)) and (iNumBiggestAreaTiles >= (iNumTotalLandTiles * 0.47)) then
			done = true;
			iBiggestID = biggest_area:GetID();
		end
		iAttempts = iAttempts + 1;
		
		-- Printout for debug use only
		print("-"); print("--- Continents landmass generation, Attempt#", iAttempts, "---");
		print("- This attempt successful: ", done);
		print("- Total Land Plots in world:", iNumTotalLandTiles);
		print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
		print("- Percentage of land belonging to biggest: ", 100 * iNumBiggestAreaTiles / iNumTotalLandTiles);
		print("- Continent Grain for this attempt: ", grain_dice);
		print("- Rift Grain for this attempt: ", rift_dice);
		print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		print(".");
		
	end
	
	-- Generate fractals to govern hills and mountains
	self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 2, 1);
	self.mountainsFrac:BuildRidges((numPlates * 2) / 3, peaks_ridge_flags, 4, 1);
	-- Get height values
	local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
	local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
	local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
	local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
	local iHillsClumps = self.mountainsFrac:GetHeight(hillsClumps);
	local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
	local iMountainThreshold = self.mountainsFrac:GetHeight(mountains);
	local iPassThreshold = self.hillsFrac:GetHeight(hillsNearMountains);
	
	-- Set Hills and Mountains
	for x = 0, self.iNumPlotsX - 1 do
		for y = 0, self.iNumPlotsY - 1 do
			local plot = Map.GetPlot(x, y);
			local mountainVal = self.mountainsFrac:GetHeight(x, y);
			local hillVal = self.hillsFrac:GetHeight(x, y);
	
			if plot:GetPlotType() ~= PlotTypes.PLOT_OCEAN then
				if (mountainVal >= iMountainThreshold) then
					if (hillVal >= iPassThreshold) then -- Mountain Pass though the ridgeline
						plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
					else -- Mountain
						-- set some randomness to moutains next to each other
						local iIsMount = Map.Rand(100, "Mountain Spwan Chance");
						--print("-"); print("Mountain Spawn Chance: ", iIsMount);
						local iIsMountAdj = 83 - adjustment;
						if iIsMount >= iIsMountAdj then
							plot:SetPlotType(PlotTypes.PLOT_MOUNTAIN, false, false);
						else
							-- set some randomness to hills or flat land next to the mountain
							local iIsHill = Map.Rand(100, "Hill Spwan Chance");
							--print("-"); print("Mountain Spawn Chance: ", iIsMount);
							local iIsHillAdj = 50 - adjustment;
							if iIsHillAdj >= iIsHill then
								plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
							else
								plot:SetPlotType(PlotTypes.PLOT_LAND, false, false);
							end
						end
					end
				elseif (mountainVal >= iHillsNearMountains) then
					plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
				else
					if ((hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2)) then
						plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
					else
						plot:SetPlotType(PlotTypes.PLOT_LAND, false, false);
					end
				end
			end
		end
	end
end
------------------------------------------------------------------------------










------------------------------------------------------------------------------
--START OF OVAL CREATION CODE
------------------------------------------------------------------------------
OvalWorld = {};
------------------------------------------------------------------------------
function OvalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();
	
	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = OvalWorld.GeneratePlotTypes,	-- Custom method
		
		iFlags = Map.GetFractalFlags(),
		
		fracXExp = fracXExp,
		fracYExp = fracYExp,
		
		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight)
	};
		
	return data;
end	
------------------------------------------------------------------------------
function OvalWorld:GeneratePlotTypes(args)
	if(args == nil) then args = {}; end

	local sea_level_low = 63;
	local sea_level_normal = 50;
	local sea_level_high = 73;
	local world_age_old = 2;
	local world_age_normal = 5;
	local world_age_new = 15;
	--
	local extra_mountains = 25;
	local grain_amount = 0;
	local adjust_plates = 1.3;
	local shift_plot_types = true;
	local tectonic_islands = true;
	local hills_ridge_flags = self.iFlags;
	local peaks_ridge_flags = self.iFlags;
	local has_center_rift = false;
	local adjadj = 1.4;
	local xshift = 0;
	local yshift = 0;
	local yshiftamt = 0;
	local xshiftamt = 0;
	local xstart, xend = 0,0;
	local ystart, yend = 0,0;
	iSea_Lvl = 0;

	local sea_level = Map.GetCustomOption(4)
	if sea_level == 4 then
		sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local world_age = Map.GetCustomOption(1)
	if world_age == 5 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end

	-- Set Sea Level according to user selection.
	if sea_level == 1 then -- Low Sea Level
		iSea_Lvl = -2;
	elseif sea_level == 3 then -- High Sea Level
		iSea_Lvl = 2;
	else -- Normal Sea Level
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age_normal;
	if world_age == 4 then -- No Moutains
		adjustment = world_age_old;
		adjust_plates = adjust_plates * 0.5;
	elseif world_age == 3 then -- 5 Billion Years
		adjustment = world_age_old;
		adjust_plates = adjust_plates * 0.5;
	elseif world_age == 1 then -- 3 Billion Years
		adjustment = world_age_new;
		adjust_plates = adjust_plates * 1;
	else -- 4 Billion Years
	end
	-- Apply adjustment to hills and peaks settings.
	local hillsBottom1 = 28 - (adjustment * adjadj);
	local hillsTop1 = 28 + (adjustment * adjadj);
	local hillsBottom2 = 72 - (adjustment * adjadj);
	local hillsTop2 = 72 + (adjustment * adjadj);
	local hillsClumps = -3 + (adjustment * adjadj);
	local hillsNearMountains = 120 - (adjustment * 2) - extra_mountains;
	local mountains = 35 - adjustment - extra_mountains;
	
	if world_age == 4 then
		mountains = 300 - adjustment - extra_mountains;
	end

	-- Hills and Mountains handled differently according to map size - Bob
	local WorldSizeTypes = {};
	for row in GameInfo.Worlds() do
		WorldSizeTypes[row.Type] = row.ID;
	end
	local sizekey = Map.GetWorldSize();
	-- Fractal Grains
	local sizevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL]     = 3,
		[WorldSizeTypes.WORLDSIZE_TINY]     = 3,
		[WorldSizeTypes.WORLDSIZE_SMALL]    = 3,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 3,
		[WorldSizeTypes.WORLDSIZE_LARGE]    = 3,
		[WorldSizeTypes.WORLDSIZE_HUGE]		= 3
	};
	local grain = sizevalues[sizekey] or 3;
	-- Tectonics Plate Counts
	local platevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL]		= 100,
		[WorldSizeTypes.WORLDSIZE_TINY]     = 100,
		[WorldSizeTypes.WORLDSIZE_SMALL]    = 100,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 100,
		[WorldSizeTypes.WORLDSIZE_LARGE]    = 100,
		[WorldSizeTypes.WORLDSIZE_HUGE]     = 100
	};
	local numPlates = platevalues[sizekey] or 5;
	-- Add in any plate count modifications passed in from the map script. - Bob
	numPlates = numPlates * adjust_plates;

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 90% or more of the total land.
	rift_dice = -1;
	grain_dice = 7;
	
	local fracFlags = {FRAC_WRAP_X = true, FRAC_POLAR = true};
	local iW, iH = Map.GetGridSize();
	local terrainFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, fracFlags, self.fracXExp, self.fracYExp);

	self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, fracFlags, self.fracXExp, self.fracYExp);
	self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, fracFlags, self.fracXExp, self.fracYExp);
	self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 2, 1);
	self.mountainsFrac:BuildRidges((numPlates * 2) / 3, peaks_ridge_flags, 4, 1);
	
	-- Get height values
	local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
	local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
	local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
	local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
	local iHillsClumps = self.mountainsFrac:GetHeight(hillsClumps);
	
	--local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
	
	local iPeaksThreshold = self.mountainsFrac:GetHeight(mountains);
	local iHillsThreshold = self.hillsFrac:GetHeight(hillsNearMountains);

	local axis_list = {0.71, 0.65, 0.59};
	local axis_multiplier = axis_list[sea_level];
	local cohesion_list = {0.44, 0.41, 0.38};
	local cohesion_multiplier = cohesion_list[sea_level];

	--make the oval smaller than the map size
	--iW = 40;
	--iH = 24;

	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * axis_multiplier;
	local minorAxis = centerY * axis_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local deltaX = x - centerX;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
			if d <= 1 then
				--print("X=", x, "Y=", y, "D=", d);

				local i = y * iW + x + 1;
				--self.wholeworldPlotTypes[i] = PlotTypes.PLOT_LAND;

				local val = terrainFrac:GetHeight(x, y);
				local hillsVal = self.hillsFrac:GetHeight(x, y);
				local seaorland = Map.Rand(100, "");
				
				--add variance to outter endge of oval
				if d > 0.70 and seaorland < 50 then
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				elseif val >= iPeaksThreshold then
					local iIsMount = Map.Rand(100, "Mountain Spwan Chance");
					--print("-"); print("Mountain Spawn Chance: ", iIsMount);
					local iIsMountAdj = 96 - adjustment;
					if iIsMount >= iIsMountAdj then
						self.plotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
					else
						-- set some randomness to hills or flat land next to the mountain
						local iIsHill = Map.Rand(100, "Hill Spwan Chance");
						--print("-"); print("Mountain Spawn Chance: ", iIsMount);
						local iIsHillAdj = 40 - adjustment;
						if iIsHillAdj >= iIsHill then
							self.plotTypes[i] = PlotTypes.PLOT_HILLS;
						else
							self.plotTypes[i] = PlotTypes.PLOT_LAND;
						end
					end
				elseif val >= iHillsThreshold or val <= iHillsClumps then
					-- set some randomness to hills or flat land next to the mountain
					local MeIsHill = Map.Rand(100, "Hill Spwan Chance");
					local MeIsHillAdj = 50 - adjustment;
					if MeIsHillAdj >= MeIsHill then
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else
						self.plotTypes[i] = PlotTypes.PLOT_LAND;
					end
				elseif hillsVal >= iHillsBottom1 and hillsVal <= iHillsTop1 then
					self.plotTypes[i] = PlotTypes.PLOT_HILLS;
				elseif hillsVal >= iHillsBottom2 and hillsVal <= iHillsTop2 then
					self.plotTypes[i] = PlotTypes.PLOT_HILLS;
				else
					self.plotTypes[i] = PlotTypes.PLOT_LAND;
				end
			end
		end
	end
	
	-- Now add bays, fjords, inland seas, etc, but not inside the cohesion area.
	local baysFrac = Fractal.Create(iW, iH, 3, fracFlags, -1, -1);
	local iBaysThreshold = baysFrac:GetHeight(90);
	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * cohesion_multiplier;
	local minorAxis = centerY * cohesion_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local deltaX = x - centerX;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
			if d > 1 then
				local i = y * iW + x + 1;
				local baysVal = baysFrac:GetHeight(x, y);
				if baysVal >= iBaysThreshold then
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end
			end
		end
	end
	
	-- Create islands. Try to make more useful islands than the default code.
	-- pick a random tile and check if it is ocean, if it is check tiles around it
	-- to see how big an island we can make, then make an island from size 1 up to the biggest we can make

	-- Hex Adjustment tables. These tables direct plot by plot scans in a radius 
	-- around a center hex, starting to Northeast, moving clockwise.
	local firstRingYIsEven = {{0, 1}, {1, 0}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

	local secondRingYIsEven = {
	{1, 2}, {1, 1}, {2, 0}, {1, -1}, {1, -2}, {0, -2},
	{-1, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-1, 2}, {0, 2}
	};

	local thirdRingYIsEven = {
	{1, 3}, {2, 2}, {2, 1}, {3, 0}, {2, -1}, {2, -2},
	{1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-2, -2}, {-3, -1},
	{-3, 0}, {-3, 1}, {-2, 2}, {-2, 3}, {-1, 3}, {0, 3}
	};

	local firstRingYIsOdd = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {0, 1}};

	local secondRingYIsOdd = {		
	{1, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -2}, {0, -2},
	{-1, -2}, {-1, -1}, {-2, 0}, {-1, 1}, {-1, 2}, {0, 2}
	};

	local thirdRingYIsOdd = {		
	{2, 3}, {2, 2}, {3, 1}, {3, 0}, {3, -1}, {2, -2},
	{2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -2}, {-2, -1},
	{-3, 0}, {-2, 1}, {-2, 2}, {-1, 3}, {0, 3}, {1, 3}
	};

	-- Direction types table, another method of handling hex adjustments, in combination with Map.PlotDirection()
	local direction_types = {
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_NORTHWEST
		};

	local iW, iH = Map.GetGridSize();
	local islMax = 12;
	local iLandSize = 3;
	local mapSize = iW * iH;
	local islCount = 0;
	local islLandInRing = 0;
	local goodX = 0;
	local goodY = 0;

	local wrapX = Map:IsWrapX();
	local wrapY = Map:IsWrapY();
	local nextX, nextY, plot_adjustments;
	local odd = firstRingYIsOdd;
	local even = firstRingYIsEven;

	print("######### Creating Islands #########");

	islCount = islMax;
		
	while islCount > 0 do
		local islLandInRing = 0;
		--pick random location
		local x = Map.Rand(iW, "");
		local y = 6 + Map.Rand((iH-12), "");	
		local plotIndex = y * iW + x;
		local radius = 2 + math.floor(Map.Rand((islCount/iLandSize), ""));
		--print("Count: ", islCount);
		--print ("Radius: ", radius);
		--print("X=", x);
		--print("Y=", y);		
		
		--print("--------");
		--print("Random Plot Is: ", plotIndex);

		--check if random location is ocean
		if self.plotTypes[plotIndex] == PlotTypes.PLOT_OCEAN then
		
			--print("Location is Ocean");

			for ripple_radius = 1, radius do
				local ripple_value = radius - ripple_radius + 1;
				local currentX = x - ripple_radius;
				local currentY = y;
				for direction_index = 1, 6 do
					for plot_to_handle = 1, ripple_radius do
				 		if currentY / 2 > math.floor(currentY / 2) then
							plot_adjustments = odd[direction_index];
						else
							plot_adjustments = even[direction_index];
						end
						nextX = currentX + plot_adjustments[1];
						nextY = currentY + plot_adjustments[2];
						if wrapX == false and (nextX < 0 or nextX >= iW) then
							-- X is out of bounds.
						elseif wrapY == false and (nextY < 0 or nextY >= iH) then
							-- Y is out of bounds.
						else
							local realX = nextX;
							local realY = nextY;
							if wrapX then
								realX = realX % iW;
							end
							if wrapY then
								realY = realY % iH;
							end
							-- We've arrived at the correct x and y for the current plot.
							local plot = Map.GetPlot(realX, realY);
							local plotIndex = realY * iW + realX + 1;
	
							--print("--------");
							--print("Plot Is: ", plotIndex);
	
							-- Check this plot for land.

							if self.plotTypes[plotIndex] == PlotTypes.PLOT_LAND then
								islLandInRing = ripple_radius;
								break;
							end

							currentX, currentY = nextX, nextY;
						end
					end

					if islLandInRing ~= 0 then
						break;
					end
				end
	
				if islLandInRing ~= 0 then
					break;
				end

			end

			if islLandInRing == 0 then
			
				local actradius = radius - 1;
				local thisislandvar = Map.Rand(40, "") + 40;

				plotIndex = y * iW + x+1;
				--print("---------PlotIndex: ", plotIndex);
				--print("---------");
				--print("Island Location Found At X=", x, ", Y=",y);
				--print("Island Size: ", actradius);
				
				self.plotTypes[plotIndex] = PlotTypes.PLOT_LAND;

				for ripple_radius = 1, actradius do
					local ripple_value = actradius - ripple_radius + 1;
					local currentX = x - ripple_radius;
					local currentY = y;
					for direction_index = 1, 6 do
						for plot_to_handle = 1, ripple_radius do
					 		if currentY / 2 > math.floor(currentY / 2) then
								plot_adjustments = odd[direction_index];
							else
								plot_adjustments = even[direction_index];
							end
							nextX = currentX + plot_adjustments[1];
							nextY = currentY + plot_adjustments[2];
							if wrapX == false and (nextX < 0 or nextX >= iW) then
								-- X is out of bounds.
							elseif wrapY == false and (nextY < 0 or nextY >= iH) then
								-- Y is out of bounds.
							else
								local realX = nextX;
								local realY = nextY;
								if wrapX then
									realX = realX % iW;
								end
								if wrapY then
									realY = realY % iH;
								end
								-- We've arrived at the correct x and y for the current plot.
								local plot = Map.GetPlot(realX, realY);
								local plotIndex = realY * iW + realX + 1;
		
								--print("--------");
								--print("Plot Is: ", plotIndex);
		
								-- closer we get to outer edge increase chance of ocean.
								if ripple_radius == 1  then --100%
									islThresh = Map.Rand(27, "") + thisislandvar;
								elseif ripple_radius == 2 then -- 57% to 74%
									islThresh = Map.Rand(32, "") + (thisislandvar / 1.25);
								elseif ripple_radius == 3 then --40% to 57%
									islThresh = Map.Rand(25, "") + (thisislandvar / 1.5);
								else --30% to 50%
									islThresh = Map.Rand(20, "") + (thisislandvar / 2);
								end

								local islRand = Map.Rand(100, "");
								local islHill = Map.Rand(100, "");

								--print("Rand: ", islRand, "Thresh: ", islThresh);

								if islRand > islThresh then
									self.plotTypes[plotIndex] = PlotTypes.PLOT_OCEAN
								else
									if islHill <= 30 then
										self.plotTypes[plotIndex] = PlotTypes.PLOT_LAND
									else
										self.plotTypes[plotIndex] = PlotTypes.PLOT_HILLS
									end
								end

								currentX, currentY = nextX, nextY;
							end
						end
					end
	
				end
			
				islCount = islCount - 1;
			else
				
				--print("---------");
				--print("Land In Ring: ", islLandInRing);
			end
		end
	end

	print("######### Finished Islands #########");
	return self.plotTypes;
end
------------------------------------------------------------------------------







------------------------------------------------------------------------------
function GeneratePlotTypes()

	local MapShape = Map.GetCustomOption(12);

	if MapShape == 1 then
	    --PlotIndexotIndexlot generation customized to ensure enough land belongs to the Pangaea.
		print("Generating Plot Types (Lua Pangaea) ...");
	
		local fractal_world = PangaeaFractalWorld.Create();
		local plotTypes = fractal_world:GeneratePlotTypes();

		SetPlotTypes(plotTypes);
		GenerateCoasts();
	elseif MapShape == 2 then
		-- Customized plot generation to ensure avoiding "near Pangaea" conditions.
		print("Generating Plot Types (Lua Continents) ...");
		
		local fractal_world = ContinentsFractalWorld.Create();
		fractal_world:GeneratePlotTypes();
		
		GenerateCoasts();
	elseif MapShape == 3 then
		-- Plot generation customized to ensure enough land belongs to the Oval.
		print("Generating Plot Types (Lua Oval) ...");
		
		local fractal_world = OvalWorld.Create();
		local plotTypes = fractal_world:GeneratePlotTypes();
		
		SetPlotTypes(plotTypes);
		GenerateCoasts();
	end

end

------------------------------------------------------------------------------
function GenerateTerrain()

	local MapShape = Map.GetCustomOption(12);
	local DesertPercent = 22;

	if MapShape == 2 or MapShape == 3 then
		DesertPercent = 28;
	end

	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local grassMoist = Map.GetCustomOption(7);

	local args = {
			temperature = temp,
			iDesertPercent = DesertPercent,
			iGrassMoist = grassMoist,
			};

	local terraingen = TerrainGenerator.Create(args);

	terrainTypes = terraingen:GenerateTerrain();
	
	SetTerrainTypes(terrainTypes);

	if MapShape == 1 then
		FixIslands();
	end
end

------------------------------------------------------------------------------
function FixIslands()
	--function to change some of the flat land tundra on islands to plains tiles
	local iW, iH = Map.GetGridSize();
	local biggest_area = Map.FindBiggestArea(False);
	local iAreaID = biggest_area:GetID();

	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = iW * y + x;
			local plot = Map.GetPlotByIndex(i);
			plotAreaID = plot:GetArea();
			if plotAreaID ~= iAreaID then
				local terrainType = plot:GetTerrainType();
				local plotType = plot:GetPlotType();

				if terrainType == TerrainTypes.TERRAIN_TUNDRA then
					if plotType ~= PlotTypes.PLOT_HILLS then
						--give a chance to turn this flat tundra to plains
						local tundratoplains = Map.Rand(100, "Plains Spwan Chance");
						if tundratoplains >= 30 then
							plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true);
						end
					end
				end
			end
		end
	end
end

------------------------------------------------------------------------------
function AddFeatures()

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(3)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rain}
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function StartPlotSystem()

	local MapShape = Map.GetCustomOption(12);
	local RegionalMethod = 1;

	if MapShape == 2 then
		RegionalMethod = 2;
	end

	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(15)
	local starts = Map.GetCustomOption(5)
	if starts == 7 then
		starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	end

	-- Handle coastal spawns and start bias
	local OnlyCoastal = true;
	local BalancedCoastal = false;
	local MixedBias = false;
		
	if Map.GetCustomOption(16) == 2 then
		BalancedCoastal = true;
	end
	
	if Map.GetCustomOption(16) == 3 then
		BalancedCoastal = true;
		MixedBias = true;
	end
	
	print("Creating start plot database.");
	local start_plot_database = AssignStartingPlots.Create()
	
	print("Dividing the map in to Regions.");
	-- Regional Division Method 1: Biggest Landmass
	local args = {
		method = RegionalMethod,
		start_locations = starts,
		resources = res,
		NoCoastInland = OnlyCoastal,
		BalancedCoastal = BalancedCoastal,
		MixedBias = MixedBias;
		};
	start_plot_database:GenerateRegions(args)

	print("Choosing start locations for civilizations.");
	start_plot_database:ChooseLocations()
	
	print("Normalizing start locations and assigning them to Players.");
	start_plot_database:BalanceAndAssign(args)

	print("Placing Natural Wonders.");
	local wonders = Map.GetCustomOption(6)
	if wonders == 14 then
		wonders = Map.Rand(13, "Number of Wonders To Spawn - Lua");
	else
		wonders = wonders - 1;
	end

	print("########## Wonders ##########");
	print("Natural Wonders To Place: ", wonders);

	local wonderargs = {
		wonderamt = wonders,
	};

	local LandSize = Map.GetCustomOption(13);

	if LandSize ~= 6 then --brawl no wonders please
		start_plot_database:PlaceNaturalWonders(wonderargs)
	end

	print("Placing Resources and City States.");
	start_plot_database:PlaceResourcesAndCityStates()
end
------------------------------------------------------------------------------