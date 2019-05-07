defmodule SFTPClient.Operations.ReadChunk do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @spec read_chunk(Handle.t(), non_neg_integer) ::
          {:ok, String.t()} | :eof | {:error, any}
  def read_chunk(%Handle{} = handle, length) do
    sftp_adapter().read(handle.conn.channel_pid, handle.id, length)
  end

  @spec read_chunk!(Handle.t(), non_neg_integer) ::
          String.t() | :eof | no_return
  def read_chunk!(%Handle{} = handle, length) do
    case read_chunk(handle, length) do
      :eof -> :eof
      result -> bangify!(result)
    end
  end
end
