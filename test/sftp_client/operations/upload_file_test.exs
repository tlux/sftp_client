defmodule SFTPClient.Operations.UploadFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.ConnError
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.UploadFile

  @conn build_conn()
  @local_path "test/fixtures/lorem_ipsum.txt"
  @remote_path "my/remote/file.txt"

  setup :verify_on_exit!

  describe "upload_file/3" do
    test "success" do
      chunks = @local_path |> File.stream!([], 32_768) |> Enum.to_list()

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:ok, :handle_id_stub}
      end)

      Enum.each(chunks, fn chunk ->
        expect(SFTPMock, :write, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    ^chunk,
                                    :infinity ->
          :ok
        end)
      end)

      expect(SFTPMock, :close, fn :channel_pid_stub,
                                  :handle_id_stub,
                                  :infinity ->
        :ok
      end)

      assert UploadFile.upload_file(@conn, @local_path, @remote_path) ==
               {:ok, @remote_path}
    end

    test "conn error" do
      message = ~c"Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:error, message}
      end)

      assert UploadFile.upload_file(@conn, @local_path, @remote_path) ==
               {:error, %ConnError{message: to_string(message)}}
    end

    test "operation error" do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:error, reason}
      end)

      assert UploadFile.upload_file(@conn, @local_path, @remote_path) ==
               {:error, %OperationError{reason: reason}}
    end

    test "exception" do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        raise RuntimeError, message
      end)

      assert_raise RuntimeError, message, fn ->
        UploadFile.upload_file(@conn, @local_path, @remote_path)
      end
    end
  end

  describe "upload_file!/3" do
    test "success" do
      chunks = @local_path |> File.stream!([], 32_768) |> Enum.to_list()

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:ok, :handle_id_stub}
      end)

      Enum.each(chunks, fn chunk ->
        expect(SFTPMock, :write, fn :channel_pid_stub,
                                    :handle_id_stub,
                                    ^chunk,
                                    :infinity ->
          :ok
        end)
      end)

      expect(SFTPMock, :close, fn :channel_pid_stub,
                                  :handle_id_stub,
                                  :infinity ->
        :ok
      end)

      assert UploadFile.upload_file!(@conn, @local_path, @remote_path) ==
               @remote_path
    end

    test "conn error" do
      message = ~c"Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:error, message}
      end)

      assert_raise ConnError, to_string(message), fn ->
        UploadFile.upload_file!(@conn, @local_path, @remote_path)
      end
    end

    test "operation error" do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        UploadFile.upload_file!(@conn, @local_path, @remote_path)
      end
    end

    test "exception" do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/file.txt",
                                 [:write, :creat, :binary],
                                 :infinity ->
        raise RuntimeError, message
      end)

      assert_raise RuntimeError, message, fn ->
        UploadFile.upload_file!(@conn, @local_path, @remote_path)
      end
    end
  end
end
