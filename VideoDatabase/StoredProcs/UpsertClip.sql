CREATE PROCEDURE [dbo].[UpsertClip]
	@ClipId INT,
	@ClipName NVARCHAR(50),
	@BackgroundColour CHAR(6) NULL,
	@BeatLength TINYINT,
	@StartingBeat TINYINT,
	@UserLayers [IntOrderType] READONLY,
	@userObjectId UNIQUEIDENTIFIER
AS
BEGIN TRY
    BEGIN TRANSACTION

	IF (@ClipId > 0)
	BEGIN
	UPDATE [Clip] SET ClipName = @ClipName, DateUpdated = GETUTCDATE(), BackgroundColour = @BackgroundColour, BeatLength = @BeatLength, StartingBeat = @StartingBeat WHERE ClipId = @ClipId;
	DELETE FROM [ClipUserLayers] WHERE ClipId = @ClipId;
	END
	ELSE
	BEGIN
	INSERT INTO [Clip] (ClipName, DateCreated, DateUpdated, BackgroundColour, BeatLength, StartingBeat, UserObjectId) VALUES (@ClipName, GETUTCDATE(), GETUTCDATE(), @BackgroundColour, @BeatLength, @StartingBeat, @userObjectId)
	SET @ClipId = SCOPE_IDENTITY();
	END

	INSERT INTO [ClipUserLayers] (ClipId, UserLayerId, [Order], DateCreated) SELECT @ClipId, [ForeignId], [Order], GETUTCDATE() FROM @UserLayers;
	
	SELECT @ClipId

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
