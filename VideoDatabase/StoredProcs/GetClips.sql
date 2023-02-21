CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, l.LayerName, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
JOIN [dbo].[Layer] l ON u.LayerId = l.LayerId
WHERE u.UserObjectId = @userObjectId