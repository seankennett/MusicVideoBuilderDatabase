CREATE PROCEDURE [dbo].[GetLayerFinders]
AS

SELECT [LayerId], [LayerName], [LayerTypeId], [DateUpdated], (SELECT COUNT(*) FROM [dbo].[UserLayer] ul WHERE ul.LayerId = l.LayerId) as UserCount FROM [dbo].[Layer] l

SELECT lt.LayerId, t.TagName FROM [dbo].[LayerTags] lt JOIN [dbo].[Tag] t ON lt.TagId = t.TagId
