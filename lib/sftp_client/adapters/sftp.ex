defmodule SFTPClient.Adapters.SFTP do
  @callback start_channel(
              host :: charlist,
              port :: non_neg_integer,
              opts :: Keyword.t()
            ) :: {:ok, pid, pid} | {:error, any}

  @callback stop_channel(channel_pid :: pid) :: :ok

  @callback file_info(channel_pid :: pid) ::
              {:ok, :ssh_sftp.file_info()} | {:error, any}

  @callback list_dir(channel_pid :: pid, path :: charlist) ::
              {:ok, [charlist]} | {:error, any}

  @callback read_dir(channel_pid :: pid, path :: charlist) ::
              {:ok, binary} | {:error, any}

  @callback close(channel_pid :: pid, handle :: term) :: :ok | {:error, any}

  @callback del_dir(channel_pid :: pid, path :: charlist) :: :ok | {:error, any}

  @callback delete(channel_pid :: pid, path :: charlist) :: :ok | {:error, any}

  @callback open(
              channel_pid :: pid,
              path :: charlist,
              modes :: [SFTPClient.access_mode()]
            ) :: {:ok, term} | {:error, any}

  @callback read(channel_pid :: pid, handle :: term, length :: non_neg_integer) ::
              {:ok, binary} | {:error, any}

  @callback read_file_info(channel_pid :: pid, path :: charlist) ::
              {:ok, term} | {:error, any}
end
