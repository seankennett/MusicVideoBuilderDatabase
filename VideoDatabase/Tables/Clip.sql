﻿CREATE TABLE [dbo].[Clip]
(
	[ClipId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipName] NVARCHAR(50) NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	[BackgroundColour] CHAR(6) NULL,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL
)
