defmodule SFTPClient.Operations.WriteFileChunkTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.WriteFileChunk

  setup :verify_on_exit!

  @handle %Handle{
    conn: %Conn{channel_pid: :channel_pid_stub},
    id: :handle_id_stub
  }

  @data "chunk stub"

  describe "write_file_chunk/1" do
    test "success" do
      chunk_content = "chunk stub"

      expect(SFTPMock, :write, fn :channel_pid_stub, :handle_id_stub, @data ->
        {:ok, chunk_content}
      end)

      assert WriteFileChunk.write_file_chunk(@handle, @data) ==
               {:ok, chunk_content}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :write, fn :channel_pid_stub, :handle_id_stub, @data ->
        {:error, reason}
      end)

      assert WriteFileChunk.write_file_chunk(@handle, @data) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "write_file_chunk!/1" do
    test "success" do
      chunk_content = "chunk stub"

      expect(SFTPMock, :write, fn :channel_pid_stub, :handle_id_stub, @data ->
        {:ok, chunk_content}
      end)

      assert WriteFileChunk.write_file_chunk!(@handle, @data) ==
               chunk_content
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :write, fn :channel_pid_stub, :handle_id_stub, @data ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        WriteFileChunk.write_file_chunk!(@handle, @data)
      end
    end
  end
end
