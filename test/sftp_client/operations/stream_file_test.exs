defmodule SFTPClient.Operations.StreamFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias File.Stat, as: FileStat
  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.StreamFile
  alias SFTPClient.Stream, as: SFTPStream

  setup :verify_on_exit!

  @conn build_conn()
  @path "my/remote/path"

  describe "stream_file/2" do
    test "build stream" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:ok, FileStat.to_record(%FileStat{type: :regular})}
      end)

      assert StreamFile.stream_file(@conn, @path) ==
               {:ok, %SFTPStream{conn: @conn, path: @path}}
    end

    test "error when file not found" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:error, :no_such_file}
      end)

      assert StreamFile.stream_file(@conn, @path) ==
               {:error, %OperationError{reason: :no_such_file}}
    end

    test "error for directory" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:ok, FileStat.to_record(%FileStat{type: :directory})}
      end)

      assert StreamFile.stream_file(@conn, @path) ==
               {:error, %OperationError{reason: :no_such_file}}
    end
  end

  describe "stream_file/3" do
    test "build stream" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:ok, FileStat.to_record(%FileStat{type: :regular})}
      end)

      assert StreamFile.stream_file(@conn, @path, 1337) ==
               {:ok, %SFTPStream{conn: @conn, path: @path, chunk_size: 1337}}
    end

    test "error when file not found" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:error, :no_such_file}
      end)

      assert StreamFile.stream_file(@conn, @path, 1337) ==
               {:error, %OperationError{reason: :no_such_file}}
    end

    test "error for directory" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           ~c"my/remote/path",
                                           :infinity ->
        {:ok, FileStat.to_record(%FileStat{type: :directory})}
      end)

      assert StreamFile.stream_file(@conn, @path, 1337) ==
               {:error, %OperationError{reason: :no_such_file}}
    end
  end

  describe "stream_file!/2" do
    test "build stream" do
      assert StreamFile.stream_file!(@conn, @path) ==
               %SFTPStream{conn: @conn, path: @path}
    end
  end

  describe "stream_file!/3" do
    test "build stream" do
      assert StreamFile.stream_file!(@conn, @path, 1337) ==
               %SFTPStream{conn: @conn, path: @path, chunk_size: 1337}
    end
  end
end
