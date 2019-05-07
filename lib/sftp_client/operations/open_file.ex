defmodule SFTPClient.Operations.OpenFile do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @type mode :: :read | :write | :creat | :trunc | :append | :binary

  @spec open_file(Conn.t(), String.t(), [mode]) ::
          {:ok, Handle.t()} | {:error, any}
  def open_file(%Conn{} = conn, path, modes) do
    conn.channel_pid
    |> sftp_adapter().open(String.to_charlist(path), modes)
    |> case do
      {:ok, handle} -> {:ok, %Handle{id: handle, conn: conn}}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec open_file!(Conn.t(), String.t(), [mode]) :: Handle.t() | no_return
  def open_file!(%Conn{} = conn, path, modes) do
    conn |> open_file(path, modes) |> bangify!()
  end
end
