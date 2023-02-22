CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat FROM [Clip]
WHERE ClipId = @ClipId AND UserObjectId = @userObjectId

SELECT cu.ClipId, cu.[Order], l.LayerId, l.LayerName FROM [dbo].[ClipLayers] cu
JOIN [dbo].[Layer] l ON cu.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cu.ClipId
WHERE [cu].[ClipId] = @ClipId AND c.UserObjectId = @userObjectId

