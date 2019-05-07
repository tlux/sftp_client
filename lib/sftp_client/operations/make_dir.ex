defmodule SFTPClient.Operations.MakeDir do
  use SFTPClient.Operation

  @spec make_dir(Conn.t(), String.t()) :: :ok | {:error, any}
  def make_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().make_dir(String.to_charlist(path))
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec make_dir!(Conn.t(), String.t()) :: :ok | no_return
  def make_dir!(%Conn{} = conn, path) do
    conn |> make_dir(path) |> may_bang!()
  end
end
