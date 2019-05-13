defmodule SFTPClient.Adapter.SFTP do
  @moduledoc """
  A behavior that defines required callbacks for a low-level SFTP adapter.
  """

  @callback start_channel(
              host :: charlist,
              port :: non_neg_integer,
              opts :: Keyword.t()
            ) :: {:ok, pid, pid} | {:error, any}

  @callback stop_channel(channel_pid :: pid) :: :ok

  @callback list_dir(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, [charlist]} | {:error, any}

  @callback close(channel_pid :: pid, handle :: term, timeout) ::
              :ok | {:error, any}

  @callback del_dir(channel_pid :: pid, path :: charlist, timeout) ::
              :ok | {:error, any}

  @callback delete(channel_pid :: pid, path :: charlist, timeout) ::
              :ok | {:error, any}

  @callback open(
              channel_pid :: pid,
              path :: charlist,
              modes :: [SFTPClient.access_mode()],
              timeout
            ) :: {:ok, term} | {:error, any}

  @callback read(
              channel_pid :: pid,
              handle :: term,
              length :: non_neg_integer,
              timeout
            ) ::
              {:ok, binary} | :eof | {:error, any}

  @callback readdir(channel_pid :: pid, handle :: term, timeout) ::
              {:ok, binary} | {:error, any}

  @callback read_file_info(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, term} | {:error, any}

  @callback read_link_info(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, term} | {:error, any}

  @callback list_dir(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, [charlist]} | {:error, any}

  @callback make_dir(channel_pid :: pid, path :: charlist, timeout) ::
              :ok | {:error, any}

  @callback make_link(
              channel_pid :: pid,
              symlink_path :: charlist,
              target_path :: charlist,
              timeout
            ) :: :ok | {:error, any}

  @callback opendir(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, term} | {:error, any}

  @callback read_file(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, binary} | {:error, any}

  @callback read_link(channel_pid :: pid, path :: charlist, timeout) ::
              {:ok, charlist} | {:error, any}

  @callback rename(
              channel_pid :: pid,
              old_path :: charlist,
              new_path :: charlist,
              timeout
            ) :: :ok | {:error, any}

  @callback write_file(
              channel_pid :: pid,
              path :: charlist,
              data :: [binary],
              timeout
            ) ::
              :ok | {:error, any}

  @callback write(channel_pid :: pid, path :: charlist, data :: binary, timeout) ::
              :ok | {:error, any}
end
