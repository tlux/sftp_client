defmodule SFTPClient.Operations.UploadFile do
  @moduledoc """
  A module that provides functions to upload files to an SFTP server.
  """

  alias SFTPClient.Conn
  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.StreamFile

  @chunk_size 32_768

  @doc """
  Uploads a file from the file system to the server.
  """
  @spec upload_file(Conn.t(), Path.t(), Path.t()) ::
          {:ok, Path.t()} | {:error, SFTPClient.error()}
  def upload_file(%Conn{} = conn, local_path, remote_path) do
    {:ok, upload_file!(conn, local_path, remote_path)}
  rescue
    error in [ConnError, InvalidOptionError, OperationError] ->
      {:error, error}
  end

  @doc """
  Uploads a file from the file system to the server. Raises when the operation
  fails.
  """
  @spec upload_file!(Conn.t(), Path.t(), Path.t()) :: Path.t() | no_return
  def upload_file!(%Conn{} = conn, local_path, remote_path) do
    source_stream = File.stream!(local_path, [], @chunk_size)
    target_stream = StreamFile.stream_file!(conn, remote_path)

    source_stream
    |> Stream.into(target_stream)
    |> Stream.run()

    remote_path
  end
end
