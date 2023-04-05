CREATE PROCEDURE [dbo].[GetUserBuild](
@BuildId UNIQUEIDENTIFIER
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId, PaymentIntentId, HasAudio, DateUpdated, UserObjectId, VideoName, FormatId  FROM [dbo].[Build] WHERE BuildId = @BuildId
