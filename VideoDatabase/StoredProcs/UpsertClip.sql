﻿CREATE PROCEDURE [dbo].[UpsertClip]
	@ClipId INT,
	@ClipName NVARCHAR(50),
	@BackgroundColour CHAR(6) NULL,
	@BeatLength TINYINT,
	@StartingBeat TINYINT,
	@ClipDisplayLayers [ClipDisplayLayerType] READONLY,
	@LayerClipDisplayLayers [LayerClipDisplayLayerType] READONLY,
	@userObjectId UNIQUEIDENTIFIER
AS
DECLARE @Map AS TABLE
(
	TempId int,
	InsertedId int
)
BEGIN TRY
    BEGIN TRANSACTION

	IF (@ClipId > 0)
	BEGIN
		UPDATE [Clip] SET ClipName = @ClipName, DateUpdated = GETUTCDATE(), BackgroundColour = @BackgroundColour, BeatLength = @BeatLength, StartingBeat = @StartingBeat WHERE ClipId = @ClipId;
		DELETE FROM [LayerClipDisplayLayers] WHERE ClipDisplayLayerId IN (SELECT ClipDisplayLayerId FROM [ClipDisplayLayers] WHERE ClipId = @ClipId)
		DELETE FROM [ClipDisplayLayers] WHERE ClipId = @ClipId;
	END
	ELSE
	BEGIN
		INSERT INTO [Clip] (ClipName, DateCreated, DateUpdated, BackgroundColour, BeatLength, StartingBeat, UserObjectId) VALUES (@ClipName, GETUTCDATE(), GETUTCDATE(), @BackgroundColour, @BeatLength, @StartingBeat, @userObjectId)
		SET @ClipId = SCOPE_IDENTITY();
	END

	MERGE INTO dbo.ClipDisplayLayers USING @ClipDisplayLayers AS source 
        ON 1 = 0 -- Always not matched
    WHEN NOT MATCHED THEN
        INSERT ([DisplayLayerId],
		[Order],
		[ClipId]
        )
        VALUES (source.[DisplayLayerId]
              , source.[Order]
              , @ClipId
        )
        OUTPUT source.TempId, Inserted.ClipDisplayLayerId 
        INTO @Map (TempId, InsertedId);

	INSERT INTO dbo.LayerClipDisplayLayers(
         ClipDisplayLayerId
       , ColourOverride
       , LayerId
    )
    SELECT m.InsertedId
         , lcd.ColourOverride
         , lcd.LayerId
    FROM @LayerClipDisplayLayers as lcd
    INNER JOIN @Map as m 
        ON(lcd.ClipDisplayLayerId = m.TempId);
	
	SELECT @ClipId

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
