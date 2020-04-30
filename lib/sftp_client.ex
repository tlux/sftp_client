defmodule SFTPClient do
  @moduledoc """
  This is an SFTP Client that wraps Erlang's `:ssh` and `:ssh_sftp` libraries
  for easier usage in Elixir.

  ## Connect & Disconnect

  To open a new connection to an SFTP server:

      iex> {:ok, conn} = SFTPClient.connect(host: "ftp.myhost.com")
      {:ok, %SFTPClient.Conn{}}

  Refer to the docs for `SFTPClient.Operations.Connect.connect/1` to find out
  all available options.

  It is strongly recommended to close a connection after your operations have
  completed:

      iex> SFTPClient.disconnect(conn)
      :ok

  For short-lived connections you can also use a function as second argument.
  After the function body has run or raises, the connection is automatically
  closed.

      iex> SFTPClient.connect([host: "ftp.myhost.com"], fn conn ->
      ...>   # Do something with conn
      ...>   "my result"
      ...> end)
      {:ok, "my result"}

  ## Download

  You can download a file from the server you can use the following function.

      iex> SFTPClient.download_file(conn, "my/remote/dir/file.jpg", "my/dir/local-file.jpg")
      {:ok, "my/dir/local-file.jpg"}

  When the third argument is an existing directory on your file system, the file
  is downloaded to a file with the same name as the one on the server.

      iex> SFTPClient.download_file(conn, "my/remote/dir/image.png", "my/local/dir")
      {:ok, "my/local/dir/image.png"}

  It is also possible to use Streams to download data into a file or memory.

      iex> SFTPClient.stream_file!(conn, "my/remote/file.jpg")
      ...> |> Stream.into(File.stream!("my/local/file.jpg"))
      ...> |> Stream.run()
      :ok

  ## Upload

  To upload are file from the file system you can use the following function.

      iex> SFTPClient.upload_file(conn, "my/local/dir/file.jpg", "my/remote/dir/file.jpg")
      {:ok, "my/remote/dir/file.jpg"}

  You can also use Streams to upload data. Please make sure to set a proper
  chunk size or the upload may be slow.

      iex> File.stream!("my/local/file.jpg")
      ...> |> Stream.into(SFTPClient.stream_file!(conn, "my/remote/file.jpg"))
      ...> |> Stream.run()
      :ok

  ## List Directory

      iex> SFTPClient.list_dir(conn, "my/dir")
      {:ok, ["my/dir/file_1.jpg", "my/dir/file_2.jpg"]}

  ## Create Directory

      iex> SFTPClient.make_dir(conn, "my/new/dir")
      :ok

  Note that this operation fails unless the parent directory exists.

  ## Delete

  To delete a file:

      iex> SFTPClient.delete_file(conn, "my/remote/file.jpg")
      :ok

  To delete a directory:

      iex> SFTPClient.delete_dir(conn, "my/remote/dir")
      :ok

  Note that a directory cannot be deleted as long as it still contains files.

  ## Rename

  To move/rename a file or directory:

      iex> SFTPClient.rename(conn, "my/remote/file.jpg", "my/remote/new-file.jpg")
      :ok

  ## File Info

  You can retrieve meta data about a file from the server such as file size,
  modification time, file permissions, owner and so on.

      iex> SFTPClient.file_info(conn, "my/remote/file.jpg")
      {:ok, %File.Stat{}}

  Refer to the [`File.Stat`](https://hexdocs.pm/elixir/File.Stat.html) docs for a
  list of available file information.

  ## Symbolic Links

  There are also a couple of functions that handle symbolic links.

  It is possible to get the target of a symlink.

      iex> SFTPClient.read_link(conn, "my/remote/link.jpg")
      {:ok, "my/remote/file.jpg"}

  You can retrieve meta data about symlinks, similar to `file_info/2`.

      iex> SFTPClient.link_info(conn, "my/remote/link.jpg")
      {:ok, %File.Stat{}}

  And you are able to create symlinks.

      iex> SFTPClient.make_link(conn, "my/remote/link.jpg", "my/remote/file.jpg")
      :ok
  """

  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.OperationError
  alias SFTPClient.Operations

  @typedoc """
  File access modes that can be used when opening files directly from the remote
  server.
  """
  @type access_mode :: :read | :write | :creat | :trunc | :append | :binary

  @typedoc """
  A type incorporating all error types.
  """
  @type error :: ConnError.t() | InvalidOptionError.t() | OperationError.t()

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
  defdelegate rename!(conn, old_path, new_path), to: Operations.Rename
  defdelegate rename(conn, old_path, new_path), to: Operations.Rename
  defdelegate stream_file!(conn, path, chunk_size), to: Operations.StreamFile
  defdelegate stream_file!(conn, path), to: Operations.StreamFile

  @deprecated "Use stream_file!/2 instead"
  defdelegate stream_file(conn, path, chunk_size), to: Operations.StreamFile

  @deprecated "Use stream_file!/3 instead"
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
