ExUnit.start(capture_log: true)

Mox.defmock(SFTPClient.Adapter.SFTP.Mock, for: SFTPClient.Adapter.SFTP)
Mox.defmock(SFTPClient.Adapter.SSH.Mock, for: SFTPClient.Adapter.SSH)
Mox.defmock(SFTPClient.Driver.Mock, for: SFTPClient.Driver)
