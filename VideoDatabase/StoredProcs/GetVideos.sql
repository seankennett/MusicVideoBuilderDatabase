CREATE PROCEDURE [dbo].[GetVideos](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName FROM [Video] 
WHERE UserObjectId = @userObjectId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId

SELECT cu.ClipId, cu.[Order], cu.DisplayLayerId, co.CollectionName FROM [dbo].[ClipDisplayLayers] cu
JOIN [dbo].[DisplayLayer] d ON cu.DisplayLayerId = d.DisplayLayerId
JOIN [dbo].[Collection] co ON d.CollectionId = co.CollectionId
JOIN [dbo].[Clip] c ON c.ClipId = cu.ClipId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.DefaultColour, l.DisplayLayerId, lc.ColourOverride FROM [dbo].[Layer] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.DisplayLayerId = l.DisplayLayerId
LEFT JOIN [dbo].[LayerClipDisplayLayers] lc ON lc.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId
