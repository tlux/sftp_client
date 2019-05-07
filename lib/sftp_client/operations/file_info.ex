defmodule SFTPClient.Operations.FileInfo do
  use SFTPClient.Operation

  alias File.Stat, as: FileStat

  @spec file_info(Conn.t(), String.t()) :: {:ok, FileStat.t()} | {:error, any}
  def file_info(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_file_info(String.to_charlist(path))
    |> case do
      {:ok, file_info} -> {:ok, FileStat.from_record(file_info)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec file_info!(Conn.t(), String.t()) :: FileStat.t() | no_return
  def file_info!(%Conn{} = conn, path) do
    conn |> file_info(path) |> may_bang!()
  end
end
