CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

CREATE TABLE #ClipUserLayers (
    [ClipId] INT,
	[UserLayerId] INT,
	[Order] TINYINT,
	[LayerId] UNIQUEIDENTIFIER
);

INSERT INTO #ClipUserLayers (ClipId, UserLayerId, [Order], LayerId) (SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE [cu].[ClipId] = @ClipId AND u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1)

SELECT c.ClipId, c.ClipName, c.DateUpdated FROM [Clip] c 
WHERE c.ClipId IN (SELECT ClipId FROM #ClipUserLayers)

SELECT * FROM #ClipUserLayers

DROP TABLE #ClipUserLayers
