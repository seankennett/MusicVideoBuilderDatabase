CREATE PROCEDURE [dbo].[GetVideos](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName, IsBuilding FROM [Video] 
WHERE UserObjectId = @userObjectId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE u.UserObjectId = @userObjectId
