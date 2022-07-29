CREATE TABLE [dbo].[VideoClips]
(
	[VideoClipId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipId] INT NOT NULL,
	[VideoId] INT NOT NULL,
	[Order] INT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_VideoClips_Clip FOREIGN KEY ([ClipId]) REFERENCES [dbo].[Clip] ([ClipId]),
	CONSTRAINT FK_VideoClips_Video FOREIGN KEY ([VideoId]) REFERENCES [dbo].[Video] ([VideoId]),
	CONSTRAINT UQ_VideoClips_ClipId_VideoId_Order UNIQUE ([ClipId], [VideoId], [Order])
)
