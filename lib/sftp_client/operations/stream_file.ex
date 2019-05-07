defmodule SFTPClient.Operations.StreamFile do
  use SFTPClient.Operation

  alias SFTPClient.OperationError
  alias SFTPClient.Stream, as: SFTPStream

  @spec stream_file(Conn.t(), String.t()) ::
          {:ok, SFTPStream.t()} | {:error, any}
  def stream_file(%Conn{} = conn, path) do
    stream_file_no_bang(conn, path, [])
  end

  @spec stream_file(Conn.t(), String.t(), non_neg_integer) ::
          {:ok, SFTPStream.t()} | {:error, any}
  def stream_file(%Conn{} = conn, path, chunk_size) do
    stream_file_no_bang(conn, path, [chunk_size])
  end

  defp stream_file_no_bang(conn, path, args) do
    case SFTPClient.file_info(conn, path) do
      {:ok, %{type: :regular}} ->
        {:ok, apply(__MODULE__, :stream_file!, [conn, path | args])}

      {:ok, _} ->
        {:error, %OperationError{reason: :no_such_file}}

      error ->
        error
    end
  end

  @spec stream_file!(Conn.t(), String.t()) :: SFTPStream.t()
  def stream_file!(%Conn{} = conn, path) do
    %SFTPStream{conn: conn, path: path}
  end

  @spec stream_file!(Conn.t(), String.t(), non_neg_integer) :: SFTPStream.t()
  def stream_file!(%Conn{} = conn, path, chunk_size) do
    %SFTPStream{conn: conn, path: path, chunk_size: chunk_size}
  end
end
