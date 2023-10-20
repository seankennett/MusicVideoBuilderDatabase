CREATE PROCEDURE [dbo].[GetClip](
@userObjectId UNIQUEIDENTIFIER,
@ClipId INTEGER
)
AS

SELECT ClipId, ClipName, BackgroundColour, BeatLength, StartingBeat FROM [Clip]
WHERE ClipId = @ClipId AND UserObjectId = @userObjectId

SELECT cd.ClipId, cd.DisplayLayerId, cd.[Reverse], cd.[Order], cd.ClipDisplayLayerId  FROM [dbo].[ClipDisplayLayers] cd
JOIN [dbo].[DisplayLayer] d ON cd.DisplayLayerId = d.DisplayLayerId
WHERE [cd].[ClipId] = @ClipId

SELECT l.LayerId, l.Colour, l.ClipDisplayLayerId  FROM [dbo].[LayerClipDisplayLayers] l
JOIN [dbo].[ClipDisplayLayers] cd ON cd.ClipDisplayLayerId = l.ClipDisplayLayerId
WHERE [cd].[ClipId] = @ClipId

