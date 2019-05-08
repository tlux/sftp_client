defmodule SFTPClient.Operations.StreamFileTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.Rename

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}

  describe "stream_file/2" do
    test "success"

    test "error"
  end

  describe "stream_file/3" do
    test "success"

    test "error"
  end

  describe "stream_file!/2" do
    test "success"

    test "error"
  end

  describe "stream_file!/3" do
    test "success"

    test "error"
  end
end
