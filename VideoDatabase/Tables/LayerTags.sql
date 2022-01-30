CREATE TABLE [dbo].[LayerTags]
(
	[LayerTagId] INT IDENTITY NOT NULL PRIMARY KEY,
	[LayerId] UNIQUEIDENTIFIER NOT NULL,
	[TagId] INT NOT NULL,
	CONSTRAINT FK_LayerTags_Layer FOREIGN KEY ([LayerId]) REFERENCES [dbo].[Layer]([LayerId]),
	CONSTRAINT FK_LayerTags_Tag FOREIGN KEY ([TagId]) REFERENCES [dbo].[Tag]([TagId]),
	CONSTRAINT UQ_LayerTags_LayerId_TagId UNIQUE ([LayerId], [TagId])
)
