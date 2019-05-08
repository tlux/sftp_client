defmodule SFTPClient.Operations.OpenFile do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing.
  """
  @spec open_file(Conn.t(), String.t(), [SFTPClient.access_mode()]) ::
          {:ok, Handle.t()} | {:error, any}
  def open_file(%Conn{} = conn, path, modes) do
    conn.channel_pid
    |> sftp_adapter().open(to_charlist(path), modes)
    |> case do
      {:ok, handle} -> {:ok, %Handle{id: handle, conn: conn}}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing. Raises when the operation fails.
  """
  @spec open_file!(Conn.t(), String.t(), [SFTPClient.access_mode()]) ::
          Handle.t() | no_return
  def open_file!(%Conn{} = conn, path, modes) do
    conn |> open_file(path, modes) |> may_bang!()
  end
end
