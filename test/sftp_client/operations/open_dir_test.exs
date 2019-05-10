defmodule SFTPClient.Operations.OpenDirTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.OpenDir

  setup :verify_on_exit!

  @conn build_conn()
  @path "my/remote/path"

  describe "open_dir/2" do
    test "success" do
      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:ok, :handle_id_stub}
      end)

      assert OpenDir.open_dir(@conn, @path) ==
               {:ok, %Handle{conn: @conn, id: :handle_id_stub, path: @path}}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:error, reason}
      end)

      assert OpenDir.open_dir(@conn, @path) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "open_dir/3" do
    test "success"

    test "error"
  end

  describe "open_dir!/2" do
    test "success" do
      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:ok, :handle_id_stub}
      end)

      assert OpenDir.open_dir!(@conn, @path) ==
               %Handle{conn: @conn, id: :handle_id_stub, path: @path}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path', :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        OpenDir.open_dir!(@conn, @path)
      end
    end
  end

  describe "open_dir!/3" do
    test "success"

    test "error"
  end
end
