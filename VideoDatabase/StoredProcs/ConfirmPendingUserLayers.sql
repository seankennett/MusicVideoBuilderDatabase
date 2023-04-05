CREATE PROCEDURE [dbo].[ConfirmPendingUserLayers]
	@BuildId UNIQUEIDENTIFIER	
AS
BEGIN TRY
    BEGIN TRANSACTION
		DECLARE @DateNow DATETIME2 = GETUTCDATE();
		INSERT INTO [dbo].[UserLayer] (ResolutionId, LicenseId, DateCreated, LayerId, UserObjectId) 
        (SELECT b.ResolutionId, b.LicenseId, @DateNow, ul.LayerId, ul.UserObjectId FROM [dbo].[PendingUserLayer] ul 
        JOIN [dbo].[Build] b ON ul.BuildId = b.BuildId
        WHERE b.BuildId = @BuildId)

        DELETE FROM [dbo].[PendingUserLayer] WHERE BuildId = @BuildId
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
