CREATE PROCEDURE [dbo].[CleanUpBuilds]
AS

DECLARE @SevenDaysAgo SMALLDATETIME = DATEADD(DAY, -7, GETUTCDATE())

DELETE FROM [dbo].[PendingUserDisplayLayer] WHERE BuildId IN (SELECT BuildId FROM [dbo].[Build] WHERE DateUpdated < @SevenDaysAgo)
	
DELETE FROM [dbo].[Build] WHERE DateUpdated < @SevenDaysAgo
