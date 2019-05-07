defmodule SFTPClient.Operations.WriteFile do
  use SFTPClient.Operation

  @doc """
  Reads a file from the server, and returns the data as String.
  """
  @spec write_file(Conn.t(), String.t(), String.t() | [String.t()]) ::
          :ok | {:error, any}
  def write_file(%Conn{} = conn, path, data) when is_binary(data) do
    write_file(conn, path, [data])
  end

  def write_file(%Conn{} = conn, path, iolist) do
    conn.channel_pid
    |> sftp_adapter().write_file(String.to_charlist(path), Enum.to_list(iolist))
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Reads a file from the server, and returns the data as String. Raises when the
  operation fails.
  """
  @spec write_file!(Conn.t(), String.t(), String.t() | [String.t()]) ::
          :ok | no_return
  def write_file!(%Conn{} = conn, path, data) do
    conn |> write_file(path, data) |> may_bang!()
  end
end
