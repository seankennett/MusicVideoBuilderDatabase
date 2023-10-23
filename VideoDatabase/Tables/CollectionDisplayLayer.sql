CREATE TABLE [dbo].[CollectionDisplayLayer]
(
	[CollectionId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT UQ_CollectionDisplayLayer_DisplayLayer UNIQUE ([DisplayLayerId]),
	CONSTRAINT FK_CollectionDisplayLayer_Collection FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([CollectionId]),
	CONSTRAINT FK_CollectionDisplayLayer_DisplayLayer FOREIGN KEY ([DisplayLayerId]) REFERENCES [dbo].[DisplayLayer] ([DisplayLayerId])
)
