CREATE TABLE [dbo].[DisplayLayer]
(
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[CollectionId] UNIQUEIDENTIFIER NOT NULL,
	[DirectionId] TINYINT NULL,
	[NumberOfSides] TINYINT NULL,
	[LinkedPreviousDisplayLayerId] UNIQUEIDENTIFIER NULL,
	[DateCreated] DATETIME2 NOT NULL,
	CONSTRAINT FK_DisplayLayer_Collection FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([CollectionId]),
	CONSTRAINT FK_DisplayLayer_Direction FOREIGN KEY ([DirectionId]) REFERENCES [dbo].[Direction] ([DirectionId]),
	CONSTRAINT FK_DisplayLayer FOREIGN KEY ([LinkedPreviousDisplayLayerId]) REFERENCES [dbo].[DisplayLayer] ([DisplayLayerId])
)
