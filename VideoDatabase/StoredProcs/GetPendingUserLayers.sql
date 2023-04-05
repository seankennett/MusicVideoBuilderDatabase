CREATE PROCEDURE [dbo].[GetPendingUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ul.PendingUserLayerId AS UserLayerId, ul.[LayerId], b.LicenseId, b.ResolutionId, l.[LayerName] FROM [dbo].[PendingUserLayer] ul 
JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId 
JOIN [dbo].[Build] b ON ul.BuildId = b.BuildId
WHERE ul.UserObjectId = @userObjectId
