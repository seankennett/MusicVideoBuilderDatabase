CREATE TABLE [dbo].[LayerClipDisplayLayers]
(
	[LayerClipDisplayLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipDisplayLayerId] INT NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[Colour] CHAR(6) NOT NULL,
	[EndColour] CHAR(6) NULL,
	CONSTRAINT FK_LayerClipDisplayLayers_ClipDisplayLayers FOREIGN KEY ([ClipDisplayLayerId]) REFERENCES [dbo].[ClipDisplayLayers] ([ClipDisplayLayerId]),
	CONSTRAINT FK_LayerClipDisplayLayers_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer] ([LayerId])
)
