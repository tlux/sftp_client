defmodule SFTPClient do
  alias SFTPClient.Operations

  @sftp_adapter Application.get_env(:sftp_client, :sftp_adapter, :ssh_sftp)
  @ssh_adapter Application.get_env(:sftp_client, :ssh_adapter, :ssh)

  @doc """
  Gets the configured SFTP adapter. Defaults to the Erlang `:ssh_sftp` module.
  """
  @spec sftp_adapter() :: module
  def sftp_adapter, do: @sftp_adapter

  @doc """
  Gets the configured SSH adapter. Defaults to the Erlang `:ssh` module.
  """
  @spec ssh_adapter() :: module
  def ssh_adapter, do: @ssh_adapter

  defdelegate close_handle!(handle), to: Operations.CloseHandle
  defdelegate close_handle(handle), to: Operations.CloseHandle
  defdelegate connect!(config_or_opts), to: Operations.Connect
  defdelegate connect(config_or_opts), to: Operations.Connect
  defdelegate delete_dir!(conn, path), to: Operations.DeleteDir
  defdelegate delete_dir(conn, path), to: Operations.DeleteDir
  defdelegate delete_file!(conn, path), to: Operations.DeleteFile
  defdelegate delete_file(conn, path), to: Operations.DeleteFile
  defdelegate disconnect(conn), to: Operations.Disconnect

  defdelegate download_file!(conn, remote_path, local_path),
    to: Operations.DownloadFile

  defdelegate download_file(conn, remote_path, local_path),
    to: Operations.DownloadFile

  defdelegate file_info!(conn, path), to: Operations.FileInfo
  defdelegate file_info(conn, path), to: Operations.FileInfo
  defdelegate link_info!(conn, path), to: Operations.LinkInfo
  defdelegate link_info(conn, path), to: Operations.LinkInfo
  defdelegate list_dir!(conn, path), to: Operations.ListDir
  defdelegate list_dir(conn, path), to: Operations.ListDir
  defdelegate make_dir!(conn, path), to: Operations.MakeDir
  defdelegate make_dir(conn, path), to: Operations.MakeDir

  defdelegate make_symlink!(conn, symlink_path, target_path),
    to: Operations.MakeSymlink

  defdelegate make_symlink(conn, symlink_path, target_path),
    to: Operations.MakeSymlink

  defdelegate open_dir!(conn, path), to: Operations.OpenDir
  defdelegate open_dir(conn, path), to: Operations.OpenDir
  defdelegate open_file!(conn, path, modes), to: Operations.OpenFile
  defdelegate open_file(conn, path, modes), to: Operations.OpenFile
  defdelegate read_chunk!(handle, length), to: Operations.ReadChunk
  defdelegate read_chunk(handle, length), to: Operations.ReadChunk
  defdelegate read_file!(conn, path), to: Operations.ReadFile
  defdelegate read_file(conn, path), to: Operations.ReadFile
  defdelegate read_link!(conn, path), to: Operations.ReadLink
  defdelegate read_link(conn, path), to: Operations.ReadLink
  defdelegate rename!(conn, old_name, new_name), to: Operations.Rename
  defdelegate rename(conn, old_name, new_name), to: Operations.Rename
  defdelegate stream_file!(conn, path, chunk_size), to: Operations.StreamFile
  defdelegate stream_file!(conn, path), to: Operations.StreamFile
  defdelegate stream_file(conn, path, chunk_size), to: Operations.StreamFile
  defdelegate stream_file(conn, path), to: Operations.StreamFile
  defdelegate write_chunk!(handle, data), to: Operations.WriteChunk
  defdelegate write_chunk(handle, data), to: Operations.WriteChunk
  defdelegate write_file!(conn, path, data), to: Operations.WriteFile
  defdelegate write_file(conn, path, data), to: Operations.WriteFile
end
