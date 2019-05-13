defmodule SFTPClient.Operations.MakeLinkTest do
  use ExUnit.Case, async: true

  import Mox
  import SFTPClient.ConnHelper

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.MakeLink

  setup :verify_on_exit!

  @conn build_conn()

  describe "make_link/2" do
    test "success" do
      expect(SFTPMock, :make_link, fn :channel_pid_stub,
                                      'my/symlink/path',
                                      'my/target/path',
                                      :infinity ->
        :ok
      end)

      assert MakeLink.make_link(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :make_link, fn :channel_pid_stub,
                                      'my/symlink/path',
                                      'my/target/path',
                                      :infinity ->
        {:error, reason}
      end)

      assert MakeLink.make_link(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "make_link!/2" do
    test "success" do
      expect(SFTPMock, :make_link, fn :channel_pid_stub,
                                      'my/symlink/path',
                                      'my/target/path',
                                      :infinity ->
        :ok
      end)

      assert MakeLink.make_link!(
               @conn,
               "my/symlink/path",
               "my/target/path"
             ) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :make_link, fn :channel_pid_stub,
                                      'my/symlink/path',
                                      'my/target/path',
                                      :infinity ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        MakeLink.make_link!(@conn, "my/symlink/path", "my/target/path")
      end
    end
  end
end
