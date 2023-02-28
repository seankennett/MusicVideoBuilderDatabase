CREATE PROCEDURE [dbo].[GetBuilds](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId, PaymentIntentId, HasAudio, DateUpdated  FROM [dbo].[Build] WHERE UserObjectId = @userObjectId
