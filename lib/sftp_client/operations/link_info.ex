defmodule SFTPClient.Operations.LinkInfo do
  use SFTPClient.Operation

  alias File.Stat, as: FileStat

  @spec link_info(Conn.t(), String.t()) :: {:ok, FileStat.t()} | {:error, any}
  def link_info(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_link_info(String.to_charlist(path))
    |> case do
      {:ok, link_info} -> {:ok, FileStat.from_record(link_info)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @spec link_info!(Conn.t(), String.t()) :: FileStat.t() | no_return
  def link_info!(%Conn{} = conn, path) do
    conn |> link_info(path) |> may_bang!()
  end
end
