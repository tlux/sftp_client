defmodule SFTPClient.Operations.ListDir do
  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Lists the given directory on the server, returning the filenames as a list of
  strings.
  """
  @spec list_dir(Conn.t(), String.t()) :: {:ok, [String.t()]} | {:error, any}
  def list_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().list_dir(to_charlist(path))
    |> case do
      {:ok, entries} -> {:ok, process_entries(entries)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Lists the given directory on the server, returning the filenames as a list of
  strings. Raises when the operation fails.
  """
  @spec list_dir!(Conn.t(), String.t()) :: [String.t()] | no_return
  def list_dir!(%Conn{} = conn, path) do
    conn |> list_dir(path) |> may_bang!()
  end

  defp process_entries(entries) do
    entries
    |> Stream.reject(&(&1 in ['.', '..']))
    |> Stream.map(&to_string/1)
    |> Enum.sort()
  end
end
