CREATE PROCEDURE [dbo].[ConfirmPendingUserCollections]
	@BuildId UNIQUEIDENTIFIER	
AS
BEGIN TRY
    BEGIN TRANSACTION
		DECLARE @DateNow DATETIME2 = GETUTCDATE();
		INSERT INTO [dbo].[UserCollection] (ResolutionId, LicenseId, DateCreated, CollectionId, UserObjectId) 
        (SELECT b.ResolutionId, b.LicenseId, @DateNow, uc.CollectionId, uc.UserObjectId FROM [dbo].[PendingUserCollection] uc 
        JOIN [dbo].[Build] b ON uc.BuildId = b.BuildId
        WHERE b.BuildId = @BuildId)

        DELETE FROM [dbo].[PendingUserCollection] WHERE BuildId = @BuildId
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
