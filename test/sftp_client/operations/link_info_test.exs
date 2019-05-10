defmodule SFTPClient.Operations.LinkInfoTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias File.Stat, as: FileStat
  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.LinkInfo

  setup :verify_on_exit!

  @conn build_conn()

  @record {:file_info, 930, :symlink, :read_write, {{2019, 5, 7}, {23, 32, 42}},
           {{2019, 5, 7}, {22, 46, 58}}, {{2019, 5, 7}, {22, 46, 58}}, 33188, 1,
           16_777_220, 0, 27_202_754, 442_462_711, 308_997_259}

  describe "link_info/2" do
    test "success" do
      expect(SFTPMock, :read_link_info, fn :channel_pid_stub,
                                           'my/remote/file',
                                           :infinity ->
        {:ok, @record}
      end)

      assert LinkInfo.link_info(@conn, "my/remote/file") ==
               {:ok, FileStat.from_record(@record)}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_link_info, fn :channel_pid_stub,
                                           'my/remote/file',
                                           :infinity ->
        {:error, reason}
      end)

      assert LinkInfo.link_info(@conn, "my/remote/file") ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "link_info!/2" do
    test "success" do
      expect(SFTPMock, :read_link_info, fn :channel_pid_stub,
                                           'my/remote/file',
                                           :infinity ->
        {:ok, @record}
      end)

      assert LinkInfo.link_info!(@conn, "my/remote/file") ==
               FileStat.from_record(@record)
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read_link_info, fn :channel_pid_stub,
                                           'my/remote/file',
                                           :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        LinkInfo.link_info!(@conn, "my/remote/file")
      end
    end
  end
end
