defmodule SFTPClient.Operations.CloseHandle do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @spec close_handle(Handle.t()) :: :ok | {:error, any}
  def close_handle(%Handle{} = handle) do
    handle.conn.channel_pid
    |> sftp_adapter().close(handle.id)
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec close_handle!(Handle.t()) :: :ok | no_return
  def close_handle!(%Handle{} = handle) do
    handle |> close_handle() |> bangify!()
  end
end
