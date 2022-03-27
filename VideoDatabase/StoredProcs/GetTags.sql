CREATE PROCEDURE [dbo].[GetTags]
AS
	
SELECT [TagId], [TagName] FROM [dbo].[Tag]
RETURN;
GO
