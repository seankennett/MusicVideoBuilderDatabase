CREATE PROCEDURE [dbo].[GetBuilds](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId  FROM [dbo].[Build] WHERE UserObjectId = @userObjectId
