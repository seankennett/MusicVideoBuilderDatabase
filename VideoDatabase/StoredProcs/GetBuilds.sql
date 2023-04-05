CREATE PROCEDURE [dbo].[GetBuilds](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId, VideoName, PaymentIntentId, FormatId, HasAudio, DateUpdated  FROM [dbo].[Build] WHERE UserObjectId = @userObjectId
