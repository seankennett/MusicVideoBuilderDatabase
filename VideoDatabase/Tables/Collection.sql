CREATE TABLE [dbo].[Collection]
(
	[CollectionId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[CollectionName] NVARCHAR(50) NOT NULL,
	[CollectionTypeId] TINYINT NOT NULL,
	[AuthorObjectId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_Collection_CollectionType FOREIGN KEY ([CollectionTypeId]) REFERENCES [dbo].[CollectionType]([CollectionTypeId])
)
