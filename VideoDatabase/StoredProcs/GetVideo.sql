CREATE PROCEDURE [dbo].[GetVideo](
@userObjectId UNIQUEIDENTIFIER,
@VideoId INTEGER
)
AS

SELECT VideoId, BPM, VideoDelayMilliseconds, DateUpdated, FormatId, VideoName FROM [Video]
WHERE UserObjectId = @userObjectId AND VideoId = @VideoId

SELECT vc.VideoId, vc.ClipId, vc.[Order] FROM [VideoClips] vc
JOIN [dbo].[Clip] c ON vc.ClipId = c.[ClipId]
WHERE c.UserObjectId = @userObjectId AND vc.VideoId = @VideoId