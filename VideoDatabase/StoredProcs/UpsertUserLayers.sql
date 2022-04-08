CREATE PROCEDURE [dbo].[UpsertUserLayers](
@UserLayers [UserLayersType] READONLY
)
AS
BEGIN TRY
    BEGIN TRANSACTION 
	MERGE [UserLayers] AS TARGET
	USING @UserLayers AS SOURCE
	ON SOURCE.LayerId = TARGET.LayerId AND SOURCE.UserObjectId = TARGET.UserObjectId
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (LayerId, UserLayerStatusId, UserObjectId, DateCreated, DateUpdated) VALUES (SOURCE.LayerId, SOURCE.UserLayerStatusId, SOURCE.UserObjectId, GETUTCDATE(), GETUTCDATE())
	WHEN MATCHED THEN
		UPDATE SET TARGET.UserLayerStatusId = SOURCE.UserLayerStatusId, TARGET.DateUpdated = GETUTCDATE()
	OUTPUT INSERTED.*;

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
