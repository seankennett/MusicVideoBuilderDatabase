CREATE TABLE [dbo].[ClipUserLayers]
(
	[ClipUserLayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipId] INT NOT NULL,
	[UserLayerId] INT NOT NULL,
	[Order] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_ClipUserLayers_Clip FOREIGN KEY ([ClipId]) REFERENCES [dbo].[Clip] ([ClipId]),
	CONSTRAINT FK_ClipUserLayers_UserLayers FOREIGN KEY ([UserLayerId]) REFERENCES [dbo].[UserLayer] ([UserLayerId]),
	CONSTRAINT UQ_ClipUserLayers_ClipId_UserLayerId UNIQUE ([ClipId], [UserLayerId])
)
