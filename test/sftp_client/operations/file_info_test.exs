defmodule SFTPClient.Operations.FileInfoTest do
  use ExUnit.Case, async: true

  import Mox

  alias File.Stat, as: FileStat
  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.FileInfo

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}

  @record {:file_info, 930, :regular, :read_write, {{2019, 5, 7}, {23, 32, 42}},
           {{2019, 5, 7}, {22, 46, 58}}, {{2019, 5, 7}, {22, 46, 58}}, 33188, 1,
           16_777_220, 0, 27_202_754, 442_462_711, 308_997_259}

  describe "file_info/2" do
    test "success" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           'my/remote/file' ->
        {:ok, @record}
      end)

      assert FileInfo.file_info(@conn, "my/remote/file") ==
               {:ok, FileStat.from_record(@record)}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           'my/remote/file' ->
        {:error, reason}
      end)

      assert FileInfo.file_info(@conn, "my/remote/file") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "file_info!/2" do
    test "success" do
      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           'my/remote/file' ->
        {:ok, @record}
      end)

      assert FileInfo.file_info!(@conn, "my/remote/file") ==
               FileStat.from_record(@record)
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_file_info, fn :channel_pid_stub,
                                           'my/remote/file' ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        FileInfo.file_info!(@conn, "my/remote/file")
      end
    end
  end
end
