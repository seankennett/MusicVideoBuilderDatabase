CREATE PROCEDURE [dbo].UpdateVideoIsBuilding
	@VideoId INT,
	@IsBuilding BIT
AS
BEGIN TRY
    BEGIN TRANSACTION

	UPDATE [Video] SET IsBuilding = @IsBuilding WHERE VideoId = @VideoId

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
