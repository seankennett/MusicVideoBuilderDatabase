CREATE PROCEDURE [dbo].[UpdateUserLayer](
@userLayerId INT,
@userLayerStatusId TINYINT
)
AS
BEGIN TRY
    BEGIN TRANSACTION 
	UPDATE UserLayer SET UserLayerStatusId = @userLayerStatusId WHERE UserLayerId = @userLayerId
    SELECT * FROM [UserLayer] WHERE UserLayerId = @userLayerId
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
