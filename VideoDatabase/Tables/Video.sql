﻿CREATE TABLE [dbo].[Video]
(
	[VideoId] INT IDENTITY NOT NULL PRIMARY KEY,
	[VideoName] VARCHAR(50) NOT NULL,
	[BPM] TINYINT NOT NULL,
	[FormatId] TINYINT NOT NULL,
	[VideoDelayMilliseconds] INT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT FK_Video_Format FOREIGN KEY ([FormatId]) REFERENCES [dbo].[Format] ([FormatId])
)
