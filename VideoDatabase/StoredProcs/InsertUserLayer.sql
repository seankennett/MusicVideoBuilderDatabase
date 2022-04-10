CREATE PROCEDURE [dbo].[InsertUserLayer](
@userObjectId UNIQUEIDENTIFIER,
@layerId UNIQUEIDENTIFIER,
@userLayerStatusId TINYINT
)
AS
BEGIN TRY
    BEGIN TRANSACTION 
	INSERT INTO UserLayers (DateCreated, DateUpdated, LayerId, UserLayerStatusId, UserObjectId) OUTPUT Inserted.* VALUES (GETUTCDATE(), GETUTCDATE(), @layerId, @userLayerStatusId, @userObjectId)

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
