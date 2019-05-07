defmodule SFTPClient.Operations.ReadFile do
  use SFTPClient.Operation

  def read_file(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_file(String.to_charlist(path))
    |> case do
      {:ok, content} -> {:ok, content}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  def read_file!(%Conn{} = conn, path) do
    conn |> read_file(path) |> bangify!()
  end
end
