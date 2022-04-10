CREATE PROCEDURE [dbo].[GetUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT [LayerId], [UserLayerStatusId], [UserLayerId], [DateUpdated] FROM [dbo].[UserLayers] WHERE UserObjectId = @userObjectId
