defmodule SFTPClient.Operations.Connect do
  use SFTPClient.Operation

  alias SFTPClient.Config
  alias SFTPClient.KeyProvider

  @doc """
  Connects to an SFTP server.

  ## Options

  * `:host` (required) - The host of the SFTP server.
  * `:port` - The port of the SFTP server, defaults to 22.
  * `:user` - The user to authenticate as, when omitted tries to determine the
    current user.
  * `:password` - The password for the user.
  * `:user_dir` - The directory to read private keys from.
  * `:inet` - The IP version to use, either `:inet` (default) or `:inet6`.
  * `:private_key_path` - The path to the private key to use for authentication.
  * `:private_key_passphrase` - The passphrase that is used to decrypt the
    private key.
  """
  @spec connect(Config.t() | Keyword.t()) :: {:ok, Conn.t()} | {:error, term}
  def connect(config_or_opts) do
    config = Config.new(config_or_opts)

    case do_connect(config) do
      {:ok, channel_pid, conn_ref} ->
        {:ok,
         %Conn{
           config: config,
           channel_pid: channel_pid,
           conn_ref: conn_ref
         }}

      {:error, error} ->
        {:error, handle_error(error)}
    end
  end

  @doc """
  Connects to an SFTP server, raising on errors.

  ## Options

  * `:host` (required) - The host of the SFTP server.
  * `:port` - The port of the SFTP server, defaults to 22.
  * `:user` - The user to authenticate as, when omitted tries to determine the
    current user.
  * `:password` - The password for the user.
  * `:user_dir` - The directory to read private keys from.
  * `:inet` - The IP version to use, either `:inet` (default) or `:inet6`.
  * `:private_key_path` - The path to the private key to use for authentication.
  * `:private_key_passphrase` - The passphrase that is used to decrypt the
    private key.
  """
  @spec connect!(Config.t() | Keyword.t()) :: Conn.t() | no_return
  def connect!(config_or_opts) do
    config_or_opts |> connect() |> bangify!()
  end

  defp do_connect(config) do
    sftp_adapter().start_channel(
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
    |> Map.take([:user, :password, :user_dir, :inet])
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

  defp map_opt_value(:user_dir, value), do: Path.expand(value)
  defp map_opt_value(_key, value), do: value

  defp dump_opt_value(value) when is_binary(value) do
    String.to_charlist(value)
  end

  defp dump_opt_value(value), do: value
end
