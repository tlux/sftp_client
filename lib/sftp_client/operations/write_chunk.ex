defmodule SFTPClient.Operations.WriteChunk do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @doc """
  Writes data to the file referenced by handle. The file is to be opened with
  write or append flag.
  """
  @spec write_chunk(Handle.t(), binary) :: :ok | {:error, any}
  def write_chunk(%Handle{} = handle, data) do
    sftp_adapter().write(handle.conn.channel_pid, handle.id, data)
  end

  @doc """
  Writes data to the file referenced by handle. The file is to be opened with
  write or append flag. Raises when the operation fails.
  """
  @spec write_chunk!(Handle.t(), binary) :: :ok | no_return
  def write_chunk!(%Handle{} = handle, data) do
    handle |> write_chunk(data) |> may_bang!()
  end
end
