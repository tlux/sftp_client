defmodule SFTPClient.Operations.ReadFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.ReadFile

  setup :verify_on_exit!

  @conn build_conn()

  describe "read_file/2" do
    test "success" do
      file_content = "file content stub"

      expect(SFTPMock, :read_file, fn :channel_pid_stub,
                                      'my/remote/path',
                                      :infinity ->
        {:ok, file_content}
      end)

      assert ReadFile.read_file(@conn, "my/remote/path") == {:ok, file_content}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_file, fn :channel_pid_stub,
                                      'my/remote/path',
                                      :infinity ->
        {:error, reason}
      end)

      assert ReadFile.read_file(@conn, "my/remote/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "read_file!/2" do
    test "success" do
      file_content = "file content stub"

      expect(SFTPMock, :read_file, fn :channel_pid_stub,
                                      'my/remote/path',
                                      :infinity ->
        {:ok, file_content}
      end)

      assert ReadFile.read_file!(@conn, "my/remote/path") == file_content
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_file, fn :channel_pid_stub,
                                      'my/remote/path',
                                      :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        ReadFile.read_file!(@conn, "my/remote/path")
      end
    end
  end
end
