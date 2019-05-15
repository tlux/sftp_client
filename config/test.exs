use Mix.Config

config :delx, :stub, true

config :sftp_client,
  sftp_adapter: SFTPClient.Adapter.SFTP.Mock,
  ssh_adapter: SFTPClient.Adapter.SSH.Mock
