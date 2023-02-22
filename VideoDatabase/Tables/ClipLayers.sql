CREATE TABLE [dbo].[ClipLayers]
(
	[ClipLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipId] INT NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[Order] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_ClipLayers_Clip FOREIGN KEY ([ClipId]) REFERENCES [dbo].[Clip] ([ClipId]),
	CONSTRAINT FK_ClipLayers_Layers FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer] ([LayerId]),
	CONSTRAINT UQ_ClipLayers_ClipId_LayerId UNIQUE ([ClipId], [LayerId])
)
