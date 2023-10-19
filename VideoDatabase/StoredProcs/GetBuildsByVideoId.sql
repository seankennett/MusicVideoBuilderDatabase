CREATE PROCEDURE [dbo].[GetBuildsByVideoId](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT BuildId, BuildStatusId, LicenseId, ResolutionId, VideoId, VideoName, PaymentIntentId, FormatId, HasAudio, DateUpdated  FROM [dbo].[Build] WHERE UserObjectId = @userObjectId AND VideoId = @VideoId
