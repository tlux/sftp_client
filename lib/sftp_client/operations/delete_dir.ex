defmodule SFTPClient.Operations.DeleteDir do
  @moduledoc """
  Module containing operations to delete a directory from the remote server.
  """

  use SFTPClient.Operation

  @doc """
  Deletes the directory specified by path.
  """
  @spec delete_dir(Conn.t(), String.t()) :: :ok | {:error, any}
  def delete_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().del_dir(to_charlist(path))
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Deletes the directory specified by path. Raises when the operation fails.
  """
  @spec delete_dir!(Conn.t(), String.t()) :: :ok | no_return
  def delete_dir!(%Conn{} = conn, path) do
    conn |> delete_dir(path) |> may_bang!()
  end
end
