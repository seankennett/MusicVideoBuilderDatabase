CREATE PROCEDURE [dbo].[GetCollections]
AS

SELECT CollectionId, CollectionName, CollectionTypeId FROM [dbo].[Collection]

SELECT [DisplayLayerId], [CollectionId], [DirectionId], [NumberOfSides], [LinkedPreviousDisplayLayerId], [DateCreated] FROM [dbo].[DisplayLayer]

SELECT [LayerId], [DisplayLayerId], [IsOverlay], [DateCreated], [Order] FROM [dbo].[Layer]

SELECT [CollectionId], [DisplayLayerId] FROM [dbo].[CollectionDisplayLayer]

SELECT [DisplayLayerId], [LayerId], [Colour] FROM [dbo].[LayerCollectionDisplayLayers]