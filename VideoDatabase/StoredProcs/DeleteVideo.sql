CREATE PROCEDURE [dbo].[DeleteVideo]
	@VideoId INT
AS
BEGIN TRY
    BEGIN TRANSACTION

	DELETE FROM VideoClips WHERE VideoId = @VideoId

    DELETE FROM Video WHERE VideoId = @VideoId

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
