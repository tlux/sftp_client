defmodule SFTPClient.Operations.WriteFileTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.WriteFile

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}
  @file_content ["file content"]

  describe "write_file/2" do
    test "success with IO list" do
      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       'my/remote/path',
                                       @file_content ->
        :ok
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", @file_content) == :ok
    end

    test "success with binary" do
      [file_content] = @file_content

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       'my/remote/path',
                                       @file_content ->
        :ok
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", file_content) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       'my/remote/path',
                                       @file_content ->
        {:error, reason}
      end)

      assert WriteFile.write_file(@conn, "my/remote/path", @file_content) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "write_file!/2" do
    test "success" do
      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       'my/remote/path',
                                       @file_content ->
        :ok
      end)

      assert WriteFile.write_file!(@conn, "my/remote/path", @file_content) ==
               :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :write_file, fn :channel_pid_stub,
                                       'my/remote/path',
                                       @file_content ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        WriteFile.write_file!(@conn, "my/remote/path", @file_content)
      end
    end
  end
end
