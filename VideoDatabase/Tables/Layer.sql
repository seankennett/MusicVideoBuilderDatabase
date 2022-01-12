CREATE TABLE [dbo].[Layer]
(
	[LayerId] INT IDENTITY NOT NULL PRIMARY KEY,
	[LayerTypeId] TINYINT NOT NULL,
	[ContainerPath] VARCHAR(100) NOT NULL,
	[LayerName] NVARCHAR(50) NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_Layer_LayerType FOREIGN KEY ([LayerTypeId]) REFERENCES [dbo].[LayerType]([LayerTypeId])
)
