CREATE TABLE [dbo].[Layer]
(
	[LayerId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DefaultColour] CHAR(6) NOT NULL,
	[IsOverlay] BIT NOT NULL,
	[Order] TINYINT NOT NULL,
	CONSTRAINT FK_Layer_DisplayLayer FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer] ([DisplayLayerId])
)
