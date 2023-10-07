CREATE PROCEDURE [dbo].[GetPendingUserCollections](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT uc.PendingUserCollectionId AS UserCollectionId, uc.[CollectionId], b.LicenseId, b.ResolutionId, co.[CollectionName] FROM [dbo].[PendingUserCollection] uc 
JOIN [dbo].[Collection] co ON uc.CollectionId = co.CollectionId 
JOIN [dbo].[Build] b ON uc.BuildId = b.BuildId
WHERE uc.UserObjectId = @userObjectId
