CREATE PROCEDURE [dbo].[InsertPendingUserCollections]
	@userObjectId UNIQUEIDENTIFIER,
	@BuildId UNIQUEIDENTIFIER,
	@Collections [GuidOrderType] READONLY	
AS
BEGIN TRY
    BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM [dbo].[PendingUserCollection] WHERE BuildId = @BuildId)
	BEGIN
		DECLARE @DateNow DATETIME2 = GETUTCDATE();
		INSERT INTO [dbo].[PendingUserCollection] (BuildId, DateCreated, CollectionId, UserObjectId) SELECT @BuildId, @DateNow, [ForeignId], @userObjectId FROM @Collections
	END

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
