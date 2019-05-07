use Mix.Config

config :sftp_client,
  sftp_adapter: SFTPClient.Adapters.SFTP.Mock,
  ssh_adapter: SFTPClient.Adapters.SSH.Mock
