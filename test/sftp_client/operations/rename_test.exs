defmodule SFTPClient.Operations.RenameTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.Rename

  setup :verify_on_exit!

  @conn build_conn()

  describe "rename/2" do
    test "success" do
      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/old/path',
                                   'my/new/path',
                                   :infinity ->
        :ok
      end)

      assert Rename.rename(
               @conn,
               "my/old/path",
               "my/new/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/old/path',
                                   'my/new/path',
                                   :infinity ->
        {:error, reason}
      end)

      assert Rename.rename(
               @conn,
               "my/old/path",
               "my/new/path"
             ) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "rename!/2" do
    test "success" do
      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/old/path',
                                   'my/new/path',
                                   :infinity ->
        :ok
      end)

      assert Rename.rename!(
               @conn,
               "my/old/path",
               "my/new/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :rename, fn :channel_pid_stub,
                                   'my/old/path',
                                   'my/new/path',
                                   :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        Rename.rename!(@conn, "my/old/path", "my/new/path")
      end
    end
  end
end
