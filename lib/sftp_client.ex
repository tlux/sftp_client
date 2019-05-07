defmodule SFTPClient do
  alias SFTPClient.Operations

  @sftp_adapter Application.get_env(:sftp_client, :sftp_adapter, :ssh_sftp)
  @ssh_adapter Application.get_env(:sftp_client, :ssh_adapter, :ssh)

  @doc """
  Gets the configured SFTP adapter. Defaults to the Erlang ssh_sftp module.
  """
  @spec sftp_adapter() :: module
  def sftp_adapter, do: @sftp_adapter

  @doc """
  Gets the configured SSH adapter. Defaults to the Erlang ssh module.
  """
  @spec ssh_adapter() :: module
  def ssh_adapter, do: @ssh_adapter

  defdelegate connect(config_or_opts), to: Operations.Connect
  defdelegate connect!(config_or_opts), to: Operations.Connect
  defdelegate disconnect(conn), to: Operations.Disconnect
  defdelegate list_dir(conn, path), to: Operations.ListDir
  defdelegate list_dir!(conn, path), to: Operations.ListDir
  defdelegate read_file(conn, path), to: Operations.ReadFile
  defdelegate read_file!(conn, path), to: Operations.ReadFile
  defdelegate file_info(conn, path), to: Operations.FileInfo
  defdelegate file_info!(conn, path), to: Operations.FileInfo
  defdelegate open_file(conn, path, modes), to: Operations.OpenFile
  defdelegate open_file!(conn, path, modes), to: Operations.OpenFile
  defdelegate read_chunk(handle, length), to: Operations.ReadChunk
  defdelegate read_chunk!(handle, length), to: Operations.ReadChunk
  defdelegate write_chunk(handle, data), to: Operations.WriteChunk
  defdelegate write_chunk!(handle, data), to: Operations.WriteChunk
  defdelegate close_handle(handle), to: Operations.CloseHandle
  defdelegate close_handle!(handle), to: Operations.CloseHandle
  defdelegate stream_file(conn, path), to: Operations.StreamFile
  defdelegate stream_file(conn, path, chunk_size), to: Operations.StreamFile

  defdelegate download_file!(conn, remote_path, local_path),
    to: Operations.DownloadFile
end
