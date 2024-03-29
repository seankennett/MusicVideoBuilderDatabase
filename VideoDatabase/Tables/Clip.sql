﻿CREATE TABLE [dbo].[Clip]
(
	[ClipId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipName] VARCHAR(50) NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	[BackgroundColour] CHAR(6) NULL,
	[EndBackgroundColour] CHAR(6) NULL,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL, 
    [BeatLength] TINYINT NOT NULL,
    [StartingBeat] TINYINT NOT NULL
)
