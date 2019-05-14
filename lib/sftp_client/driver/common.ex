defmodule SFTPClient.Driver.Common do
  @moduledoc """
  A module implementing the `SFTPClient.Driver` behavior by simply delegating
  to the particular operation modules.
  """

  @behaviour SFTPClient.Driver

  alias SFTPClient.Operations

  defdelegate close_handle!(handle), to: Operations.CloseHandle
  defdelegate close_handle(handle), to: Operations.CloseHandle
  defdelegate connect!(config_or_opts), to: Operations.Connect
  defdelegate connect!(config_or_opts, fun), to: Operations.Connect
  defdelegate connect(config_or_opts), to: Operations.Connect
  defdelegate connect(config_or_opts, fun), to: Operations.Connect
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

  defdelegate make_link!(conn, symlink_path, target_path),
    to: Operations.MakeLink

  defdelegate make_link(conn, symlink_path, target_path),
    to: Operations.MakeLink

  defdelegate open_dir!(conn, path), to: Operations.OpenDir
  defdelegate open_dir!(conn, path, fun), to: Operations.OpenDir
  defdelegate open_dir(conn, path), to: Operations.OpenDir
  defdelegate open_dir(conn, path, fun), to: Operations.OpenDir
  defdelegate open_file!(conn, path, modes), to: Operations.OpenFile
  defdelegate open_file!(conn, path, modes, fun), to: Operations.OpenFile
  defdelegate open_file(conn, path, modes), to: Operations.OpenFile
  defdelegate open_file(conn, path, modes, fun), to: Operations.OpenFile
  defdelegate read_file_chunk!(handle, length), to: Operations.ReadFileChunk
  defdelegate read_file_chunk(handle, length), to: Operations.ReadFileChunk
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

  defdelegate upload_file!(conn, local_path, remote_path),
    to: Operations.UploadFile

  defdelegate upload_file(conn, local_path, remote_path),
    to: Operations.UploadFile

  defdelegate write_file_chunk!(handle, data), to: Operations.WriteFileChunk
  defdelegate write_file_chunk(handle, data), to: Operations.WriteFileChunk
  defdelegate write_file!(conn, path, data), to: Operations.WriteFile
  defdelegate write_file(conn, path, data), to: Operations.WriteFile
end
