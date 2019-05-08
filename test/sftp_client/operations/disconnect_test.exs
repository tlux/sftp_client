defmodule SFTPClient.Operations.DisconnectTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Adapters.SSH.Mock, as: SSHMock
  alias SFTPClient.Conn
  alias SFTPClient.Operations.Disconnect

  setup :verify_on_exit!

  describe "disconnect/1" do
    test "close SFTP channel and close SSH connection" do
      conn = %Conn{channel_pid: :channel_pid_stub, conn_ref: :conn_ref_stub}

      expect(SFTPMock, :stop_channel, fn :channel_pid_stub ->
        send(self(), {:stop_sftp_channel, get_timestamp()})
        :ok
      end)

      expect(SSHMock, :close, fn :conn_ref_stub ->
        send(self(), {:close_ssh, get_timestamp()})
        :ok
      end)

      assert Disconnect.disconnect(conn) == :ok

      # Ensure close is called after stop_channel
      assert_received {:stop_sftp_channel, stop_sftp_channel_ts}
      assert_received {:close_ssh, close_ssh_ts}
      assert close_ssh_ts > stop_sftp_channel_ts
    end
  end

  defp get_timestamp do
    DateTime.to_unix(DateTime.utc_now(), :microsecond)
  end
end
