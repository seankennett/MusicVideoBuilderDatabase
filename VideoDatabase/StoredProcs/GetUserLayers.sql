CREATE PROCEDURE [dbo].[GetUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ul.[LayerId], ul.[UserLayerStatusId], ul.[UserLayerId], ul.[DateUpdated], l.[LayerTypeId] FROM [dbo].[UserLayers] ul JOIN [dbo].[Layer] l ON ul.LayerId = l.LayerId WHERE ul.UserObjectId = @userObjectId
