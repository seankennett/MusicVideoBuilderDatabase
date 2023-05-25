CREATE PROCEDURE [dbo].[GetVideo](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName FROM [Video]
WHERE UserObjectId = @userObjectId AND VideoId = @VideoId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId AND vc.VideoId = @VideoId

SELECT cd.ClipId, cd.[Order], cd.DisplayLayerId, co.CollectionName FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[DisplayLayer] d ON cd.DisplayLayerId = d.DisplayLayerId
JOIN [dbo].[Collection] co ON co.CollectionId = d.CollectionId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.DefaultColour, l.DisplayLayerId, lc.ColourOverride FROM [dbo].[Layer] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.DisplayLayerId = l.DisplayLayerId
LEFT JOIN [dbo].[LayerClipDisplayLayers] lc ON lc.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId
