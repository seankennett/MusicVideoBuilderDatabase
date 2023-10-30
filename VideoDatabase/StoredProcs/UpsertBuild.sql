CREATE PROCEDURE [dbo].[UpsertBuild]
	@BuildId UNIQUEIDENTIFIER,
	@VideoId INT,
	@VideoName VARCHAR(50),
	@BuildStatusId TINYINT,
	@ResolutionId TINYINT,
	@LicenseId TINYINT,
	@FormatId TINYINT,
	@UserObjectId UNIQUEIDENTIFIER,
	@PaymentIntentId VARCHAR(30) NULL,
	@HasAudio BIT
AS
BEGIN TRY
    BEGIN TRANSACTION

	DECLARE @DateNow DATETIME2 = GETUTCDATE();
	IF EXISTS (SELECT BuildId FROM [dbo].[Build] WHERE BuildId = @BuildId)
	BEGIN
		UPDATE [dbo].[Build] SET BuildStatusId = @BuildStatusId, HasAudio = @HasAudio, DateUpdated = @DateNow, VideoName = @VideoName, FormatId = @FormatId WHERE BuildId = @BuildId
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Build] (BuildId, VideoId, BuildStatusId, ResolutionId, LicenseId, UserObjectId, PaymentIntentId, HasAudio, DateCreated, DateUpdated, VideoName, FormatId) VALUES (@BuildId, @VideoId, @BuildStatusId, @ResolutionId, @LicenseId, @UserObjectId, @PaymentIntentId, @HasAudio, @DateNow, @DateNow, @VideoName, @FormatId)
	END

	COMMIT
	END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
