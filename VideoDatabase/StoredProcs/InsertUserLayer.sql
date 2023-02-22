﻿--CREATE PROCEDURE [dbo].[InsertUserLayer](
--@userObjectId UNIQUEIDENTIFIER,
--@layerId UNIQUEIDENTIFIER,
--@userLayerStatusId TINYINT
--)
--AS
--BEGIN TRY
--    BEGIN TRANSACTION 
--	INSERT INTO [UserLayer] (DateCreated, DateUpdated, LayerId, UserLayerStatusId, UserObjectId) VALUES (GETUTCDATE(), GETUTCDATE(), @layerId, @userLayerStatusId, @userObjectId);
--    SELECT * FROM [UserLayer] WHERE UserLayerId = SCOPE_IDENTITY();

--	COMMIT
--	END TRY
--BEGIN CATCH
--    IF @@TRANCOUNT > 0
--        ROLLBACK TRAN

--        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
--        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
--        DECLARE @ErrorState INT = ERROR_STATE()
--    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
--END CATCH
