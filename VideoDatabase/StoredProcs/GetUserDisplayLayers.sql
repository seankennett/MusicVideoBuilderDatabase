CREATE PROCEDURE [dbo].[GetUserDisplayLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ud.UserDisplayLayerId, ud.[DisplayLayerId], ud.LicenseId, ud.ResolutionId, c.[CollectionName] FROM [dbo].[UserDisplayLayer] ud 
JOIN [dbo].[DisplayLayer] d ON ud.DisplayLayerId = d.DisplayLayerId 
JOIN [dbo].[Collection] c ON d.CollectionId = c.CollectionId
WHERE ud.UserObjectId = @userObjectId
