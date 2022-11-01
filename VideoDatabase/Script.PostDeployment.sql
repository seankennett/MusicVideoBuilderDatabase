/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF NOT EXISTS(SELECT 1 FROM [dbo].[Format])
BEGIN
    INSERT INTO [dbo].[Format] ([FormatId], [FormatName]) VALUES (1, 'mp4') 
    INSERT INTO [dbo].[Format] ([FormatId], [FormatName]) VALUES (2, 'mov') 
    INSERT INTO [dbo].[Format] ([FormatId], [FormatName]) VALUES (3, 'avi')
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[LayerType])
BEGIN
    INSERT INTO [dbo].[LayerType] ([LayerTypeId], [LayerTypeName]) VALUES (1, 'Background') 
    INSERT INTO [dbo].[LayerType] ([LayerTypeId], [LayerTypeName]) VALUES (2, 'Foreground') 
END

Update UserLayer SET UserLayerStatusId = 1
Update [UserLayerStatus] SET UserLayerStatusName = 'Saved' WHERE UserLayerStatusId = 1
DELETE FROM [dbo].[UserLayerStatus] WHERE UserLayerStatusId = 3

IF NOT EXISTS(SELECT 1 FROM [dbo].[UserLayerStatus])
BEGIN
    INSERT INTO [dbo].[UserLayerStatus] ([UserLayerStatusId], [UserLayerStatusName]) VALUES (1, 'Bought') 
    INSERT INTO [dbo].[UserLayerStatus] ([UserLayerStatusId], [UserLayerStatusName]) VALUES (2, 'Saved') 
END

IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = 'MusicVideoBuilderApplication')
BEGIN
CREATE USER [MusicVideoBuilderApplication] WITH PASSWORD = N'$(sqlLoginMusicVideoBuilderApplicationPassword)'

GRANT CONNECT TO [MusicVideoBuilderApplication]

GRANT EXECUTE TO [MusicVideoBuilderApplication]
END