defmodule SFTPClient.Operations.OpenFile do
  @moduledoc """
  A module that provides functions to open a file on an SFTP server in  order to
  read their contents.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn
  alias SFTPClient.Handle

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing.
  """
  @spec open_file(Conn.t(), Path.t(), [SFTPClient.access_mode()]) ::
          {:ok, Handle.t()} | {:error, any}
  def open_file(%Conn{} = conn, path, modes) do
    conn.channel_pid
    |> sftp_adapter().open(
      to_charlist(path),
      modes,
      conn.config.operation_timeout
    )
    |> case do
      {:ok, handle} ->
        {:ok, %Handle{id: handle, conn: conn, path: to_string(path)}}

      {:error, error} ->
        {:error, handle_error(error)}
    end
  end

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing, then runs the function and closes the handle when finished.
  """
  @spec open_file(
          Conn.t(),
          Path.t(),
          [SFTPClient.access_mode()],
          (Handle.t() -> res)
        ) :: {:ok, res} | {:error, any}
        when res: var
  def open_file(%Conn{} = conn, path, modes, fun) do
    with {:ok, handle} = open_file(conn, path, modes) do
      {:ok, run_callback(handle, fun)}
    end
  end

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing. Raises when the operation fails.
  """
  @spec open_file!(Conn.t(), Path.t(), [SFTPClient.access_mode()]) ::
          Handle.t() | no_return
  def open_file!(%Conn{} = conn, path, modes) do
    conn |> open_file(path, modes) |> may_bang!()
  end

  @doc """
  Opens a file on the server and returns a handle, which can be used for reading
  or writing, then runs the function and closes the handle when finished. Raises
  when the operation fails.
  """
  @spec open_file(
          Conn.t(),
          Path.t(),
          [SFTPClient.access_mode()],
          (Handle.t() -> res)
        ) :: res | no_return
        when res: var
  def open_file!(%Conn{} = conn, path, modes, fun) do
    conn
    |> open_file!(path, modes)
    |> run_callback(fun)
  end

  defp run_callback(handle, fun) do
    fun.(handle)
  after
    SFTPClient.close_handle!(handle)
  end
end
