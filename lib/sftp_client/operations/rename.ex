defmodule SFTPClient.Operations.Rename do
  @moduledoc """
  A module that provides functions to rename files and directories on an SFTP
  server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Renames a file named `old_path` and gives it the name specified by `new_path`.
  """
  @spec rename(Conn.t(), Path.t(), Path.t()) ::
          :ok | {:error, SFTPClient.error()}
  def rename(%Conn{} = conn, old_path, new_path) do
    conn.channel_pid
    |> sftp_adapter().rename(
      to_charlist(old_path),
      to_charlist(new_path),
      conn.config.operation_timeout
    )
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Renames a file named `old_path` and gives it the name specified by `new_path`.
  Raises when the operation fails.
  """
  @spec rename!(Conn.t(), Path.t(), Path.t()) :: :ok | no_return
  def rename!(%Conn{} = conn, old_path, new_path) do
    conn |> rename(old_path, new_path) |> may_bang!()
  end
end
