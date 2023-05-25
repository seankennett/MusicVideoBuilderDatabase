CREATE TYPE [dbo].[ClipDisplayLayerType] AS TABLE
(
	[TempId] INT NOT NULL,
	[DisplayLayerId] UNIQUEIDENTIFIER NOT NULL,
	[Order] SMALLINT NOT NULL
)
