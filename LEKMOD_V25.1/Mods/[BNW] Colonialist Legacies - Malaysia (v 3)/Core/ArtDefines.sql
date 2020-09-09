--==========================================================================================================================
-- ARTDEFINES
--==========================================================================================================================	
-- ArtDefine_StrategicView
------------------------------
INSERT INTO ArtDefine_LandmarkTypes
			(Type,							LandmarkType,	FriendlyName)
VALUES		('ART_DEF_IMPROVEMENT_CL_KAMPUNG', 'Improvement',	'Kampung');
------------------------------
-- ArtDefine_StrategicView
------------------------------
INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 1,  'ART_DEF_IMPROVEMENT_CL_KAMPUNG', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Water Village HB.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed', 1,  'ART_DEF_IMPROVEMENT_CL_KAMPUNG', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Water Village B.fxsxml', 1 UNION ALL
SELECT 'Any', 'Pillaged', 1,  'ART_DEF_IMPROVEMENT_CL_KAMPUNG', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Water Village PL.fxsxml', 1;
------------------------------
-- ArtDefine_StrategicView
------------------------------
INSERT INTO ArtDefine_StrategicView 
			(StrategicViewType, 				TileType,	Asset)
VALUES		('ART_DEF_IMPROVEMENT_CL_KAMPUNG', 	'Improvement', 	'sv_Kampung.dds');
------------------------------
-- IconTextureAtlases
------------------------------
INSERT INTO IconTextureAtlases 
			(Atlas, 						IconSize, 	Filename, 							IconsPerRow, 	IconsPerColumn)
VALUES		('CL_KAMPUNG_ATLAS', 			256, 		'KampungIcon256.dds',				1, 				2),
			('CL_KAMPUNG_ATLAS', 			64, 		'KampungIcon64.dds',				1, 				2),
			('CL_KAMPUNG_ATLAS', 			45, 		'KampungIcon45.dds',				1, 				2);
--==========================================================================================================================	
--==========================================================================================================================	
