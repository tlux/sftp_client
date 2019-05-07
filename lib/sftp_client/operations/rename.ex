defmodule SFTPClient.Operations.Rename do
  use SFTPClient.Operation

  @spec rename(Conn.t(), String.t(), String.t()) :: :ok | {:error, any}
  def rename(%Conn{} = conn, old_path, new_path) do
    conn.channel_pid
    |> sftp_adapter().rename(
      String.to_charlist(old_path),
      String.to_charlist(new_path)
    )
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec rename!(Conn.t(), String.t(), String.t()) :: :ok | no_return
  def rename!(%Conn{} = conn, old_path, new_path) do
    conn |> rename(old_path, new_path) |> may_bang!()
  end
end
