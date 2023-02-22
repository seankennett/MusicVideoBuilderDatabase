CREATE PROCEDURE [dbo].[GetVideos](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName FROM [Video] 
WHERE UserObjectId = @userObjectId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId

SELECT cu.ClipId, cu.[Order], cu.LayerId, l.LayerName FROM [dbo].[ClipLayers] cu
JOIN [dbo].[Layer] l ON cu.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cu.ClipId
WHERE c.UserObjectId = @userObjectId
