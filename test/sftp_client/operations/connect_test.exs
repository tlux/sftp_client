defmodule SFTPClient.Operations.ConnectTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Config
  alias SFTPClient.Conn
  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.KeyProvider
  alias SFTPClient.Operations.Connect

  @config %Config{
    host: "test-host",
    port: 23,
    user: "test-user",
    password: "test-password",
    user_dir: "~/.ssh",
    system_dir: "/etc/ssh",
    private_key_path: "~/key",
    private_key_passphrase: "t3$t",
    inet: :inet,
    sftp_vsn: 2,
    connect_timeout: 1000
  }

  setup :verify_on_exit!

  setup do
    {:ok,
     opts: [
       connect_timeout: 1000,
       inet: :inet,
       key_cb: {KeyProvider, config: @config},
       password: 'test-password',
       quiet_mode: true,
       sftp_vsn: 2,
       silently_accept_hosts: true,
       system_dir: @config.system_dir |> Path.expand() |> String.to_charlist(),
       user: 'test-user',
       user_dir: @config.user_dir |> Path.expand() |> String.to_charlist(),
       user_interaction: false
     ]}
  end

  describe "connect/1" do
    test "connect with SFTPClient.Config", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      assert Connect.connect(@config) ==
               {:ok,
                %Conn{
                  config: @config,
                  channel_pid: :channel_pid_mock,
                  conn_ref: :conn_ref_mock
                }}
    end

    test "connect with map options", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      config_opts = Map.from_struct(@config)

      assert Connect.connect(config_opts) ==
               {:ok,
                %Conn{
                  config: @config,
                  channel_pid: :channel_pid_mock,
                  conn_ref: :conn_ref_mock
                }}
    end

    test "connect with keyword options", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      config_opts = @config |> Map.from_struct() |> Keyword.new()

      assert Connect.connect(config_opts) ==
               {:ok,
                %Conn{
                  config: @config,
                  channel_pid: :channel_pid_mock,
                  conn_ref: :conn_ref_mock
                }}
    end

    test "connection error", %{opts: opts} do
      message = 'Unable to connect using the available authentication methods'

      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:error, message}
      end)

      assert Connect.connect(@config) ==
               {:error, %ConnError{message: to_string(message)}}
    end

    test "invalid option error", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:error, {:eoptions, {{:user_dir, 'my/key/path'}, :enoent}}}
      end)

      assert Connect.connect(@config) ==
               {:error,
                %InvalidOptionError{
                  key: :user_dir,
                  value: "my/key/path",
                  reason: :enoent
                }}
    end
  end

  describe "connect!/1" do
    test "connect with SFTPClient.Config", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      assert Connect.connect!(@config) ==
               %Conn{
                 config: @config,
                 channel_pid: :channel_pid_mock,
                 conn_ref: :conn_ref_mock
               }
    end

    test "connect with map options", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      config_opts = Map.from_struct(@config)

      assert Connect.connect!(config_opts) ==
               %Conn{
                 config: @config,
                 channel_pid: :channel_pid_mock,
                 conn_ref: :conn_ref_mock
               }
    end

    test "connect with keyword options", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:ok, :channel_pid_mock, :conn_ref_mock}
      end)

      config_opts = @config |> Map.from_struct() |> Keyword.new()

      assert Connect.connect!(config_opts) ==
               %Conn{
                 config: @config,
                 channel_pid: :channel_pid_mock,
                 conn_ref: :conn_ref_mock
               }
    end

    test "connection error", %{opts: opts} do
      message = 'Unable to connect using the available authentication methods'

      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:error, message}
      end)

      assert_raise ConnError, to_string(message), fn ->
        Connect.connect!(@config)
      end
    end

    test "invalid option error", %{opts: opts} do
      expect(SFTPMock, :start_channel, fn 'test-host', 23, ^opts ->
        {:error, {:eoptions, {{:user_dir, 'my/key/path'}, :enoent}}}
      end)

      assert_raise InvalidOptionError,
                   ~s[Invalid value for option user_dir: "my/key/path" (:enoent)],
                   fn -> Connect.connect!(@config) end
    end
  end
end
