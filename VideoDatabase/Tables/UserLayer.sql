CREATE TABLE [dbo].[UserLayer]
(
	[UserLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[UserLayerStatusId] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_UserLayers_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer]([LayerId]),
	CONSTRAINT FK_UserLayers_UserLayerStatus FOREIGN KEY ([UserLayerStatusId]) REFERENCES [dbo].[UserLayerStatus]([UserLayerStatusId]),
	CONSTRAINT UQ_UserLayers_UserId_LayerId UNIQUE ([UserObjectId], [LayerId])
)
