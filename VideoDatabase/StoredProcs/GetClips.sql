CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Order], co.CollectionName FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[DisplayLayer] d ON cd.DisplayLayerId = d.DisplayLayerId
JOIN [dbo].[Collection] co ON co.CollectionId = d.CollectionId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.DefaultColour, l.DisplayLayerId, lc.ColourOverride FROM [dbo].[Layer] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.DisplayLayerId = l.DisplayLayerId
LEFT JOIN [dbo].[LayerClipDisplayLayers] lc ON lc.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId