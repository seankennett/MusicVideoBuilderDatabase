CREATE PROCEDURE [dbo].[GetVideo](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
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
JOIN [dbo].[VideoClips] vc ON vc.ClipId = cu.ClipId
WHERE u.UserObjectId = @userObjectId AND u.UserLayerStatusId > 1 AND vc.VideoId = @VideoId)

SELECT DISTINCT v.VideoId, v.BPM, v.DateUpdated, v.FormatId, v.VideoName FROM [Video] v
JOIN [VideoClips] vc ON v.VideoId = vc.VideoId
WHERE vc.ClipId IN (SELECT ClipId FROM #ClipUserLayers)

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE vc.ClipId IN (SELECT ClipId FROM #ClipUserLayers)

SELECT * FROM #ClipUserLayers

DROP TABLE #ClipUserLayers
