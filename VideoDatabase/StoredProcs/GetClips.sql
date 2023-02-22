CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, DateUpdated, BackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cu.ClipId, cu.LayerId, cu.[Order], l.LayerName FROM [dbo].[ClipLayers] cu
JOIN [dbo].[Layer] l ON cu.LayerId = l.LayerId
JOIN [dbo].[Clip] c ON c.ClipId = cu.ClipId
WHERE c.UserObjectId = @userObjectId