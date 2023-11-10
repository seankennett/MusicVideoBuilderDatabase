CREATE PROCEDURE [dbo].[GetUserSubscription](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT [ProductId], [CustomerId], [SubscriptionId], [SubscriptionStatus] FROM [dbo].[UserSubscription] WHERE UserObjectId = @userObjectId
