defmodule SFTPClient.Operations.ReadLink do
  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Reads the link target from the symbolic link specified by path.
  """
  @spec read_link(Conn.t(), String.t()) :: {:ok, String.t()} | {:error, any}
  def read_link(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_link(to_charlist(path))
    |> case do
      {:ok, target} -> {:ok, to_string(target)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Reads the link target from the symbolic link specified by path. Raises when
  the operation fails.
  """
  @spec read_link!(Conn.t(), String.t()) :: String.t() | no_return
  def read_link!(%Conn{} = conn, path) do
    conn |> read_link(path) |> may_bang!()
  end
end
