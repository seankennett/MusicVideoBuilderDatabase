CREATE TABLE [dbo].[ClipDisplayLayers]
(
	[ClipDisplayLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipId] INT NOT NULL,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[Reverse] BIT NOT NULL,
	[Order] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_ClipDisplayLayers_Clip FOREIGN KEY ([ClipId]) REFERENCES [dbo].[Clip] ([ClipId]),
	CONSTRAINT FK_ClipDisplayLayers_DisplayLayer FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer] ([DisplayLayerId]),
	CONSTRAINT UQ_ClipDisplayLayers_ClipId_DisplayLayerId UNIQUE ([ClipId], [DisplayLayerId])
)
