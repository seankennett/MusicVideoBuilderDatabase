CREATE TABLE [dbo].[PendingUserDisplayLayer]
(
	[PendingUserDisplayLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[BuildId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_PendingUserLayer_DisplayLayer FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer]([DisplayLayerId]),
	CONSTRAINT FK_PendingUserLayer_Build FOREIGN KEY ([BuildId]) REFERENCES [dbo].[Build]([BuildId])
)
