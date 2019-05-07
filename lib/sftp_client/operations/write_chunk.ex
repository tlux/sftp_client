defmodule SFTPClient.Operations.WriteChunk do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @spec write_chunk(Handle.t(), non_neg_integer) :: :ok | {:error, any}
  def write_chunk(%Handle{} = handle, data) do
    sftp_adapter().write(handle.conn.channel_pid, handle.id, data)
  end

  @spec write_chunk!(Handle.t(), non_neg_integer) :: :ok | no_return
  def write_chunk!(%Handle{} = handle, data) do
    handle |> write_chunk(data) |> bangify!()
  end
end
