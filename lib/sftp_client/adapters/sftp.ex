defmodule SFTPClient.Adapters.SFTP do
  @behaviour SFTPClient.Adapter

  alias SFTPClient.Session

  @impl true
  def connect(config) do
    # TODO: Move :ssh.start/0 to supervision tree?
    with :ok <- :ssh.start(),
         {:ok, channel_pid, conn_ref} <- do_connect(config) do
      {:ok,
       %Session{config: config, channel_pid: channel_pid, conn_ref: conn_ref}}
    end
  end

  defp do_connect(config) do
    :ssh_sftp.start_channel(
      String.to_charlist(config.host),
      config.port,
      [
        {:key_cb, {SFTPClient.KeyProvider, config: config}},
        {:quiet_mode, true},
        {:silently_accept_hosts, true},
        {:user_interaction, false} | handle_opts(config)
      ]
    )
  end

  defp handle_opts(config) do
    config
    |> Map.from_struct()
    |> Map.take([:user, :password, :user_dir, :system_dir, :inet])
    |> Enum.reduce([], fn
      {_key, nil}, opts ->
        opts

      {key, value}, opts when is_binary(value) ->
        [{key, String.to_charlist(value)} | opts]

      {key, value}, opts ->
        [{key, value} | opts]
    end)
  end

  @impl true
  def disconnect(session) do
    :ok = :ssh_sftp.stop_channel(session.channel_pid)
    :ok = :ssh.close(session.conn_ref)
  end

  @impl true
  def read_file(session, path) do
    path = String.to_charlist(path)

    with {:ok, handle} <-
           :ssh_sftp.open(session.channel_pid, path, [:read, :binary]) do
      handle
    end
  end
end
