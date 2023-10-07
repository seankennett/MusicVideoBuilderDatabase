CREATE PROCEDURE [dbo].[GetUserCollections](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT uc.UserCollectionId, uc.[CollectionId], uc.LicenseId, uc.ResolutionId FROM [dbo].[UserCollection] uc
WHERE uc.UserObjectId = @userObjectId
