defmodule SFTPClient.Operations.ReadDir do
  import SFTPClient.OperationUtil

  alias SFTPClient.DirEntry
  alias SFTPClient.Handle
  alias SFTPClient.SSHXferAttr

  @doc """
  Reads the directory contents from the server, and returns the data as String.
  """
  @spec read_dir(Handle.t()) :: {:ok, [any]} | {:error, any}
  def read_dir(%Handle{} = handle) do
    handle.conn.channel_pid
    |> sftp_adapter().readdir(handle.id)
    |> case do
      {:ok, entries} -> {:ok, process_entries(entries, handle.path)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Reads a file from the server, and returns the data as String. Raises when the
  operation fails.
  """
  @spec read_dir!(Handle.t()) :: [any] | no_return
  def read_dir!(%Handle{} = handle) do
    handle |> read_dir() |> may_bang!()
  end

  defp process_entries(entries, dir_path) do
    entries
    |> Stream.reject(fn {filename, _} -> filename in ['.', '..'] end)
    |> Stream.map(fn {filename, xfer_attr} ->
      filename = to_string(filename)

      %DirEntry{
        filename: filename,
        path: Path.join(dir_path, filename),
        stat: SSHXferAttr.from_record(xfer_attr)
      }
    end)
    |> Enum.to_list()
  end
end
