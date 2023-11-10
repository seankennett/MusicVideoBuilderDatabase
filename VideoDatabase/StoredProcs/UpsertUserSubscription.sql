CREATE PROCEDURE [dbo].[UpsertUserSubscription]
	@ProductId VARCHAR(30),
	@CustomerId VARCHAR(30),
	@SubscriptionId VARCHAR(30),
	@SubscriptionStatus VARCHAR(30),
	@UserObjectId UNIQUEIDENTIFIER
AS
BEGIN TRY
    BEGIN TRANSACTION

	DECLARE @DateNow DATETIME2 = GETUTCDATE();
	IF EXISTS (SELECT UserObjectId FROM [dbo].[UserSubscription] WHERE UserObjectId = @UserObjectId)
	BEGIN
		UPDATE [dbo].[UserSubscription] SET [ProductId] = @ProductId, [SubscriptionId] = @SubscriptionId, [SubscriptionStatus] = @SubscriptionStatus, [DateUpdated] = @DateNow WHERE UserObjectId = @UserObjectId
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[UserSubscription] (UserObjectId, ProductId, CustomerId, SubscriptionId, SubscriptionStatus, DateCreated, DateUpdated) VALUES (@UserObjectId, @ProductId, @CustomerId, @SubscriptionId, @SubscriptionStatus, @DateNow, @DateNow)
	END

	COMMIT
	END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
