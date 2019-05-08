defmodule SFTPClient.Operations.ReadFile do
  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Reads a file from the server, and returns the data as String.
  """
  @spec read_file(Conn.t(), String.t()) :: {:ok, binary} | {:error, any}
  def read_file(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_file(to_charlist(path))
    |> case do
      {:ok, content} -> {:ok, content}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Reads a file from the server, and returns the data as String. Raises when the
  operation fails.
  """
  @spec read_file!(Conn.t(), String.t()) :: binary | no_return
  def read_file!(%Conn{} = conn, path) do
    conn |> read_file(path) |> may_bang!()
  end
end
