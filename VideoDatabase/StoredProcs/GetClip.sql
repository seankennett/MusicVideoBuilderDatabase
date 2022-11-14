CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat FROM [Clip]
WHERE ClipId = @ClipId AND UserObjectId = @userObjectId

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE [cu].[ClipId] = @ClipId AND u.UserObjectId = @userObjectId

