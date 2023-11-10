CREATE TABLE [dbo].[UserSubscription]
(
	[UserObjectId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[ProductId] VARCHAR(30) NOT NULL,
	[CustomerId] VARCHAR(30) NOT NULL,
	[SubscriptionId] VARCHAR(30) NOT NULL,
	[SubscriptionStatus] VARCHAR(30) NOT NULL,
	[DateCreated] DATETIME2 NOT NULL,
	[DateUpdated] DATETIME2 NOT NULL,
	CONSTRAINT FK_UserSubscription_SubscriptionProduct FOREIGN KEY ([ProductId]) REFERENCES [dbo].[SubscriptionProduct](SubscriptionProductId)
)
