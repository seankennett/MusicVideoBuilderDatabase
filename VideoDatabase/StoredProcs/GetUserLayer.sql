CREATE PROCEDURE [dbo].[GetUserLayer](
@userObjectId UNIQUEIDENTIFIER,
@UserLayerId INT
)
AS

SELECT ul.[LayerId], ul.[UserLayerStatusId], ul.[UserLayerId], ul.[DateUpdated], l.[LayerTypeId], l.[LayerName] FROM [dbo].[UserLayer] ul JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId WHERE ul.UserObjectId = @userObjectId AND ul.UserLayerId = @UserLayerId
