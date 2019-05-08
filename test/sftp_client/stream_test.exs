defmodule SFTPClient.StreamTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Stream, as: SFTPStream

  setup :verify_on_exit!

  @stream %SFTPStream{
    conn: %Conn{channel_pid: :channel_pid_stub},
    path: "my/remote/path",
    chunk_size: 1337
  }

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
                          [:read, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
        {:error, :enoent}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

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
                          [:read, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
        {:ok, "chunk 1"}
      end)
      |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
        {:ok, "chunk 2"}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

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
                          [:write, :creat, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1" ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2" ->
        :ok
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

      assert Enum.into(["chunk 1", "chunk 2"], @stream) == @stream
    end

    test "halt on error" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:write, :creat, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1" ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2" ->
        {:error, :generic_error}
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

      assert_raise OperationError, "Operation failed: generic_error", fn ->
        Enum.into(["chunk 1", "chunk 2"], @stream)
      end
    end

    test "halt on exception" do
      SFTPMock
      |> expect(:open, fn :channel_pid_stub,
                          'my/remote/path',
                          [:write, :creat, :binary] ->
        {:ok, :handle_id_stub}
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 1" ->
        :ok
      end)
      |> expect(:write, fn :channel_pid_stub, :handle_id_stub, "chunk 2" ->
        raise "Unexpected error"
      end)
      |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)

      assert_raise RuntimeError, "Unexpected error", fn ->
        assert Enum.into(["chunk 1", "chunk 2"], @stream)
      end
    end
  end

  defp setup_success_mocks do
    SFTPMock
    |> expect(:open, fn :channel_pid_stub, 'my/remote/path', [:read, :binary] ->
      {:ok, :handle_id_stub}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
      {:ok, "chunk 1"}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
      {:ok, "chunk 2"}
    end)
    |> expect(:read, fn :channel_pid_stub, :handle_id_stub, 1337 ->
      :eof
    end)
    |> expect(:close, fn :channel_pid_stub, :handle_id_stub -> :ok end)
  end
end
