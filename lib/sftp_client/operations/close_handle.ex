defmodule SFTPClient.Operations.CloseHandle do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @doc """
  Closes a handle to an open file or directory on the server.
  """
  @spec close_handle(Handle.t()) :: :ok | {:error, any}
  def close_handle(%Handle{} = handle) do
    handle.conn.channel_pid
    |> sftp_adapter().close(handle.id)
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Closes a handle to an open file or directory on the server. Raises when the
  operation fails.
  """
  @spec close_handle!(Handle.t()) :: :ok | no_return
  def close_handle!(%Handle{} = handle) do
    handle |> close_handle() |> may_bang!()
  end
end
