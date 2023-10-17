CREATE PROCEDURE [dbo].[GetVideo](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName FROM [Video]
WHERE UserObjectId = @userObjectId AND VideoId = @VideoId

SELECT vc.VideoId, vc.ClipId, vc.[Order], c.ClipName, c.BackgroundColour, c.BeatLength, c.StartingBeat FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId AND vc.VideoId = @VideoId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[Order], cd.ClipDisplayLayerId FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.ColourOverride, l.ClipDisplayLayerId FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId