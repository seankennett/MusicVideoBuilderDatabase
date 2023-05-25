CREATE TABLE [dbo].[UserDisplayLayer]
(
	[UserDisplayLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[ResolutionId] TINYINT NOT NULL,
	[LicenseId] TINYINT NOT NULL,
	CONSTRAINT FK_UserLayer_Resolution FOREIGN KEY ([ResolutionId]) REFERENCES [dbo].[Resolution]([ResolutionId]),    
    CONSTRAINT FK_UserLayer_License FOREIGN KEY ([LicenseId]) REFERENCES [dbo].[License]([LicenseId]),
	CONSTRAINT FK_UserLayer_DisplayLayer FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer]([DisplayLayerId])
)
