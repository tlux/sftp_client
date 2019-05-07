defmodule SFTPClient.Operations.WriteFile do
  use SFTPClient.Operation

  @doc """
  Reads a file from the server, and returns the data as String.
  """
  @spec write_file(Conn.t(), String.t(), String.t() | [String.t()]) ::
          {:ok, String.t()} | {:error, any}
  def write_file(%Conn{} = conn, path, data) when is_list(data) do
    conn.channel_pid
    |> sftp_adapter().write_file(String.to_charlist(path), data)
    |> case do
      {:ok, content} -> {:ok, content}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  def write_file(%Conn{} = conn, path, data) do
    write_file(conn, path, [data])
  end

  @doc """
  Reads a file from the server, and returns the data as String. Raises when the
  operation fails.
  """
  @spec write_file!(Conn.t(), String.t(), String.t() | [String.t()]) ::
          String.t() | no_return
  def write_file!(%Conn{} = conn, path, data) do
    conn |> write_file(path, data) |> may_bang!()
  end
end
