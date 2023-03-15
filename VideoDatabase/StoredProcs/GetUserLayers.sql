CREATE PROCEDURE [dbo].[GetUserLayersByBuildStatus](
@userObjectId UNIQUEIDENTIFIER,
@BuildStatusId TINYINT
)
AS

SELECT ul.UserLayerId, ul.[LayerId], b.LicenseId, b.ResolutionId, l.[LayerName] FROM [dbo].[UserLayer] ul 
JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId 
JOIN [dbo].[Build] b ON ul.BuildId = b.BuildId
WHERE ul.UserObjectId = @userObjectId AND b.BuildStatusId = @BuildStatusId
