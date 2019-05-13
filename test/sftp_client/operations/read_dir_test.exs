defmodule SFTPClient.Operations.ReadDirTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Entry
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.ReadDir
  alias SFTPClient.SSHXferAttr

  setup :verify_on_exit!

  @handle %Handle{
    conn: build_conn(),
    id: :handle_id_stub,
    path: "my/remote/dir"
  }

  @encoded_entries [
    {'ARTICLES_20181130142502.jsonl.gz',
     {:ssh_xfer_attr, :regular, 1_896_997, 12084, 12084, 33188, 1_557_265_538,
      :undefined, :undefined, :undefined, 1_543_587_908, :undefined, :undefined,
      :undefined, :undefined}},
    {'ARTICLES_20180724143001.jsonl.gz',
     {:ssh_xfer_attr, :regular, 99477, 12084, 12084, 33188, 1_557_265_538,
      :undefined, :undefined, :undefined, 1_532_442_606, :undefined, :undefined,
      :undefined, :undefined}},
    {'ARTICLES_20181109155001.jsonl.gz',
     {:ssh_xfer_attr, :regular, 1_437_723, 12084, 12084, 33188, 1_557_265_539,
      :undefined, :undefined, :undefined, 1_541_778_608, :undefined, :undefined,
      :undefined, :undefined}}
  ]

  setup do
    decoded_entries =
      Enum.map(@encoded_entries, fn {filename, xfer_attr} ->
        %Entry{
          filename: to_string(filename),
          path: "my/remote/dir/#{filename}",
          stat: SSHXferAttr.from_record(xfer_attr)
        }
      end)

    {:ok, decoded_entries: decoded_entries}
  end

  describe "read_dir/1" do
    test "success", %{decoded_entries: decoded_entries} do
      expect(SFTPMock, :readdir, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    :infinity ->
        {:ok, @encoded_entries}
      end)

      assert ReadDir.read_dir(@handle) == {:ok, decoded_entries}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :readdir, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    :infinity ->
        {:error, reason}
      end)

      assert ReadDir.read_dir(@handle) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "read_dir!/1" do
    test "success", %{decoded_entries: decoded_entries} do
      expect(SFTPMock, :readdir, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    :infinity ->
        {:ok, @encoded_entries}
      end)

      assert ReadDir.read_dir!(@handle) == decoded_entries
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :readdir, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        ReadDir.read_dir!(@handle)
      end
    end
  end
end
