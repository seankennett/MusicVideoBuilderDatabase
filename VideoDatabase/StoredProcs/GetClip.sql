CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT ClipId, ClipName, BackgroundColour, EndBackgroundColour, BeatLength, StartingBeat FROM [Clip]
WHERE ClipId = @ClipId AND UserObjectId = @userObjectId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[FlipHorizontal], cd.[FlipVertical], cd.[Order], cd.[ClipDisplayLayerId], f.[FadeTypeId], fc.[Colour]  FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[DisplayLayer] d ON cd.DisplayLayerId = d.DisplayLayerId
LEFT JOIN [dbo].[Fade] f ON cd.ClipDisplayLayerId = f.ClipDisplayLayerId
LEFT JOIN [dbo].[FadeColour] fc ON f.ClipDisplayLayerId = fc.ClipDisplayLayerId
WHERE [cd].[ClipId] = @ClipId

SELECT l.LayerId, l.Colour, l.ClipDisplayLayerId, l.EndColour  FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
WHERE [cd].[ClipId] = @ClipId

