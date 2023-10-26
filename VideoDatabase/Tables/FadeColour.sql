CREATE TABLE [dbo].[FadeColour]
(
	[ClipDisplayLayerId] INT NOT NULL PRIMARY KEY,
	[Colour] CHAR(6) NOT NULL,
	CONSTRAINT FK_FadeColour_Fade FOREIGN KEY ([ClipDisplayLayerId]) REFERENCES [dbo].[Fade] ([ClipDisplayLayerId])
)
