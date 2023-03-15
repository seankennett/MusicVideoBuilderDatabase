CREATE PROCEDURE [dbo].[InsertUserLayers]
	@userObjectId UNIQUEIDENTIFIER,
	@BuildId UNIQUEIDENTIFIER,
	@Layers [GuidOrderType] READONLY	
AS
BEGIN TRY
    BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM [dbo].[UserLayer] WHERE BuildId = @BuildId)
	BEGIN
		DECLARE @DateNow DATETIME2 = GETUTCDATE();
		INSERT INTO [dbo].[UserLayer] (BuildId, DateCreated, LayerId, UserObjectId) SELECT @BuildId, @DateNow, [ForeignId], @userObjectId FROM @Layers
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
