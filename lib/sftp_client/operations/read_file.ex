defmodule SFTPClient.Operations.ReadFile do
  use SFTPClient.Operation

  @spec read_file(Conn.t(), String.t()) :: {:ok, String.t()} | {:error, any}
  def read_file(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_file(String.to_charlist(path))
    |> case do
      {:ok, content} -> {:ok, content}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec read_file!(Conn.t(), String.t()) :: String.t() | no_return
  def read_file!(%Conn{} = conn, path) do
    conn |> read_file(path) |> may_bang!()
  end
end
