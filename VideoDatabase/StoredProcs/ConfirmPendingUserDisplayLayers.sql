CREATE PROCEDURE [dbo].[ConfirmPendingUserDisplayLayers]
	@BuildId UNIQUEIDENTIFIER	
AS
BEGIN TRY
    BEGIN TRANSACTION
		DECLARE @DateNow DATETIME2 = GETUTCDATE();
		INSERT INTO [dbo].[UserDisplayLayer] (ResolutionId, LicenseId, DateCreated, DisplayLayerId, UserObjectId) 
        (SELECT b.ResolutionId, b.LicenseId, @DateNow, ul.DisplayLayerId, ul.UserObjectId FROM [dbo].[PendingUserDisplayLayer] ul 
        JOIN [dbo].[Build] b ON ul.BuildId = b.BuildId
        WHERE b.BuildId = @BuildId)

        DELETE FROM [dbo].[PendingUserDisplayLayer] WHERE BuildId = @BuildId
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
