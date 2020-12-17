defmodule SFTPClient.Operations.WriteFile do
  @moduledoc """
  A module that provides functions to write file contents to an SFTP server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Writes a file to the given path on the connected server.
  """
  @spec write_file(Conn.t(), Path.t(), binary | [binary]) ::
          :ok | {:error, SFTPClient.error()}
  def write_file(%Conn{} = conn, path, data) when is_binary(data) do
    write_file(conn, path, [data])
  end

  def write_file(%Conn{} = conn, path, iolist) do
    conn.channel_pid
    |> sftp_adapter().write_file(
      to_charlist(path),
      Enum.to_list(iolist),
      conn.config.operation_timeout
    )
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Writes a file to the given path on the connected server. Raises when the
  operation fails.
  """
  @spec write_file!(Conn.t(), Path.t(), String.t() | [String.t()]) ::
          :ok | no_return
  def write_file!(%Conn{} = conn, path, data) do
    conn |> write_file(path, data) |> may_bang!()
  end
end
