CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[FlipHorizontal], cd.[FlipVertical], cd.[Order], cd.ClipDisplayLayerId FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.Colour, l.ClipDisplayLayerId FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId