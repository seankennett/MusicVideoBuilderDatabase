CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat FROM [Clip]
WHERE ClipId = @ClipId AND UserObjectId = @userObjectId

SELECT cd.ClipId, cd.[Order], d.DisplayLayerId, co.CollectionName FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[DisplayLayer] d ON cd.DisplayLayerId = d.DisplayLayerId
JOIN [dbo].[Collection] co ON co.CollectionId = d.CollectionId
WHERE [cd].[ClipId] = @ClipId

SELECT l.LayerId, l.DefaultColour, l.DisplayLayerId, lc.ColourOverride FROM [dbo].[Layer] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.DisplayLayerId = l.DisplayLayerId
LEFT JOIN [dbo].[LayerClipDisplayLayers] lc ON lc.LayerId = l.LayerId
WHERE [cd].[ClipId] = @ClipId

