CREATE PROCEDURE [dbo].[GetUserBuildByPaymentIntentId](
@PaymentIntentId VARCHAR(30)
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId, PaymentIntentId, HasAudio, DateUpdated, UserObjectId  FROM [dbo].[Build] WHERE PaymentIntentId = @PaymentIntentId
