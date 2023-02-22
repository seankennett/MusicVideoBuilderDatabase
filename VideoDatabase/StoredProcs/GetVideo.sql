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

SELECT cu.ClipId, cu.[Order], l.LayerId, l.LayerName FROM [dbo].[ClipLayers] cu
JOIN [dbo].[Layer] l ON cu.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cu.ClipId
WHERE c.UserObjectId = @userObjectId
