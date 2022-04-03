CREATE PROCEDURE [dbo].[GetLayers]
(
@userObjectId UNIQUEIDENTIFIER
)
AS
	
SELECT l.[LayerId], l.[LayerName], l.[LayerTypeId], l.[DateUpdated], ul.UserLayerStatusId  FROM [dbo].[Layer] l LEFT JOIN (SELECT * FROM [dbo].[UserLayers] WHERE UserObjectId = @userObjectId) ul ON l.LayerId = ul.LayerId

SELECT lt.LayerId, t.TagId, t.TagName FROM [dbo].[LayerTags] lt JOIN [dbo].[Tag] t ON lt.TagId = t.TagId
