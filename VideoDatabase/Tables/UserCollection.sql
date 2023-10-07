CREATE TABLE [dbo].[UserCollection]
(
	[UserCollectionId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[CollectionId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[ResolutionId] TINYINT NOT NULL,
	[LicenseId] TINYINT NOT NULL,
	CONSTRAINT FK_UserCollection_Resolution FOREIGN KEY ([ResolutionId]) REFERENCES [dbo].[Resolution]([ResolutionId]),    
    CONSTRAINT FK_UserCollection_License FOREIGN KEY ([LicenseId]) REFERENCES [dbo].[License]([LicenseId]),
	CONSTRAINT FK_UserCollection_Collection FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection]([CollectionId])
)
