CREATE PROCEDURE [dbo].[CleanUpBuilds]
AS
	
DELETE FROM [dbo].[Build] WHERE DateUpdated < DATEADD(DAY, -7, GETUTCDATE())
