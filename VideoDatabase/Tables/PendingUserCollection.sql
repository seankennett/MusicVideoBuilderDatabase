CREATE TABLE [dbo].[PendingUserCollection]
(
	[PendingUserCollectionId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[CollectionId] UNIQUEIDENTIFIER NOT NULL,
	[BuildId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_PendingUserCollection_Collection FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection]([CollectionId]),
	CONSTRAINT FK_PendingUserCollection_Build FOREIGN KEY ([BuildId]) REFERENCES [dbo].[Build]([BuildId])
)
