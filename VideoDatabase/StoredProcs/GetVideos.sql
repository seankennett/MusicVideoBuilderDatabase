CREATE PROCEDURE [dbo].[GetVideos](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT DISTINCT v.BPM, v.DateUpdated, v.FormatId, v.VideoName FROM [Video] v
JOIN [VideoClips] vc ON v.VideoId = vc.VideoId
JOIN [ClipUserLayers] cu ON cu.ClipId = vc.ClipId
JOIN [UserLayer] u ON u.UserLayerId = cu.UserLayerId
WHERE u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName FROM [VideoClips] vc
JOIN [Clip] c ON c.ClipId = vc.ClipId
JOIN [ClipUserLayers] cu ON c.ClipId = cu.ClipId
JOIN [UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1
