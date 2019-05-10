defmodule SFTPClient.Operations.OpenDir do
  @moduledoc """
  A module that provides functions to open a directory on an SFTP server in
  order to list their contents.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn
  alias SFTPClient.Handle

  @doc """
  Opens a handle to a directory on the server. The handle can be used for
  reading directory contents.
  """
  @spec open_dir(Conn.t(), String.t()) :: {:ok, Handle.t()} | {:error, any}
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
  reading directory contents. Then runs the function and closes the handle when
  finished.
  """
  @spec open_dir(Conn.t(), String.t(), (Handle.t() -> res)) ::
          {:ok, res} | {:error, any} when res: var
  def open_dir(%Conn{} = conn, path, fun) do
    with {:ok, handle} = open_dir(conn, path) do
      {:ok, run_callback(handle, fun)}
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

  @doc """
  Opens a handle to a directory on the server. The handle can be used for
  reading directory contents. Then runs the function and closes the handle when
  finished. Raises when the operation fails.
  """
  @spec open_dir(Conn.t(), String.t(), (Handle.t() -> res)) ::
          res | no_return when res: var
  def open_dir!(%Conn{} = conn, path, fun) do
    conn
    |> open_dir!(path)
    |> run_callback(fun)
  end

  defp run_callback(handle, fun) do
    fun.(handle)
  after
    SFTPClient.close_handle!(handle)
  end
end
