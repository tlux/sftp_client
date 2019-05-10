defmodule SFTPClient.Operations.DeleteFile do
  @moduledoc """
  A module containing operations to delete a file from the remote server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Deletes the file specified by path.
  """
  @spec delete_file(Conn.t(), Path.t()) :: :ok | {:error, any}
  def delete_file(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().delete(to_charlist(path), conn.config.operation_timeout)
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Deletes the file specified by path. Raises when the operation fails.
  """
  @spec delete_file!(Conn.t(), Path.t()) :: :ok | no_return
  def delete_file!(%Conn{} = conn, path) do
    conn |> delete_file(path) |> may_bang!()
  end
end
