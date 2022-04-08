CREATE PROCEDURE [dbo].[CreateUserLayers](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT [LayerId], [UserLayerStatusId], [UserLayerId] FROM [dbo].[UserLayers] WHERE UserObjectId = @userObjectId
