defmodule SFTPClient.Operations.ReadDir do
  use SFTPClient.Operation

  alias SFTPClient.Handle

  @doc """
  Reads the directory contents from the server, and returns the data as String.
  """
  @spec read_dir(Handle.t()) :: {:ok, [any]} | {:error, any}
  def read_dir(%Handle{} = handle) do
    handle.conn.channel_pid
    |> sftp_adapter().readdir(handle.id)
    |> case do
      {:ok, content} -> {:ok, content}
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
end
