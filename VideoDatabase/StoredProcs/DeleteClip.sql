CREATE PROCEDURE [dbo].[DeleteClip]
	@ClipId INT
AS
BEGIN TRY
    BEGIN TRANSACTION

	DELETE FROM ClipLayers WHERE ClipId = @ClipId

    DELETE FROM Clip WHERE ClipId = @ClipId

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
