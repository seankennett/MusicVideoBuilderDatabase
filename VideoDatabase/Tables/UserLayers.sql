CREATE TABLE [dbo].[UserLayers]
(
	[UserLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserId] INT NOT NULL,
	[LayerId] INT NOT NULL,
	[UserLayerStatusId] TINYINT NOT NULL,
	CONSTRAINT FK_UserLayers_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer]([LayerId]),
	CONSTRAINT FK_UserLayers_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[User]([UserId]),
	CONSTRAINT FK_UserLayers_UserLayerStatus FOREIGN KEY ([UserLayerStatusId]) REFERENCES [dbo].[UserLayerStatus]([UserLayerStatusId]),
	CONSTRAINT UQ_UserLayers_UserId_LayerId UNIQUE ([UserId], [LayerId])
)
