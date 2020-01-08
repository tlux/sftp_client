defmodule SFTPClient.Operations.Connect do
  @moduledoc """
  A module containing operations to connect to an SSH/SFTP server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Config
  alias SFTPClient.Conn
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.KeyProvider
  alias SFTPClient.Operations.Disconnect

  @doc """
  Connects to an SSH server and opens an SFTP channel.

  ## Options

  * `:host` (required) - The host of the SFTP server.
  * `:port` - The port of the SFTP server, defaults to 22.
  * `:user` - The user to authenticate as, when omitted tries to determine the
    current user.
  * `:password` - The password for the user.
  * `:user_dir` - The directory to read private keys from.
  * `:dsa_pass_phrase` - The passphrase for an DSA private key from the
    specified user dir.
  * `:rsa_pass_phrase` - The passphrase for an RSA private key from the
    specified user dir.
  * `:ecdsa_pass_phrase` - The passphrase for an ECDSA private key from the
    specified user dir.
  * `:private_key_path` - The path to the private key to use for authentication.
  * `:private_key_pass_phrase` - The passphrase that is used to decrypt the
    specified private key.
  * `:inet` - The IP version to use, either `:inet` (default) or `:inet6`.
  * `:sftp_vsn` - The SFTP version to be used.
  * `:connect_timeout` - The connection timeout in milliseconds (defaults to
    5000 ms), can be set to `:infinity` to disable timeout.
  * `:operation_timeout` - The operation timeout in milliseconds (defaults to
    5000 ms), can be set to `:infinity` to disable timeout.
  """
  @spec connect(Config.t() | Keyword.t() | %{optional(atom) => any}) ::
          {:ok, Conn.t()} | {:error, term}
  def connect(config_or_opts) do
    config = Config.new(config_or_opts)

    with :ok <- validate_config(config),
         {:ok, channel_pid, conn_ref} <- do_connect(config) do
      {:ok,
       %Conn{
         config: config,
         channel_pid: channel_pid,
         conn_ref: conn_ref
       }}
    end
  end

  @doc """
  Connects to an SSH server and opens an SFTP channel, then runs the function
  and closes the connection when finished. Accepts the same options as
  `connect/1`.
  """
  @spec connect(
          Config.t() | Keyword.t() | %{optional(atom) => any},
          (Conn.t() -> res)
        ) :: {:ok, res} | {:error, SFTPClient.error()}
        when res: var
  def connect(config_or_opts, fun) do
    with {:ok, conn} <- connect(config_or_opts) do
      {:ok, run_callback(conn, fun)}
    end
  end

  @doc """
  Connects to an SSH server and opens an SFTP channel. Accepts the same options
  as `connect/1`. Raises when the connection fails.
  """
  @spec connect!(Config.t() | Keyword.t() | %{optional(atom) => any}) ::
          Conn.t() | no_return
  def connect!(config_or_opts) do
    config_or_opts |> connect() |> may_bang!()
  end

  @doc """
  Connects to an SSH server and opens an SFTP channel, then runs the function
  and closes the connection when finished. Accepts the same options as
  `connect/1`. Raises when the connection fails.
  """
  @spec connect!(
          Config.t() | Keyword.t() | %{optional(atom) => any},
          (Conn.t() -> res)
        ) :: res | no_return
        when res: var
  def connect!(config_or_opts, fun) do
    config_or_opts
    |> connect!()
    |> run_callback(fun)
  end

  defp run_callback(conn, fun) do
    fun.(conn)
  after
    Disconnect.disconnect(conn)
  end

  defp validate_config(config) do
    config
    |> Map.from_struct()
    |> Enum.find_value(:ok, fn {key, value} ->
      case validate_config_value(key, value) do
        :ok ->
          nil

        {:error, reason} ->
          {:error, %InvalidOptionError{key: key, value: value, reason: reason}}
      end
    end)
  end

  defp validate_config_value(_key, nil), do: :ok

  defp validate_config_value(:private_key_path, path) do
    if File.exists?(Path.expand(path)) do
      :ok
    else
      {:error, :enoent}
    end
  end

  defp validate_config_value(_key, _value), do: :ok

  defp do_connect(config) do
    with {:error, error} <-
           sftp_adapter().start_channel(
             to_charlist(config.host),
             config.port,
             get_opts(config)
           ) do
      {:error, handle_error(error)}
    end
  end

  defp get_opts(config) do
    Enum.sort([
      {:quiet_mode, true},
      {:silently_accept_hosts, true},
      {:user_interaction, false}
      | handle_opts(config)
    ])
  end

  defp handle_opts(config) do
    config
    |> Map.take([
      :user,
      :password,
      :user_dir,
      :system_dir,
      :inet,
      :sftp_vsn,
      :connect_timeout,
      :dsa_pass_phrase,
      :rsa_pass_phrase,
      :ecdsa_pass_phrase,
      :key_cb
    ])
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
    to_charlist(value)
  end

  defp dump_opt_value(value), do: value
end
