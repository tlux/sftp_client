defmodule SFTPClient.Operations.DeleteFile do
  @moduledoc """
  Module containing operations to delete a file from the remote server.
  """

  use SFTPClient.Operation

  @doc """
  Deletes the file specified by path.
  """
  @spec delete_file(Conn.t(), String.t()) :: :ok | {:error, any}
  def delete_file(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().delete(to_charlist(path))
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Deletes the file specified by path. Raises when the operation fails.
  """
  @spec delete_file!(Conn.t(), String.t()) :: :ok | no_return
  def delete_file!(%Conn{} = conn, path) do
    conn |> delete_file(path) |> may_bang!()
  end
end
