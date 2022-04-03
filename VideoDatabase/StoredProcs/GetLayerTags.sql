CREATE PROCEDURE [dbo].[GetLayerTags]
(
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT [TagId], [TagName] FROM [dbo].[Tag]

SELECT lt.[LayerId], lt.[TagId], l.[LayerName], l.[LayerTypeId], l.[DateUpdated], ul.[UserLayerStatusId]  FROM [dbo].[LayerTags] lt 
INNER JOIN [dbo].[Layer] l ON l.[LayerId] = lt.[LayerId] 
LEFT JOIN (SELECT [UserLayerStatusId], [LayerId] FROM [dbo].[UserLayers] WHERE [UserObjectId] = @userObjectId) ul ON l.[LayerId] = ul.[LayerId]
