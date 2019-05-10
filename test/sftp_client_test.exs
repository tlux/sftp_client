defmodule SFTPClientTest do
  use ExUnit.Case, async: false

  import Mox
  alias SFTPClient.Driver.Mock, as: MockDriver
  alias SFTPClient.Operations

  setup :verify_on_exit!

  setup do
    Application.put_env(:sftp_client, :driver, MockDriver)

    on_exit(fn ->
      Application.delete_env(:sftp_client, :driver)
    end)

    :ok
  end

  describe "close_handle!/1" do
    test "delegate to Operations.CloseHandle" do
      assert_delegate_to_operation(Operations.CloseHandle, :close_handle!, [
        :handle_stub
      ])
    end
  end

  describe "close_handle/1" do
    test "delegate to Operations.CloseHandle" do
      assert_delegate_to_operation(Operations.CloseHandle, :close_handle, [
        :handle_stub
      ])
    end
  end

  describe "connect!/1" do
    test "delegate to Operations.Connect" do
      assert_delegate_to_operation(Operations.Connect, :connect!, [
        :config_or_opts_stub
      ])
    end
  end

  describe "connect/1" do
    test "delegate to Operations.Connect" do
      assert_delegate_to_operation(Operations.Connect, :connect, [
        :config_or_opts_stub
      ])
    end
  end

  describe "delete_dir!/2" do
    test "delegate to Operations.DeleteDir" do
      assert_delegate_to_operation(Operations.DeleteDir, :delete_dir!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "delete_dir/2" do
    test "delegate to Operations.DeleteDir" do
      assert_delegate_to_operation(Operations.DeleteDir, :delete_dir, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "delete_file!/2" do
    test "delegate to Operations.DeleteFile" do
      assert_delegate_to_operation(Operations.DeleteFile, :delete_file!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "delete_file/2" do
    test "delegate to Operations.DeleteFile" do
      assert_delegate_to_operation(Operations.DeleteFile, :delete_file, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "disconnect/1" do
    test "delegate to Operations.Disconnect" do
      assert_delegate_to_operation(Operations.Disconnect, :disconnect, [
        :conn_stub
      ])
    end
  end

  describe "download_file!/3" do
    test "delegate to Operations.DownloadFile" do
      assert_delegate_to_operation(Operations.DownloadFile, :download_file!, [
        :conn_stub,
        :remote_path_stub,
        :local_path_stub
      ])
    end
  end

  describe "download_file/3" do
    test "delegate to Operations.DownloadFile" do
      assert_delegate_to_operation(Operations.DownloadFile, :download_file, [
        :conn_stub,
        :remote_path_stub,
        :local_path_stub
      ])
    end
  end

  describe "file_info!/2" do
    test "delegate to Operations.FileInfo" do
      assert_delegate_to_operation(Operations.FileInfo, :file_info!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "file_info/2" do
    test "delegate to Operations.FileInfo" do
      assert_delegate_to_operation(Operations.FileInfo, :file_info, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "link_info!/2" do
    test "delegate to Operations.LinkInfo" do
      assert_delegate_to_operation(Operations.LinkInfo, :link_info!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "link_info/2" do
    test "delegate to Operations.LinkInfo" do
      assert_delegate_to_operation(Operations.LinkInfo, :link_info, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "list_dir!/2" do
    test "delegate to Operations.ListDir" do
      assert_delegate_to_operation(Operations.ListDir, :list_dir!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "list_dir/2" do
    test "delegate to Operations.ListDir" do
      assert_delegate_to_operation(Operations.ListDir, :list_dir, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "make_dir!/2" do
    test "delegate to Operations.MakeDir" do
      assert_delegate_to_operation(Operations.MakeDir, :make_dir!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "make_dir/2" do
    test "delegate to Operations.MakeDir" do
      assert_delegate_to_operation(Operations.MakeDir, :make_dir, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "make_link!/3" do
    test "delegate to Operations.MakeLink" do
      assert_delegate_to_operation(Operations.MakeLink, :make_link!, [
        :conn_stub,
        :symlink_path_stub,
        :target_path_stub
      ])
    end
  end

  describe "make_link/3" do
    test "delegate to Operations.MakeLink" do
      assert_delegate_to_operation(Operations.MakeLink, :make_link, [
        :conn_stub,
        :symlink_path_stub,
        :target_path_stub
      ])
    end
  end

  describe "open_dir!/2" do
    test "delegate to Operations.OpenDir" do
      assert_delegate_to_operation(Operations.OpenDir, :open_dir!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "open_dir/2" do
    test "delegate to Operations.OpenDir" do
      assert_delegate_to_operation(Operations.OpenDir, :open_dir, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "open_file!/3" do
    test "delegate to Operations.OpenFile" do
      assert_delegate_to_operation(Operations.OpenFile, :open_file!, [
        :conn_stub,
        :path_stub,
        :modes_stub
      ])
    end
  end

  describe "open_file/3" do
    test "delegate to Operations.OpenFile" do
      assert_delegate_to_operation(Operations.OpenFile, :open_file, [
        :conn_stub,
        :path_stub,
        :modes_stub
      ])
    end
  end

  describe "read_file_chunk!/2" do
    test "delegate to Operations.ReadFileChunk" do
      assert_delegate_to_operation(
        Operations.ReadFileChunk,
        :read_file_chunk!,
        [
          :handle_stub,
          :length_stub
        ]
      )
    end
  end

  describe "read_file_chunk/2" do
    test "delegate to Operations.ReadFileChunk" do
      assert_delegate_to_operation(Operations.ReadFileChunk, :read_file_chunk, [
        :handle_stub,
        :length_stub
      ])
    end
  end

  describe "read_file!/2" do
    test "delegate to Operations.ReadFile" do
      assert_delegate_to_operation(Operations.ReadFile, :read_file!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "read_file/2" do
    test "delegate to Operations.ReadFile" do
      assert_delegate_to_operation(Operations.ReadFile, :read_file, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "read_link!/2" do
    test "delegate to Operations.ReadLink" do
      assert_delegate_to_operation(Operations.ReadLink, :read_link!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "read_link/2" do
    test "delegate to Operations.ReadLink" do
      assert_delegate_to_operation(Operations.ReadLink, :read_link, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "rename!/3" do
    test "delegate to Operations.Rename" do
      assert_delegate_to_operation(Operations.Rename, :rename!, [
        :conn_stub,
        :old_path_stub,
        :new_path_stub
      ])
    end
  end

  describe "rename/3" do
    test "delegate to Operations.Rename" do
      assert_delegate_to_operation(Operations.Rename, :rename, [
        :conn_stub,
        :old_path_stub,
        :new_path_stub
      ])
    end
  end

  describe "stream_file!/2" do
    test "delegate to Operations.StreamFile" do
      assert_delegate_to_operation(Operations.StreamFile, :stream_file!, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "stream_file/2" do
    test "delegate to Operations.StreamFile" do
      assert_delegate_to_operation(Operations.StreamFile, :stream_file, [
        :conn_stub,
        :path_stub
      ])
    end
  end

  describe "stream_file!/3" do
    test "delegate to Operations.StreamFile" do
      assert_delegate_to_operation(Operations.StreamFile, :stream_file!, [
        :conn_stub,
        :path_stub,
        :chunk_size_stub
      ])
    end
  end

  describe "stream_file/3" do
    test "delegate to Operations.StreamFile" do
      assert_delegate_to_operation(Operations.StreamFile, :stream_file, [
        :conn_stub,
        :path_stub,
        :chunk_size_stub
      ])
    end
  end

  describe "upload_file!/3" do
    test "delegate to Operations.UploadFile" do
      assert_delegate_to_operation(Operations.UploadFile, :upload_file!, [
        :conn_stub,
        :local_path_stub,
        :remote_path_stub
      ])
    end
  end

  describe "upload_file/3" do
    test "delegate to Operations.UploadFile" do
      assert_delegate_to_operation(Operations.UploadFile, :upload_file, [
        :conn_stub,
        :local_path_stub,
        :remote_path_stub
      ])
    end
  end

  describe "write_file_chunk!/2" do
    test "delegate to Operations.WriteFileChunk" do
      assert_delegate_to_operation(
        Operations.WriteFileChunk,
        :write_file_chunk!,
        [
          :handle_stub,
          :data_stub
        ]
      )
    end
  end

  describe "write_file_chunk/2" do
    test "delegate to Operations.WriteFileChunk" do
      assert_delegate_to_operation(
        Operations.WriteFileChunk,
        :write_file_chunk,
        [
          :handle_stub,
          :data_stub
        ]
      )
    end
  end

  describe "write_file!/2" do
    test "delegate to Operations.WriteFile" do
      assert_delegate_to_operation(Operations.WriteFile, :write_file!, [
        :conn_stub,
        :path_stub,
        :data_stub
      ])
    end
  end

  describe "write_file/2" do
    test "delegate to Operations.WriteFile" do
      assert_delegate_to_operation(Operations.WriteFile, :write_file, [
        :conn_stub,
        :path_stub,
        :data_stub
      ])
    end
  end

  defp assert_delegate_to_operation(module, fun, args) do
    expect(MockDriver, :run, fn ^module, ^fun, ^args ->
      :result_stub
    end)

    assert apply(SFTPClient, fun, args) == :result_stub
  end
end
