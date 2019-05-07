defmodule SFTPClient.Adapters.SFTP do
  @behaviour SFTPClient.Adapter

  alias SFTPClient.ConnectionError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.KeyProvider
  alias SFTPClient.OperationError
  alias SFTPClient.Session

  @impl true
  def connect(config) do
    case do_connect(config) do
      {:ok, channel_pid, conn_ref} ->
        {:ok,
         %Session{
           config: config,
           channel_pid: channel_pid,
           conn_ref: conn_ref
         }}

      {:error, error} ->
        {:error, handle_error(error)}
    end
  end

  defp handle_error({:eoptions, {{key, value}, reason}}) do
    %InvalidOptionError{key: key, value: load_opt_value(value), reason: reason}
  end

  defp handle_error(reason) when is_atom(reason) do
    %OperationError{reason: reason}
  end

  defp handle_error(message) do
    %ConnectionError{message: to_string(message)}
  end

  defp do_connect(config) do
    :ssh_sftp.start_channel(
      String.to_charlist(config.host),
      config.port,
      [
        {:key_cb, {KeyProvider, config: config}},
        {:quiet_mode, true},
        {:silently_accept_hosts, true},
        {:user_interaction, false} | handle_opts(config)
      ]
    )
  end

  defp handle_opts(config) do
    config
    |> Map.take([:user, :password, :user_dir, :system_dir, :inet])
    |> Enum.reduce([], fn
      {_key, nil}, opts ->
        opts

      {key, value}, opts ->
        [{key, handle_opt_value(key, value)} | opts]
    end)
  end

  defp handle_opt_value(key, value) do
    key
    |> map_opt_value(value)
    |> dump_opt_value()
  end

  defp map_opt_value(key, value) when key in [:user_dir, :system_dir] do
    Path.expand(value)
  end

  defp map_opt_value(_key, value), do: value

  defp dump_opt_value(value) when is_binary(value) do
    String.to_charlist(value)
  end

  defp dump_opt_value(value), do: value

  defp load_opt_value(value) when is_list(value), do: to_string(value)
  defp load_opt_value(value), do: value

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
