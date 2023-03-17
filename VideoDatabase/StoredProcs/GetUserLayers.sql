CREATE PROCEDURE [dbo].[GetUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ul.UserLayerId, ul.[LayerId], b.LicenseId, b.ResolutionId, l.[LayerName] FROM [dbo].[UserLayer] ul 
JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId 
JOIN [dbo].[Build] b ON ul.BuildId = b.BuildId
WHERE ul.UserObjectId = @userObjectId
