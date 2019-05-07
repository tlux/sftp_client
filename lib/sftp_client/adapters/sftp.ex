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
end
