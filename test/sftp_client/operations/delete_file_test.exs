defmodule SFTPClient.Operations.DeleteFileTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.DeleteFile

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}

  describe "delete_file/2" do
    test "success" do
      expect(SFTPMock, :delete, fn :channel_pid_stub, 'my/test/path' ->
        :ok
      end)

      assert DeleteFile.delete_file(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :delete, fn :channel_pid_stub, 'my/test/path' ->
        {:error, reason}
      end)

      assert DeleteFile.delete_file(@conn, "my/test/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "delete_file!/2" do
    test "success" do
      expect(SFTPMock, :delete, fn :channel_pid_stub, 'my/test/path' ->
        :ok
      end)

      assert DeleteFile.delete_file!(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :delete, fn :channel_pid_stub, 'my/test/path' ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        DeleteFile.delete_file!(@conn, "my/test/path")
      end
    end
  end
end
