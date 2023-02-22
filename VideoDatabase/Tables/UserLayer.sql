CREATE TABLE [dbo].[UserLayer]
(
	[UserLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[ResolutionId] TINYINT NOT NULL,
	[LicenseId] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_UserLayer_Resolution FOREIGN KEY ([ResolutionId]) REFERENCES [dbo].[Resolution]([ResolutionId]),
	CONSTRAINT FK_UserLayer_License FOREIGN KEY ([LicenseId]) REFERENCES [dbo].[License]([LicenseId])
)
