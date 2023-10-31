CREATE PROCEDURE [dbo].[GetClips](
@userObjectId UNIQUEIDENTIFIER
)
AS

SELECT ClipId, ClipName, BackgroundColour, EndBackgroundColour, BeatLength, StartingBeat  FROM [Clip] 
WHERE UserObjectId = @userObjectId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[FlipHorizontal], cd.[FlipVertical], cd.[Order], cd.ClipDisplayLayerId, f.[FadeTypeId], fc.[Colour] FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
LEFT JOIN [dbo].[Fade] f ON cd.ClipDisplayLayerId = f.ClipDisplayLayerId
LEFT JOIN [dbo].[FadeColour] fc ON f.ClipDisplayLayerId = fc.ClipDisplayLayerId
WHERE c.UserObjectId = @userObjectId

SELECT l.LayerId, l.Colour, l.ClipDisplayLayerId, l.EndColour FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
JOIN [dbo].[Clip] c ON c.ClipId = cd.ClipId
WHERE c.UserObjectId = @userObjectId