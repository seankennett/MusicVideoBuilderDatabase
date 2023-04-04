IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = 'musicvideobuilder')
BEGIN
CREATE USER [musicvideobuilder] FROM EXTERNAL PROVIDER

GRANT CONNECT TO [musicvideobuilder]

GRANT EXECUTE TO [musicvideobuilder]
END

IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = 'seankennettwork@gmail.com')
BEGIN
CREATE USER [seankennettwork@gmail.com] FROM EXTERNAL PROVIDER

EXEC sp_addrolemember N'db_owner', N'seankennettwork@gmail.com'
END
