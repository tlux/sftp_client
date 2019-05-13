defmodule SFTPClient.StreamTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Stream, as: SFTPStream

  setup :verify_on_exit!

  @stream %SFTPStream{
    conn: build_conn(),
    path: "my/remote/path",
    chunk_size: 1337
  }

  describe "struct" do
    test "default chunk size" do
      stream = %SFTPStream{conn: @stream.conn, path: @stream.path}

      assert stream.chunk_size == 32768
    end
  end

  describe "readable_stream/1" do
    test "get stream" do
      setup_success_mocks()

      assert Enum.to_list(SFTPStream.readable_stream(@stream)) == [
               "chunk 1",
               "chunk 2"
             ]
    end

    test "error" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:read, :binary],
                          _ ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
        {:error, :enoent}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
        :ok
      end)

      assert capture_log(fn ->
               assert_raise IO.StreamError,
                            "error during streaming: " <>
                              "the file server process is terminated",
                            fn ->
                              Enum.to_list(SFTPStream.readable_stream(@stream))
                            end
             end) =~ "Operation failed: enoent"
    end
  end

  describe "Enum.to_list/1" do
    test "convert stream to list" do
      setup_success_mocks()

      assert Enum.to_list(@stream) == ["chunk 1", "chunk 2"]
    end
  end

  describe "Enum.count/1" do
    test "convert stream to list" do
      setup_success_mocks()

      assert Enum.count(@stream) == 2
    end
  end

  describe "Enum.member?/2" do
    test "is true when item is member" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:read, :binary],
                          _ ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
        {:ok, "chunk 1"}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
        {:ok, "chunk 2"}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
        :ok
      end)

      assert Enum.member?(@stream, "chunk 2") == true
    end

    test "is false when item is not member" do
      setup_success_mocks()

      assert Enum.member?(@stream, "chunk 5") == false
    end
  end

  describe "Enum.into/2" do
    test "download into stream" do
      setup_success_mocks()

      assert Enum.into(@stream, MapSet.new()) ==
               MapSet.new(["chunk 1", "chunk 2"])
    end

    test "upload into stream" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:write, :creat, :binary],
                          _ ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1", _ ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2", _ ->
        :ok
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
        :ok
      end)

      assert Enum.into(["chunk 1", "chunk 2"], @stream) == @stream
    end

    test "halt on error" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:write, :creat, :binary],
                          _ ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1", _ ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2", _ ->
        {:error, :generic_error}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
        :ok
      end)

      assert_raise OperationError, "Operation failed: generic_error", fn ->
        Enum.into(["chunk 1", "chunk 2"], @stream)
      end
    end

    test "halt on exception" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:write, :creat, :binary],
                          _ ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1", _ ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2", _ ->
        raise "Unexpected error"
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
        :ok
      end)

      assert_raise RuntimeError, "Unexpected error", fn ->
        assert Enum.into(["chunk 1", "chunk 2"], @stream)
      end
    end
  end

  defp setup_success_mocks do
    SFTPMock
    |> expect(:open, fn :channel_pid_stub,
                        'my/remote/path',
                        [:read, :binary],
                        _ ->
      {:ok, :handle_id_stub}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
      {:ok, "chunk 1"}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
      {:ok, "chunk 2"}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337, _ ->
      :eof
    end)
    |> expect(:close, fn :channel_pid_stub, :handle_id_stub, _ ->
      :ok
    end)
  end
end
