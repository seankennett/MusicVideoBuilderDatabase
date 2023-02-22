﻿CREATE TABLE [dbo].[Build]
(
	[BuildId] INT IDENTITY NOT NULL PRIMARY KEY,
	[VideoId] INT NOT NULL,
	[BuildStatusId] TINYINT NOT NULL,
	[ResolutionId] TINYINT NOT NULL,
	[LicenseId] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL
	CONSTRAINT FK_Build_Resolution FOREIGN KEY ([ResolutionId]) REFERENCES [dbo].[Resolution]([ResolutionId]),
	CONSTRAINT FK_Build_License FOREIGN KEY ([LicenseId]) REFERENCES [dbo].[License]([LicenseId]),
	CONSTRAINT FK_Build_Video FOREIGN KEY ([VideoId]) REFERENCES [dbo].[Video]([VideoId]),
	CONSTRAINT FK_Build_BuildStatus FOREIGN KEY ([BuildStatusId]) REFERENCES [dbo].[BuildStatus]([BuildStatusId])

)
