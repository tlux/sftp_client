defmodule SFTPClient.Operations.DownloadFileTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.ConnError
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.DownloadFile

  @conn %Conn{channel_pid: :channel_pid_stub}

  setup :verify_on_exit!

  setup do
    local_path = Temp.path!()
    on_exit(fn -> File.rm(local_path) end)
    {:ok, local_path: local_path}
  end

  describe "download_file/3" do
    test "success", %{local_path: local_path} do
      file_content = "chunk"

      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:read, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _ ->
        {:ok, file_content}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _ -> :eof end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               :ok

      assert {:ok, ^file_content} = File.read(local_path)
    end

    test "conn error", %{local_path: local_path} do
      message = 'Something went wrong'

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        {:error, message}
      end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               {:error, %ConnError{message: to_string(message)}}
    end

    test "operation error", %{local_path: local_path} do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        {:error, reason}
      end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               {:error, %OperationError{reason: reason}}
    end

    test "exception", %{local_path: local_path} do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        raise RuntimeError, message
      end)

      assert_raise RuntimeError, message, fn ->
        DownloadFile.download_file(@conn, "my/remote/path", local_path)
      end
    end
  end

  describe "download_file!/3" do
    test "success", %{local_path: local_path} do
      file_content = "chunk"

      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:read, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _ ->
        {:ok, file_content}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _ -> :eof end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

      assert DownloadFile.download_file!(@conn, "my/remote/path", local_path) ==
               :ok

      assert {:ok, ^file_content} = File.read(local_path)
    end

    test "conn error", %{local_path: local_path} do
      message = 'Something went wrong'

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        {:error, message}
      end)

      assert_raise ConnError, to_string(message), fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end

    test "operation error", %{local_path: local_path} do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end

    test "exception", %{local_path: local_path} do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 'my/remote/path',
                                 [:read, :binary] ->
        raise RuntimeError, message
      end)

      assert_raise RuntimeError, message, fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end
  end
end
