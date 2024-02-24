defmodule SFTPClient.Operations.DownloadFileTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.ConnError
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.DownloadFile

  @conn build_conn()

  setup :verify_on_exit!

  setup do
    local_dir = Temp.mkdir!()
    local_path = Path.join(local_dir, "download.dat")
    on_exit(fn -> File.rm_rf(local_dir) end)
    {:ok, local_dir: local_dir, local_path: local_path}
  end

  describe "download_file/3" do
    test "success", %{local_path: local_path} do
      file_content = "chunk"

      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          ~c"my/remote/path",
                          [:read, :binary],
                          :infinity ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        {:ok, file_content}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        :eof
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, :infinity ->
        :ok
      end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               {:ok, local_path}

      assert {:ok, ^file_content} = File.read(local_path)
    end

    test "success when local path is directory", %{local_dir: local_dir} do
      file_content = "chunk"
      local_path = Path.join(local_dir, "path-to-file.json")

      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          ~c"my/remote/path-to-file.json",
                          [:read, :binary],
                          :infinity ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        {:ok, file_content}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        :eof
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, :infinity ->
        :ok
      end)

      assert DownloadFile.download_file(
               @conn,
               "my/remote/path-to-file.json",
               local_dir
             ) == {:ok, local_path}

      assert {:ok, ^file_content} = File.read(local_path)
    end

    test "conn error", %{local_path: local_path} do
      message = ~c"Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
        {:error, message}
      end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               {:error, %ConnError{message: to_string(message)}}
    end

    test "operation error", %{local_path: local_path} do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
        {:error, reason}
      end)

      assert DownloadFile.download_file(@conn, "my/remote/path", local_path) ==
               {:error, %OperationError{reason: reason}}
    end

    test "exception", %{local_path: local_path} do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
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
                          ~c"my/remote/path",
                          [:read, :binary],
                          :infinity ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        {:ok, file_content}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, _, :infinity ->
        :eof
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, :infinity ->
        :ok
      end)

      assert DownloadFile.download_file!(@conn, "my/remote/path", local_path) ==
               local_path

      assert {:ok, ^file_content} = File.read(local_path)
    end

    test "conn error", %{local_path: local_path} do
      message = ~c"Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
        {:error, message}
      end)

      assert_raise ConnError, to_string(message), fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end

    test "operation error", %{local_path: local_path} do
      reason = :something_went_wrong

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end

    test "exception", %{local_path: local_path} do
      message = "Something went wrong"

      expect(SFTPMock, :open, fn :channel_pid_stub,
                                 ~c"my/remote/path",
                                 [:read, :binary],
                                 :infinity ->
        raise RuntimeError, message
      end)

      assert_raise RuntimeError, message, fn ->
        DownloadFile.download_file!(@conn, "my/remote/path", local_path)
      end
    end
  end
end
