﻿CREATE PROCEDURE [dbo].[GetVideo](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName, IsBuilding FROM [Video]
WHERE UserObjectId = @userObjectId AND VideoId = @VideoId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId AND vc.VideoId = @VideoId

SELECT cu.ClipId, cu.UserLayerId, cu.[Order], u.LayerId, l.LayerName, u.UserLayerStatusId FROM [dbo].[ClipUserLayers] cu
JOIN [dbo].[UserLayer] u ON cu.UserLayerId = u.UserLayerId
JOIN [dbo].[Layer] l ON u.LayerId = l.LayerId
WHERE u.UserObjectId = @userObjectId