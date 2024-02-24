defmodule SFTPClient.Operations.ReadDir do
  @moduledoc """
  A module that provides functions to read a list of directories on an SFTP
  server from a given file handle.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Entry
  alias SFTPClient.Handle
  alias SFTPClient.SSHXferAttr

  @doc """
  Reads the directory contents from the server, and returns the data as String.
  """
  @spec read_dir(Handle.t()) ::
          {:ok, [any]} | :eof | {:error, SFTPClient.error()}
  def read_dir(%Handle{} = handle) do
    handle.conn.channel_pid
    |> sftp_adapter().readdir(handle.id, handle.conn.config.operation_timeout)
    |> case do
      {:ok, entries} -> {:ok, process_entries(entries, handle.path)}
      {:error, error} -> {:error, handle_error(error)}
      :eof -> :eof
    end
  end

  @doc """
  Reads a file from the server, and returns the data as String. Raises when the
  operation fails.
  """
  @spec read_dir!(Handle.t()) :: [any] | :eof | no_return
  def read_dir!(%Handle{} = handle) do
    case read_dir(handle) do
      :eof -> :eof
      result -> may_bang!(result)
    end
  end

  defp process_entries(entries, dir_path) do
    entries
    |> Stream.reject(fn {filename, _} -> filename in [~c".", ~c".."] end)
    |> Stream.map(fn {filename, xfer_attr} ->
      filename = to_string(filename)

      %Entry{
        filename: filename,
        path: Path.join(dir_path, filename),
        stat: SSHXferAttr.from_record(xfer_attr)
      }
    end)
    |> Enum.to_list()
  end
end
