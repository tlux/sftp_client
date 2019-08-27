defmodule SFTPClient.Stream do
  @moduledoc """
  A stream pointing to a file on an SFTP server. Implements the `Enumerable` and
  `Collectable` protocols.
  """

  defstruct [:conn, :path, chunk_size: 32_768]

  require Logger

  alias SFTPClient.Conn
  alias SFTPClient.Operations.CloseHandle
  alias SFTPClient.Operations.OpenFile
  alias SFTPClient.Operations.ReadFileChunk

  @type t :: %__MODULE__{
          conn: Conn.t(),
          path: Path.t(),
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
      &CloseHandle.close_handle!/1
    )
  end

  defp open_file(stream) do
    OpenFile.open_file!(stream.conn, stream.path, [:read, :binary])
  end

  defp read_chunk(stream, handle) do
    case ReadFileChunk.read_file_chunk(handle, stream.chunk_size) do
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
  alias SFTPClient.Operations.CloseHandle
  alias SFTPClient.Operations.OpenFile
  alias SFTPClient.Operations.WriteFileChunk

  def into(stream) do
    handle = open_file(stream)

    collect_fun = fn
      _, {:cont, data} ->
        WriteFileChunk.write_file_chunk!(handle, data)

      _, :done ->
        CloseHandle.close_handle!(handle)
        stream

      _, :halt ->
        CloseHandle.close_handle!(handle)
    end

    {stream, collect_fun}
  end

  defp open_file(stream) do
    OpenFile.open_file!(stream.conn, stream.path, [:write, :creat, :binary])
  end
end
