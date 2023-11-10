CREATE PROCEDURE [dbo].[DeleteUserSubscriptionByCustomerId]
	@CustomerId VARCHAR(30)
AS

DELETE FROM [dbo].[UserSubscription] WHERE [CustomerId] = @CustomerId