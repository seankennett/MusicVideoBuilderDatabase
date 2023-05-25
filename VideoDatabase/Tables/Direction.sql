CREATE TABLE [dbo].[Direction]
(
	[DirectionId] TINYINT NOT NULL PRIMARY KEY,
	[DirectionName] NVARCHAR(30) NOT NULL,
	[IsTransition] BIT NOT NULL
)
