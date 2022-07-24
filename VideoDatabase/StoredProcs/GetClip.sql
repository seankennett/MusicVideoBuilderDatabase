CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT DISTINCT c.ClipId, c.ClipName, c.DateUpdated FROM [Clip] c 
JOIN [ClipUserLayers] cu ON c.ClipId = cu.ClipId
JOIN [UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE c.ClipId = @ClipId AND u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE [cu].[ClipId] = @ClipId AND u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1
