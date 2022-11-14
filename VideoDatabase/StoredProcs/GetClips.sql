CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE u.UserObjectId = @userObjectId