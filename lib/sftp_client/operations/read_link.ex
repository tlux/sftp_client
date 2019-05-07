defmodule SFTPClient.Operations.ReadLink do
  use SFTPClient.Operation

  @spec read_link(Conn.t(), String.t()) :: {:ok, String.t()} | {:error, any}
  def read_link(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_link(String.to_charlist(path))
    |> case do
      {:ok, target} -> {:ok, to_string(target)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec read_link!(Conn.t(), String.t()) :: String.t() | no_return
  def read_link!(%Conn{} = conn, path) do
    conn |> read_link(path) |> may_bang!()
  end
end
