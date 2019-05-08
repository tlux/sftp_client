defmodule SFTPClient.Operations.ReadFileChunk do
  import SFTPClient.OperationUtil

  alias SFTPClient.Handle

  @doc """
  Reads the given number of bytes (length) from the file referenced by handle.
  If the file is read past eof, only the remaining bytes are read and returned.
  If no bytes are read, `:eof` is returned.
  """
  @spec read_file_chunk(Handle.t(), non_neg_integer) ::
          {:ok, String.t()} | :eof | {:error, any}
  def read_file_chunk(%Handle{} = handle, length) do
    case sftp_adapter().read(handle.conn.channel_pid, handle.id, length) do
      {:error, error} -> {:error, handle_error(error)}
      result -> result
    end
  end

  @doc """
  Reads the given number of bytes (length) from the file referenced by handle.
  If the file is read past eof, only the remaining bytes are read and returned.
  If no bytes are read, `:eof` is returned. Raises when the operation fails.
  """
  @spec read_file_chunk!(Handle.t(), non_neg_integer) ::
          String.t() | :eof | no_return
  def read_file_chunk!(%Handle{} = handle, length) do
    case read_file_chunk(handle, length) do
      :eof -> :eof
      result -> may_bang!(result)
    end
  end
end
