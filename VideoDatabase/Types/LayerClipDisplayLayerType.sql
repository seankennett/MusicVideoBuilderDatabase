CREATE TYPE [dbo].[LayerClipDisplayLayerType] AS TABLE
(
	[ClipDisplayLayerId] INT NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[ColourOverride] CHAR(6) NOT NULL
)
