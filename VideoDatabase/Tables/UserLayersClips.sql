CREATE TABLE [dbo].[UserLayersClips]
(
	[UserLayerClipId] INT IDENTITY NOT NULL PRIMARY KEY,
	[ClipId] INT NOT NULL,
	[UserLayerId] INT NOT NULL,
	[Order] TINYINT NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_UserLayersClips_Clip FOREIGN KEY ([ClipId]) REFERENCES [dbo].[Clip] ([ClipId]),
	CONSTRAINT FK_UserLayersClips_UserLayers FOREIGN KEY ([UserLayerId]) REFERENCES [dbo].[UserLayers] ([UserLayerId]),
	CONSTRAINT UQ_UserLayersClips_ClipId_UserLayerId UNIQUE ([ClipId], [UserLayerId])
)
