CREATE PROCEDURE [dbo].[GetLayers]
AS

SELECT [LayerId], [LayerName], [LayerTypeId], [DateUpdated] FROM [dbo].[Layer]

SELECT lt.LayerId, t.TagName FROM [dbo].[LayerTags] lt JOIN [dbo].[Tag] t ON lt.TagId = t.TagId
