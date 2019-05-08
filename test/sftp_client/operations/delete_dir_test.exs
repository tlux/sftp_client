defmodule SFTPClient.Operations.DeleteDirTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.DeleteDir

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}

  describe "delete_dir/2" do
    test "success" do
      expect(SFTPMock, :del_dir, fn :channel_pid_stub, 'my/test/path' ->
        :ok
      end)

      assert DeleteDir.delete_dir(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :del_dir, fn :channel_pid_stub, 'my/test/path' ->
        {:error, reason}
      end)

      assert DeleteDir.delete_dir(@conn, "my/test/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "delete_dir!/2" do
    test "success" do
      expect(SFTPMock, :del_dir, fn :channel_pid_stub, 'my/test/path' ->
        :ok
      end)

      assert DeleteDir.delete_dir!(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :del_dir, fn :channel_pid_stub, 'my/test/path' ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        DeleteDir.delete_dir!(@conn, "my/test/path")
      end
    end
  end
end
