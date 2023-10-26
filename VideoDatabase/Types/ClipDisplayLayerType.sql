CREATE TYPE [dbo].[ClipDisplayLayerType] AS TABLE
(
	[TempId] INT NOT NULL,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[Reverse] BIT NOT NULL,
	[FlipHorizontal] BIT NOT NULL,
	[FlipVertical] BIT NOT NULL,
	[FadeTypeId] TINYINT NULL,
	[Colour] CHAR(6) NULL,
	[Order] SMALLINT NOT NULL
)
