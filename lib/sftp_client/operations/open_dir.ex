defmodule SFTPClient.Operations.OpenDir do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @doc """
  Opens a handle to a directory on the server. The handle can be used for
  reading directory contents.
  """
  @spec open_dir(Conn.t(), String.t()) ::
          {:ok, Handle.t()} | {:error, any}
  def open_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().opendir(to_charlist(path))
    |> case do
      {:ok, handle} ->
        {:ok, %Handle{id: handle, conn: conn, path: to_string(path)}}

      {:error, error} ->
        {:error, handle_error(error)}
    end
  end

  @doc """
  Opens a handle to a directory on the server. The handle can be used for
  reading directory contents. Raises when the operation fails.
  """
  @spec open_dir!(Conn.t(), String.t()) :: Handle.t() | no_return
  def open_dir!(%Conn{} = conn, path) do
    conn |> open_dir(path) |> may_bang!()
  end
end
