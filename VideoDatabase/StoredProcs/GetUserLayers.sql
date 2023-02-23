CREATE PROCEDURE [dbo].[GetUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ul.UserLayerId, ul.[LayerId], ul.LicenseId, ul.ResolutionId, l.[LayerName] FROM [dbo].[UserLayer] ul JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId WHERE ul.UserObjectId = @userObjectId
