CREATE PROCEDURE [dbo].[InsertLayer]
	@LayerId UNIQUEIDENTIFIER,
	@LayerName NVARCHAR(50),
	@Tags [TagsType] READONLY,
	@LayerTypeId TINYINT,
	@AuthorObjectId UNIQUEIDENTIFIER
AS
BEGIN TRY
    BEGIN TRANSACTION 
	DECLARE @TagIds TABLE (TagId INT);
	INSERT INTO [Layer] (LayerId, LayerName, LayerTypeId, DateCreated, DateUpdated, AuthorObjectId) VALUES 	(@LayerId, @LayerName, @LayerTypeId, GETUTCDATE(), GETUTCDATE(), @AuthorObjectId);

	MERGE [Tag] AS TARGET
	USING @Tags AS SOURCE
	ON SOURCE.TagName = TARGET.TagName
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (TagName) VALUES (SOURCE.TagName)
	WHEN MATCHED THEN
		UPDATE SET TARGET.TagName = SOURCE.TagName
	OUTPUT inserted.TagId INTO @TagIds;

	INSERT INTO [LayerTags] (LayerId, TagId) SELECT @LayerId, TagId FROM @TagIds;
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
