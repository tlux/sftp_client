defmodule SFTPClient.Operations.MakeDirTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.MakeDir

  setup :verify_on_exit!

  @conn build_conn()

  describe "make_dir/2" do
    test "success" do
      expect(SFTPMock, :make_dir, fn :channel_pid_stub,
                                     ~c"my/test/path",
                                     :infinity ->
        :ok
      end)

      assert MakeDir.make_dir(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :make_dir, fn :channel_pid_stub,
                                     ~c"my/test/path",
                                     :infinity ->
        {:error, reason}
      end)

      assert MakeDir.make_dir(@conn, "my/test/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "make_dir!/2" do
    test "success" do
      expect(SFTPMock, :make_dir, fn :channel_pid_stub,
                                     ~c"my/test/path",
                                     :infinity ->
        :ok
      end)

      assert MakeDir.make_dir!(@conn, "my/test/path") == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :make_dir, fn :channel_pid_stub,
                                     ~c"my/test/path",
                                     :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        MakeDir.make_dir!(@conn, "my/test/path")
      end
    end
  end
end
