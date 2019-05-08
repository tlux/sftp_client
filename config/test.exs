use Mix.Config

config :sftp_client,
  sftp_adapter: SFTPClient.Adapter.SFTP.Mock,
  ssh_adapter: SFTPClient.Adapter.SSH.Mock
