defmodule SFTPClient.Operations.OpenFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.OpenFile

  @conn build_conn()
  @path "my/remote/file.png"
  @modes [:read, :binary]

  setup :verify_on_exit!

  describe "open_file/3" do
    test "success" do
      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:ok, :handle_id_stub}
      end)

      assert OpenFile.open_file(@conn, @path, @modes) ==
               {:ok, %Handle{id: :handle_id_stub, conn: @conn, path: @path}}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:error, reason}
      end)

      assert OpenFile.open_file(@conn, @path, @modes) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "open_file/4" do
    test "success" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          ~c"my/remote/file.png",
                          @modes,
                          :infinity ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, :infinity ->
        :ok
      end)

      handle = %Handle{id: :handle_id_stub, conn: @conn, path: @path}

      assert OpenFile.open_file(@conn, @path, @modes, fn ^handle ->
               :result_stub
             end) == {:ok, :result_stub}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:error, reason}
      end)

      assert OpenFile.open_file(@conn, @path, @modes, fn _handle ->
               :result_stub
             end) == {:error, %OperationError{reason: reason}}
    end
  end

  describe "open_file!/3" do
    test "success" do
      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:ok, :handle_id_stub}
      end)

      assert OpenFile.open_file!(@conn, @path, @modes) ==
               %Handle{id: :handle_id_stub, conn: @conn, path: @path}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        OpenFile.open_file!(@conn, @path, @modes)
      end
    end
  end

  describe "open_file!/4" do
    test "success" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          ~c"my/remote/file.png",
                          @modes,
                          :infinity ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, :infinity ->
        :ok
      end)

      handle = %Handle{id: :handle_id_stub, conn: @conn, path: @path}

      assert OpenFile.open_file!(@conn, @path, @modes, fn ^handle ->
               :result_stub
             end) == :result_stub
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.png",
                                 @modes,
                                 :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        OpenFile.open_file!(@conn, @path, @modes, fn _handle ->
          :result_stub
        end)
      end
    end
  end
end
