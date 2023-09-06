CREATE PROCEDURE [dbo].[GetDirections]
AS

SELECT DirectionId, DirectionName, IsTransition FROM [dbo].[Direction]
