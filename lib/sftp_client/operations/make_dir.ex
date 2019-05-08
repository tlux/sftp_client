defmodule SFTPClient.Operations.MakeDir do
  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Creates a directory specified by path. The path must be a full path to a new
  directory. The directory can only be created in an existing directory.
  """
  @spec make_dir(Conn.t(), String.t()) :: :ok | {:error, any}
  def make_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().make_dir(to_charlist(path))
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Creates a directory specified by path. The path must be a full path to a new
  directory. The directory can only be created in an existing directory. Raises
  when the operation fails.
  """
  @spec make_dir!(Conn.t(), String.t()) :: :ok | no_return
  def make_dir!(%Conn{} = conn, path) do
    conn |> make_dir(path) |> may_bang!()
  end
end
