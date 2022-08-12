CREATE TABLE [dbo].[Video]
(
	[VideoId] INT IDENTITY NOT NULL PRIMARY KEY,
	[VideoName] NVARCHAR(50) NOT NULL,
	[BPM] TINYINT NOT NULL,
	[FormatId] TINYINT NOT NULL,
	[AudioFileName] NVARCHAR(50) NULL,
	[VideoDelayMilliseconds] INT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_Video_Format FOREIGN KEY ([FormatId]) REFERENCES [dbo].[Format] ([FormatId])
)
