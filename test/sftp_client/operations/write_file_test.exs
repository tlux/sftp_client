defmodule SFTPClient.Operations.WriteFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.WriteFile

  setup :verify_on_exit!

  @conn build_conn()
  @file_content ["file content"]

  describe "write_file/2" do
    test "success with IO list" do
      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       ~c"my/remote/path",
                                       @file_content,
                                       :infinity ->
        :ok
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", @file_content) == :ok
    end

    test "success with binary" do
      [file_content] = @file_content

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       ~c"my/remote/path",
                                       @file_content,
                                       :infinity ->
        :ok
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", file_content) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       ~c"my/remote/path",
                                       @file_content,
                                       :infinity ->
        {:error, reason}
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", @file_content) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "write_file!/2" do
    test "success" do
      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       ~c"my/remote/path",
                                       @file_content,
                                       :infinity ->
        :ok
      end)

      assert WriteFile.write_file!(@conn, "my/remote/path", @file_content) ==
               :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       ~c"my/remote/path",
                                       @file_content,
                                       :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        WriteFile.write_file!(@conn, "my/remote/path", @file_content)
      end
    end
  end
end
