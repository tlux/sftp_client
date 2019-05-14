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

  You can also use Streams to upload data.

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

      iex> SFTPClient.delete(conn, "my/remote/dir")
      :ok

  Note that a directory cannot be deleted as long as it still contains files.

  ## Rename

  To delete a file or directory:

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

  @behaviour SFTPClient.Driver

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

  @doc """
  Gets the configured driver.
  """
  @spec driver() :: module
  def driver do
    Application.get_env(:sftp_client, :driver, SFTPClient.Driver.Common)
  end

  @doc delegate_to: {Operations.CloseHandle, :close_handle!, 1}
  def close_handle!(handle) do
    driver().close_handle!(handle)
  end

  @doc delegate_to: {Operations.CloseHandle, :close_handle, 1}
  def close_handle(handle) do
    driver().close_handle(handle)
  end

  @doc delegate_to: {Operations.Connect, :connect!, 1}
  def connect!(config_or_opts) do
    driver().connect!(config_or_opts)
  end

  @doc delegate_to: {Operations.Connect, :connect!, 2}
  def connect!(config_or_opts, fun) do
    driver().connect!(config_or_opts, fun)
  end

  @doc delegate_to: {Operations.Connect, :connect, 1}
  def connect(config_or_opts) do
    driver().connect(config_or_opts)
  end

  @doc delegate_to: {Operations.Connect, :connect, 2}
  def connect(config_or_opts, fun) do
    driver().connect(config_or_opts, fun)
  end

  @doc delegate_to: {Operations.DeleteDir, :delete_dir!, 2}
  def delete_dir!(conn, path) do
    driver().delete_dir!(conn, path)
  end

  @doc delegate_to: {Operations.DeleteDir, :delete_dir, 2}
  def delete_dir(conn, path) do
    driver().delete_dir(conn, path)
  end

  @doc delegate_to: {Operations.DeleteFile, :delete_file!, 2}
  def delete_file!(conn, path) do
    driver().delete_file!(conn, path)
  end

  @doc delegate_to: {Operations.DeleteFile, :delete_file, 2}
  def delete_file(conn, path) do
    driver().delete_file(conn, path)
  end

  @doc delegate_to: {Operations.Disconnect, :disconnect, 1}
  def disconnect(conn) do
    driver().disconnect(conn)
  end

  @doc delegate_to: {Operations.DownloadFile, :download_file!, 3}
  def download_file!(conn, remote_path, local_path) do
    driver().download_file!(conn, remote_path, local_path)
  end

  @doc delegate_to: {Operations.DownloadFile, :download_file, 3}
  def download_file(conn, remote_path, local_path) do
    driver().download_file(conn, remote_path, local_path)
  end

  @doc delegate_to: {Operations.FileInfo, :file_info!, 2}
  def file_info!(conn, path) do
    driver().file_info!(conn, path)
  end

  @doc delegate_to: {Operations.FileInfo, :file_info, 2}
  def file_info(conn, path) do
    driver().file_info(conn, path)
  end

  @doc delegate_to: {Operations.LinkInfo, :link_info!, 2}
  def link_info!(conn, path) do
    driver().link_info!(conn, path)
  end

  @doc delegate_to: {Operations.LinkInfo, :link_info, 2}
  def link_info(conn, path) do
    driver().link_info(conn, path)
  end

  @doc delegate_to: {Operations.ListDir, :list_dir!, 2}
  def list_dir!(conn, path) do
    driver().list_dir!(conn, path)
  end

  @doc delegate_to: {Operations.ListDir, :list_dir, 2}
  def list_dir(conn, path) do
    driver().list_dir(conn, path)
  end

  @doc delegate_to: {Operations.MakeDir, :make_dir!, 2}
  def make_dir!(conn, path) do
    driver().make_dir!(conn, path)
  end

  @doc delegate_to: {Operations.MakeDir, :make_dir, 2}
  def make_dir(conn, path) do
    driver().make_dir(conn, path)
  end

  @doc delegate_to: {Operations.MakeLink, :make_link!, 3}
  def make_link!(conn, symlink_path, target_path) do
    driver().make_link!(conn, symlink_path, target_path)
  end

  @doc delegate_to: {Operations.MakeLink, :make_link, 3}
  def make_link(conn, symlink_path, target_path) do
    driver().make_link(conn, symlink_path, target_path)
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir!, 2}
  def open_dir!(conn, path) do
    driver().open_dir!(conn, path)
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir!, 3}
  def open_dir!(conn, path, fun) do
    driver().open_dir!(conn, path, fun)
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir, 2}
  def open_dir(conn, path) do
    driver().open_dir(conn, path)
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir, 3}
  def open_dir(conn, path, fun) do
    driver().open_dir(conn, path, fun)
  end

  @doc delegate_to: {Operations.OpenFile, :open_file!, 3}
  def open_file!(conn, path, modes) do
    driver().open_file!(conn, path, modes)
  end

  @doc delegate_to: {Operations.OpenFile, :open_file!, 4}
  def open_file!(conn, path, modes, fun) do
    driver().open_file!(conn, path, modes, fun)
  end

  @doc delegate_to: {Operations.OpenFile, :open_file, 3}
  def open_file(conn, path, modes) do
    driver().open_file(conn, path, modes)
  end

  @doc delegate_to: {Operations.OpenFile, :open_file, 4}
  def open_file(conn, path, modes, fun) do
    driver().open_file(conn, path, modes, fun)
  end

  @doc delegate_to: {Operations.ReadFileChunk, :read_file_chunk!, 2}
  def read_file_chunk!(handle, length) do
    driver().read_file_chunk!(handle, length)
  end

  @doc delegate_to: {Operations.ReadFileChunk, :read_file_chunk, 2}
  def read_file_chunk(handle, length) do
    driver().read_file_chunk(handle, length)
  end

  @doc delegate_to: {Operations.ReadFile, :read_file!, 2}
  def read_file!(conn, path) do
    driver().read_file!(conn, path)
  end

  @doc delegate_to: {Operations.ReadFile, :read_file, 2}
  def read_file(conn, path) do
    driver().read_file(conn, path)
  end

  @doc delegate_to: {Operations.ReadLink, :read_link!, 2}
  def read_link!(conn, path) do
    driver().read_link!(conn, path)
  end

  @doc delegate_to: {Operations.ReadLink, :read_link, 2}
  def read_link(conn, path) do
    driver().read_link(conn, path)
  end

  @doc delegate_to: {Operations.Rename, :rename!, 3}
  def rename!(conn, old_path, new_path) do
    driver().rename!(conn, old_path, new_path)
  end

  @doc delegate_to: {Operations.Rename, :rename, 3}
  def rename(conn, old_path, new_path) do
    driver().rename(conn, old_path, new_path)
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file!, 3}
  def stream_file!(conn, path, chunk_size) do
    driver().stream_file!(conn, path, chunk_size)
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file!, 2}
  def stream_file!(conn, path) do
    driver().stream_file!(conn, path)
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file, 3}
  def stream_file(conn, path, chunk_size) do
    driver().stream_file(conn, path, chunk_size)
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file, 2}
  def stream_file(conn, path) do
    driver().stream_file(conn, path)
  end

  @doc delegate_to: {Operations.UploadFile, :upload_file!, 3}
  def upload_file!(conn, local_path, remote_path) do
    driver().upload_file!(conn, local_path, remote_path)
  end

  @doc delegate_to: {Operations.UploadFile, :upload_file, 3}
  def upload_file(conn, local_path, remote_path) do
    driver().upload_file(conn, local_path, remote_path)
  end

  @doc delegate_to: {Operations.WriteFileChunk, :write_file_chunk!, 2}
  def write_file_chunk!(handle, data) do
    driver().write_file_chunk!(handle, data)
  end

  @doc delegate_to: {Operations.WriteFileChunk, :write_file_chunk, 2}
  def write_file_chunk(handle, data) do
    driver().write_file_chunk(handle, data)
  end

  @doc delegate_to: {Operations.WriteFile, :write_file!, 3}
  def write_file!(conn, path, data) do
    driver().write_file!(conn, path, data)
  end

  @doc delegate_to: {Operations.WriteFile, :write_file, 3}
  def write_file(conn, path, data) do
    driver().write_file(conn, path, data)
  end
end
