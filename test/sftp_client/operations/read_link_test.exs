defmodule SFTPClient.Operations.ReadLinkTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.ReadLink

  setup :verify_on_exit!

  @conn build_conn()

  describe "read_link/2" do
    test "success" do
      expect(SFTPMock, :read_link, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:ok, 'my/path/to/real/file'}
      end)

      assert ReadLink.read_link(@conn, "my/remote/path") ==
               {:ok, "my/path/to/real/file"}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_link, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:error, reason}
      end)

      assert ReadLink.read_link(@conn, "my/remote/path") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "read_link!/2" do
    test "success" do
      expect(SFTPMock, :read_link, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:ok, 'my/path/to/real/file'}
      end)

      assert ReadLink.read_link!(@conn, "my/remote/path") ==
               "my/path/to/real/file"
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_link, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        ReadLink.read_link!(@conn, "my/remote/path")
      end
    end
  end
end
