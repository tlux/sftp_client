defmodule SFTPClient.Operations.DeleteDir do
  @moduledoc """
  A module containing operations to delete a directory from the remote server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Deletes the directory specified by path.
  """
  @spec delete_dir(Conn.t(), Path.t()) :: :ok | {:error, SFTPClient.error()}
  def delete_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().del_dir(to_charlist(path), conn.config.operation_timeout)
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Deletes the directory specified by path. Raises when the operation fails.
  """
  @spec delete_dir!(Conn.t(), Path.t()) :: :ok | no_return
  def delete_dir!(%Conn{} = conn, path) do
    conn |> delete_dir(path) |> may_bang!()
  end
end
