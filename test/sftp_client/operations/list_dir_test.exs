defmodule SFTPClient.Operations.ListDirTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.ListDir

  setup :verify_on_exit!

  @conn build_conn()

  describe "list_dir/2" do
    test "success" do
      expect(SFTPMock, :list_dir, fn :channel_pid_stub,
                                     'my/remote/path',
                                     :infinity ->
        {:ok,
         [
           '..',
           '.',
           'my/remote/path/file3.txt',
           'my/remote/path/file1.txt',
           'my/remote/path/file2.txt'
         ]}
      end)

      assert ListDir.list_dir(@conn, "my/remote/path") ==
               {:ok,
                [
                  "my/remote/path/file1.txt",
                  "my/remote/path/file2.txt",
                  "my/remote/path/file3.txt"
                ]}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :list_dir, fn :channel_pid_stub,
                                     'my/remote/path',
                                     :infinity ->
        {:error, reason}
      end)

      assert ListDir.list_dir(@conn, "my/remote/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "list_dir!/2" do
    test "success" do
      expect(SFTPMock, :list_dir, fn :channel_pid_stub,
                                     'my/remote/path',
                                     :infinity ->
        {:ok,
         [
           '..',
           '.',
           'my/remote/path/file3.txt',
           'my/remote/path/file1.txt',
           'my/remote/path/file2.txt'
         ]}
      end)

      assert ListDir.list_dir!(@conn, "my/remote/path") ==
               [
                 "my/remote/path/file1.txt",
                 "my/remote/path/file2.txt",
                 "my/remote/path/file3.txt"
               ]
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :list_dir, fn :channel_pid_stub,
                                     'my/remote/path',
                                     :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        ListDir.list_dir!(@conn, "my/remote/path")
      end
    end
  end
end
