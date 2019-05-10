defmodule SFTPClient.Operations.LinkInfo do
  @moduledoc """
  A module that provides functions to retrieve information on symbolic links
  from an SFTP server.
  """

  import SFTPClient.OperationUtil

  alias File.Stat, as: FileStat
  alias SFTPClient.Conn

  @doc """
  Returns a `File.Stat` struct from the remote symbolic link object specified by
  path.
  """
  @spec link_info(Conn.t(), Path.t()) :: {:ok, FileStat.t()} | {:error, any}
  def link_info(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().read_link_info(to_charlist(path))
    |> case do
      {:ok, link_info} -> {:ok, FileStat.from_record(link_info)}
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Returns a `File.Stat` struct from the remote symbolic link object specified by
  path. Raises when the operation fails.
  """
  @spec link_info!(Conn.t(), Path.t()) :: FileStat.t() | no_return
  def link_info!(%Conn{} = conn, path) do
    conn |> link_info(path) |> may_bang!()
  end
end
