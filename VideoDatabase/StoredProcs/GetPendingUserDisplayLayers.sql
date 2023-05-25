CREATE PROCEDURE [dbo].[GetPendingUserDisplayLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ud.PendingUserDisplayLayerId AS UserDisplayLayerId, ud.[DisplayLayerId], b.LicenseId, b.ResolutionId, co.[CollectionName] FROM [dbo].[PendingUserDisplayLayer] ud 
JOIN [dbo].[DisplayLayer] d ON d.DisplayLayerId = ud.DisplayLayerId 
JOIN [dbo].[Collection] co ON d.CollectionId = co.CollectionId 
JOIN [dbo].[Build] b ON ud.BuildId = b.BuildId
WHERE ud.UserObjectId = @userObjectId
