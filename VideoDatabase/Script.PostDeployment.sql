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

IF NOT EXISTS(SELECT 1 FROM [dbo].[BuildStatus])
BEGIN
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (1, 'HoldPending')
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (2, 'Building') 
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (3, 'ChargePending')
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (4, 'Complete') 
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[Resolution])
BEGIN
    INSERT INTO [dbo].[Resolution] ([ResolutionId], [ResolutionName]) VALUES (1, 'Free')
    INSERT INTO [dbo].[Resolution] ([ResolutionId], [ResolutionName]) VALUES (2, 'HD') 
    INSERT INTO [dbo].[Resolution] ([ResolutionId], [ResolutionName]) VALUES (3, '4K')
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[License])
BEGIN
    INSERT INTO [dbo].[License] ([LicenseId], [LicenseName]) VALUES (1, 'Personal')
    INSERT INTO [dbo].[License] ([LicenseId], [LicenseName]) VALUES (2, 'Standard') 
    INSERT INTO [dbo].[License] ([LicenseId], [LicenseName]) VALUES (3, 'Enhanced')
END

IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = 'MusicVideoBuilderApplication')
BEGIN
CREATE USER [MusicVideoBuilderApplication] WITH PASSWORD = N'$(sqlLoginMusicVideoBuilderApplicationPassword)'

GRANT CONNECT TO [MusicVideoBuilderApplication]

GRANT EXECUTE TO [MusicVideoBuilderApplication]
END