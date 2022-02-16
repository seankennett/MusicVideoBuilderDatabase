CREATE USER [MusicVideoBuilderApplication]
	WITH PASSWORD = N'$(sqlLoginMusicVideoBuilderApplicationPassword)'

GO

GRANT CONNECT TO [MusicVideoBuilderApplication]
GO
GRANT EXECUTE TO [MusicVideoBuilderApplication]