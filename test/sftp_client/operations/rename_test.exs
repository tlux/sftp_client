defmodule SFTPClient.Operations.RenameTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.Rename

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}

  describe "rename/2" do
    test "success" do
      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/symlink/path',
                                   'my/target/path' ->
        :ok
      end)

      assert Rename.rename(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/symlink/path',
                                   'my/target/path' ->
        {:error, reason}
      end)

      assert Rename.rename(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "rename!/2" do
    test "success" do
      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/symlink/path',
                                   'my/target/path' ->
        :ok
      end)

      assert Rename.rename!(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/symlink/path',
                                   'my/target/path' ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        Rename.rename!(@conn, "my/symlink/path", "my/target/path")
      end
    end
  end
end
