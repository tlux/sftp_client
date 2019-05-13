defmodule SFTPClient.Operations.ReadLink do
  @moduledoc """
  A module that provides functions to retrieve the target of a symbolic link on
  an SFTP server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Reads the link target from the symbolic link specified by path.
  """
  @spec read_link(Conn.t(), Path.t()) :: {:ok, Path.t()} | {:error, any}
  def read_link(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_link(
      to_charlist(path),
      conn.config.operation_timeout
    )
    |> case do
      {:ok, target} -> {:ok, to_string(target)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Reads the link target from the symbolic link specified by path. Raises when
  the operation fails.
  """
  @spec read_link!(Conn.t(), Path.t()) :: Path.t() | no_return
  def read_link!(%Conn{} = conn, path) do
    conn |> read_link(path) |> may_bang!()
  end
end
