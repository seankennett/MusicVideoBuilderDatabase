CREATE PROCEDURE [dbo].[GetCollections]
AS

SELECT CollectionId, CollectionName, CollectionTypeId FROM [dbo].[Collection]

SELECT [DisplayLayerId], [CollectionId], [IsCollectionDefault],	[DirectionId], [NumberOfSides],	[LinkedPreviousDisplayLayerId],	[DateCreated] FROM [dbo].[DisplayLayer]

SELECT [LayerId], [DisplayLayerId],	[DefaultColour], [IsOverlay], [DateCreated], [Order] FROM [dbo].[Layer]