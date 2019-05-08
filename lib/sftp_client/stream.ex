defmodule SFTPClient.Stream do
  @moduledoc """
  A stream pointing to a file on an SFTP server.
  """

  defstruct [:conn, :path, chunk_size: 32768]

  require Logger

  alias SFTPClient.Conn

  @type t :: %__MODULE__{
          conn: Conn.t(),
          path: String.t(),
          chunk_size: non_neg_integer
        }

  @doc """
  Gets a stream that reads a file from the remote server in chunks.
  """
  @spec readable_stream(t) :: Enumerable.t()
  def readable_stream(%__MODULE__{} = stream) do
    Stream.resource(
      fn -> open_file(stream) end,
      fn handle -> read_chunk(stream, handle) end,
      &SFTPClient.close_handle!/1
    )
  end

  defp open_file(stream) do
    SFTPClient.open_file!(stream.conn, stream.path, [:read, :binary])
  end

  defp read_chunk(stream, handle) do
    case SFTPClient.read_file_chunk(handle, stream.chunk_size) do
      :eof ->
        {:halt, handle}

      {:ok, chunk} ->
        {[chunk], handle}

      {:error, error} ->
        Logger.error(Exception.message(error))
        raise IO.StreamError, reason: :terminated
    end
  end
end

defimpl Enumerable, for: SFTPClient.Stream do
  alias SFTPClient.Stream, as: SFTPStream

  def reduce(stream, acc, fun) do
    SFTPStream.readable_stream(stream).(acc, fun)
  end

  def count(_stream), do: {:error, __MODULE__}
  def member?(_stream, _term), do: {:error, __MODULE__}
  def slice(_stream), do: {:error, __MODULE__}
end

defimpl Collectable, for: SFTPClient.Stream do
  require Logger

  def into(stream) do
    with {:ok, handle} <-
           SFTPClient.open_file(stream.conn, stream.path, [
             :write,
             :creat,
             :binary
           ]) do
      {:ok, collect_fun(stream, handle)}
    end
  end

  defp collect_fun(stream, handle) do
    fn
      :ok, {:cont, data} ->
        SFTPClient.write_file_chunk!(handle, data)

      :ok, :done ->
        SFTPClient.close_handle!(handle)
        stream

      :ok, :halt ->
        SFTPClient.close_handle!(handle)
    end
  end
end
