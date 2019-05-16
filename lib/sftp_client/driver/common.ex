defmodule SFTPClient.Driver.Common do
  @moduledoc """
  A module implementing the `SFTPClient.Driver` behavior by simply delegating
  to the particular operation modules.
  """

  @behaviour SFTPClient.Driver

  use Delx, otp_app: :sftp_client

  alias SFTPClient.Operations

  defdel(close_handle!(handle), to: Operations.CloseHandle)
  defdel(close_handle(handle), to: Operations.CloseHandle)
  defdel(connect!(config_or_opts), to: Operations.Connect)
  defdel(connect!(config_or_opts, fun), to: Operations.Connect)
  defdel(connect(config_or_opts), to: Operations.Connect)
  defdel(connect(config_or_opts, fun), to: Operations.Connect)
  defdel(delete_dir!(conn, path), to: Operations.DeleteDir)
  defdel(delete_dir(conn, path), to: Operations.DeleteDir)
  defdel(delete_file!(conn, path), to: Operations.DeleteFile)
  defdel(delete_file(conn, path), to: Operations.DeleteFile)
  defdel(disconnect(conn), to: Operations.Disconnect)

  defdel(download_file!(conn, remote_path, local_path),
    to: Operations.DownloadFile
  )

  defdel(download_file(conn, remote_path, local_path),
    to: Operations.DownloadFile
  )

  defdel(file_info!(conn, path), to: Operations.FileInfo)
  defdel(file_info(conn, path), to: Operations.FileInfo)
  defdel(link_info!(conn, path), to: Operations.LinkInfo)
  defdel(link_info(conn, path), to: Operations.LinkInfo)
  defdel(list_dir!(conn, path), to: Operations.ListDir)
  defdel(list_dir(conn, path), to: Operations.ListDir)
  defdel(make_dir!(conn, path), to: Operations.MakeDir)
  defdel(make_dir(conn, path), to: Operations.MakeDir)

  defdel(make_link!(conn, symlink_path, target_path),
    to: Operations.MakeLink
  )

  defdel(make_link(conn, symlink_path, target_path),
    to: Operations.MakeLink
  )

  defdel(open_dir!(conn, path), to: Operations.OpenDir)
  defdel(open_dir!(conn, path, fun), to: Operations.OpenDir)
  defdel(open_dir(conn, path), to: Operations.OpenDir)
  defdel(open_dir(conn, path, fun), to: Operations.OpenDir)
  defdel(open_file!(conn, path, modes), to: Operations.OpenFile)
  defdel(open_file!(conn, path, modes, fun), to: Operations.OpenFile)
  defdel(open_file(conn, path, modes), to: Operations.OpenFile)
  defdel(open_file(conn, path, modes, fun), to: Operations.OpenFile)
  defdel(read_file_chunk!(handle, length), to: Operations.ReadFileChunk)
  defdel(read_file_chunk(handle, length), to: Operations.ReadFileChunk)
  defdel(read_file!(conn, path), to: Operations.ReadFile)
  defdel(read_file(conn, path), to: Operations.ReadFile)
  defdel(read_link!(conn, path), to: Operations.ReadLink)
  defdel(read_link(conn, path), to: Operations.ReadLink)
  defdel(rename!(conn, old_name, new_name), to: Operations.Rename)
  defdel(rename(conn, old_name, new_name), to: Operations.Rename)
  defdel(stream_file!(conn, path, chunk_size), to: Operations.StreamFile)
  defdel(stream_file!(conn, path), to: Operations.StreamFile)
  defdel(stream_file(conn, path, chunk_size), to: Operations.StreamFile)
  defdel(stream_file(conn, path), to: Operations.StreamFile)

  defdel(upload_file!(conn, local_path, remote_path),
    to: Operations.UploadFile
  )

  defdel(upload_file(conn, local_path, remote_path),
    to: Operations.UploadFile
  )

  defdel(write_file_chunk!(handle, data), to: Operations.WriteFileChunk)
  defdel(write_file_chunk(handle, data), to: Operations.WriteFileChunk)
  defdel(write_file!(conn, path, data), to: Operations.WriteFile)
  defdel(write_file(conn, path, data), to: Operations.WriteFile)
end
