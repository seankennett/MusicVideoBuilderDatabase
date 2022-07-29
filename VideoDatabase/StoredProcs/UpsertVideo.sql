CREATE PROCEDURE [dbo].[UpsertVideo]
	@VideoId INT,
	@VideoName NVARCHAR(50),
	@BPM TINYINT,
	@FormatId TINYINT,
	@Clips [IntOrderType] READONLY
AS
BEGIN TRY
    BEGIN TRANSACTION

	IF (@VideoId > 0)
	BEGIN
	UPDATE [Video] SET VideoName = @VideoName, BPM = @BPM, FormatId = @FormatId, VideoName = @VideoName, DateUpdated = GETUTCDATE() WHERE VideoId = @VideoId;
	DELETE FROM [VideoClips] WHERE VideoId = @VideoId;
	END
	ELSE
	BEGIN
	INSERT INTO [Video] (VideoName, BPM, FormatId, DateCreated, DateUpdated) VALUES (@VideoName, @BPM, @FormatId, GETUTCDATE(), GETUTCDATE())
	SET @VideoId = SCOPE_IDENTITY();
	END

	INSERT INTO [VideoClips] (VideoId, ClipId, [Order], DateCreated) SELECT @VideoId, [ForeignId], [Order], GETUTCDATE() FROM @Clips;
	
	SELECT @VideoId

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
