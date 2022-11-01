CREATE PROCEDURE [dbo].[GetVideos](
@userObjectId UNIQUEIDENTIFIER
)
AS

CREATE TABLE #ClipUserLayers (
    [ClipId] INT,
	[UserLayerId] INT,
	[Order] TINYINT,
	[LayerId] UNIQUEIDENTIFIER,
	[UserLayerStatusId] TINYINT
);

INSERT INTO #ClipUserLayers (ClipId, UserLayerId, [Order], LayerId, [UserLayerStatusId]) (SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
WHERE u.UserObjectId = @userObjectId)

SELECT DISTINCT v.VideoId, v.BPM, v.VideoDelayMilliseconds, v.DateUpdated, v.FormatId, v.VideoName FROM [Video] v
JOIN [VideoClips] vc ON v.VideoId = vc.VideoId
WHERE vc.ClipId IN (SELECT ClipId FROM #ClipUserLayers)

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE vc.ClipId IN (SELECT ClipId FROM #ClipUserLayers)

SELECT * FROM #ClipUserLayers

DROP TABLE #ClipUserLayers
