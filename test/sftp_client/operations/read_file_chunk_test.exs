defmodule SFTPClient.Operations.ReadFileChunkTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.ReadFileChunk

  setup :verify_on_exit!

  @handle %Handle{
    conn: %Conn{channel_pid: :channel_pid_stub},
    id: :handle_id_stub
  }

  @chunk_size 1337

  describe "read_file_chunk/1" do
    test "read chunk" do
      chunk_content = "chunk stub"

      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        {:ok, chunk_content}
      end)

      assert ReadFileChunk.read_file_chunk(@handle, @chunk_size) ==
               {:ok, chunk_content}
    end

    test "eof" do
      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        :eof
      end)

      assert ReadFileChunk.read_file_chunk(@handle, @chunk_size) == :eof
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        {:error, reason}
      end)

      assert ReadFileChunk.read_file_chunk(@handle, @chunk_size) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "read_file_chunk!/1" do
    test "read chunk" do
      chunk_content = "chunk stub"

      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        {:ok, chunk_content}
      end)

      assert ReadFileChunk.read_file_chunk!(@handle, @chunk_size) ==
               chunk_content
    end

    test "eof" do
      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        :eof
      end)

      assert ReadFileChunk.read_file_chunk!(@handle, @chunk_size) == :eof
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :read, fn :channel_pid_stub,
                                 :handle_id_stub,
                                 @chunk_size ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        ReadFileChunk.read_file_chunk!(@handle, @chunk_size)
      end
    end
  end
end
