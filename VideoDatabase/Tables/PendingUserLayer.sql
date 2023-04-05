CREATE TABLE [dbo].[PendingUserLayer]
(
	[PendingUserLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[BuildId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_PendingUserLayer_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer]([LayerId]),
	CONSTRAINT FK_PendingUserLayer_Build FOREIGN KEY ([BuildId]) REFERENCES [dbo].[Build]([BuildId])
)
