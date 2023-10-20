CREATE TABLE [dbo].[LayerCollectionDisplayLayers]
(
	[LayerId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[Colour] CHAR(6) NOT NULL,
	CONSTRAINT FK_LayerCollectionDisplayLayers_DisplayLayers FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer] ([DisplayLayerId]),
	CONSTRAINT FK_LayerCollectionDisplayLayers_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer] ([LayerId])
)
