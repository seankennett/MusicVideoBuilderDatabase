CREATE TYPE [dbo].[LayerClipDisplayLayerType] AS TABLE
(
	[ClipDisplayLayerId] INT NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[Colour] CHAR(6) NOT NULL
)
