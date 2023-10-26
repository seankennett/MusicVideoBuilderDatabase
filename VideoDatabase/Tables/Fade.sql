CREATE TABLE [dbo].[Fade]
(
	[ClipDisplayLayerId] INT NOT NULL PRIMARY KEY,
	[FadeTypeId] TINYINT NOT NULL,
	CONSTRAINT FK_Fade_ClipDisplayLayers FOREIGN KEY ([ClipDisplayLayerId]) REFERENCES [dbo].[ClipDisplayLayers] ([ClipDisplayLayerId]),
	CONSTRAINT FK_Fade_FadeType FOREIGN KEY ([FadeTypeId]) REFERENCES [dbo].[FadeType] ([FadeTypeId])
)
