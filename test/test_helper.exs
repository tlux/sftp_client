ExUnit.start(capture_log: true, exclude: [:integration])

Mox.defmock(SFTPClient.Adapter.SFTP.Mock, for: SFTPClient.Adapter.SFTP)
Mox.defmock(SFTPClient.Adapter.SSH.Mock, for: SFTPClient.Adapter.SSH)
