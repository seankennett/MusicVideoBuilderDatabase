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

IF NOT EXISTS(SELECT 1 FROM [dbo].[CollectionType])
BEGIN
    INSERT INTO [dbo].[CollectionType] ([CollectionTypeId], [CollectionTypeName]) VALUES (1, 'Background') 
    INSERT INTO [dbo].[CollectionType] ([CollectionTypeId], [CollectionTypeName]) VALUES (2, 'Foreground') 
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[BuildStatus])
BEGIN
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (1, 'PaymentAuthorisationPending')
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (2, 'BuildingPending') 
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (3, 'PaymentChargePending')
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (4, 'Complete') 
    INSERT INTO [dbo].[BuildStatus] ([BuildStatusId], [BuildStatusName]) VALUES (5, 'Failed') 
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

IF NOT EXISTS(SELECT 1 FROM [dbo].[Direction])
BEGIN
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (1, 'Straight', 0)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (2, 'StraightRight', 1)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (3, 'Right', 0)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (4, 'RightStraight', 1)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (5, 'StraightUp', 1)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (6, 'Up', 0)
    INSERT INTO [dbo].[Direction] ([DirectionId], [DirectionName], [IsTransition]) VALUES (7, 'UpStraight', 1)
END