﻿CREATE PROCEDURE [dbo].[UpsertClip]
	@ClipId INT,
	@ClipName NVARCHAR(50),
	@UserLayers [IntOrderType] READONLY
AS
BEGIN TRY
    BEGIN TRANSACTION
	IF (@ClipId > 0)
	BEGIN
	UPDATE [Clip] SET ClipName = @ClipName, DateUpdated = GETUTCDATE() WHERE ClipId = @ClipId;
	DELETE FROM [ClipUserLayers] WHERE ClipId = @ClipId;
	END
	ELSE
	BEGIN
	INSERT INTO [Clip] (ClipName, DateCreated, DateUpdated) OUTPUT INSERTED.ClipId INTO @ClipId VALUES (@ClipName, GETUTCDATE(), GETUTCDATE())
	END

	INSERT INTO [ClipUserLayers] (ClipId, UserLayerId, [Order], DateCreated) SELECT @ClipId, [ForeignId], [Order], GETUTCDATE() FROM @UserLayers;
	
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
