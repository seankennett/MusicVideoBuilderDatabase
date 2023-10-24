CREATE PROCEDURE [dbo].[GetClipsByVideoId](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT DISTINCT ClipId 
INTO #Clips
FROM VideoClips
WHERE VideoId = @VideoId

SELECT ClipId, ClipName, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId AND ClipId IN (SELECT ClipId FROM #Clips)

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[FlipHorizontal], cd.[FlipVertical], cd.[Order], cd.ClipDisplayLayerId FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId AND c.ClipId IN (SELECT ClipId FROM #Clips)

SELECT l.LayerId, l.Colour, l.ClipDisplayLayerId FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId AND c.ClipId IN (SELECT ClipId FROM #Clips)