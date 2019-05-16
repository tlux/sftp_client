defmodule SFTPClientTest do
  use ExUnit.Case, async: true

  import Delx.TestAssertions

  alias SFTPClient.Operations

  describe "close_handle!/1" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :close_handle!, 1},
        to: Operations.CloseHandle
      )
    end
  end

  describe "close_handle/1" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :close_handle, 1},
        to: Operations.CloseHandle
      )
    end
  end

  describe "connect!/1" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :connect!, 1}, to: Operations.Connect)
    end
  end

  describe "connect!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :connect!, 2}, to: Operations.Connect)
    end
  end

  describe "connect/1" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :connect, 1}, to: Operations.Connect)
    end
  end

  describe "connect/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :connect, 2}, to: Operations.Connect)
    end
  end

  describe "delete_dir!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :delete_dir!, 2}, to: Operations.DeleteDir)
    end
  end

  describe "delete_dir/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :delete_dir, 2}, to: Operations.DeleteDir)
    end
  end

  describe "delete_file!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :delete_file!, 2},
        to: Operations.DeleteFile
      )
    end
  end

  describe "delete_file/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :delete_file, 2}, to: Operations.DeleteFile)
    end
  end

  describe "disconnect/1" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :disconnect, 1}, to: Operations.Disconnect)
    end
  end

  describe "download_file!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :download_file!, 3},
        to: Operations.DownloadFile
      )
    end
  end

  describe "download_file/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :download_file, 3},
        to: Operations.DownloadFile
      )
    end
  end

  describe "file_info!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :file_info!, 2}, to: Operations.FileInfo)
    end
  end

  describe "file_info/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :file_info, 2}, to: Operations.FileInfo)
    end
  end

  describe "link_info!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :link_info!, 2}, to: Operations.LinkInfo)
    end
  end

  describe "link_info/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :link_info, 2}, to: Operations.LinkInfo)
    end
  end

  describe "list_dir!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :list_dir!, 2}, to: Operations.ListDir)
    end
  end

  describe "list_dir/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :list_dir, 2}, to: Operations.ListDir)
    end
  end

  describe "make_dir!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :make_dir!, 2}, to: Operations.MakeDir)
    end
  end

  describe "make_dir/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :make_dir, 2}, to: Operations.MakeDir)
    end
  end

  describe "make_link!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :make_link!, 3}, to: Operations.MakeLink)
    end
  end

  describe "make_link/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :make_link, 3}, to: Operations.MakeLink)
    end
  end

  describe "open_dir!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_dir!, 2}, to: Operations.OpenDir)
    end
  end

  describe "open_dir!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_dir!, 3}, to: Operations.OpenDir)
    end
  end

  describe "open_dir/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_dir, 2}, to: Operations.OpenDir)
    end
  end

  describe "open_dir/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_dir, 3}, to: Operations.OpenDir)
    end
  end

  describe "open_file!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_file!, 3}, to: Operations.OpenFile)
    end
  end

  describe "open_file!/4" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_file!, 4}, to: Operations.OpenFile)
    end
  end

  describe "open_file/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_file, 3}, to: Operations.OpenFile)
    end
  end

  describe "open_file/4" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :open_file, 4}, to: Operations.OpenFile)
    end
  end

  describe "read_file_chunk!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_file_chunk!, 2},
        to: Operations.ReadFileChunk
      )
    end
  end

  describe "read_file_chunk/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_file_chunk, 2},
        to: Operations.ReadFileChunk
      )
    end
  end

  describe "read_file!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_file!, 2}, to: Operations.ReadFile)
    end
  end

  describe "read_file/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_file, 2}, to: Operations.ReadFile)
    end
  end

  describe "read_link!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_link!, 2}, to: Operations.ReadLink)
    end
  end

  describe "read_link/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :read_link!, 2}, to: Operations.ReadLink)
    end
  end

  describe "rename!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :rename!, 3}, to: Operations.Rename)
    end
  end

  describe "rename/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :rename, 3}, to: Operations.Rename)
    end
  end

  describe "stream_file!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :stream_file!, 2},
        to: Operations.StreamFile
      )
    end
  end

  describe "stream_file/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :stream_file, 2}, to: Operations.StreamFile)
    end
  end

  describe "stream_file!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :stream_file!, 3},
        to: Operations.StreamFile
      )
    end
  end

  describe "stream_file/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :stream_file, 3}, to: Operations.StreamFile)
    end
  end

  describe "upload_file!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :upload_file!, 3},
        to: Operations.UploadFile
      )
    end
  end

  describe "upload_file/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :upload_file, 3}, to: Operations.UploadFile)
    end
  end

  describe "write_file_chunk!/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :write_file_chunk!, 2},
        to: Operations.WriteFileChunk
      )
    end
  end

  describe "write_file_chunk/2" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :write_file_chunk, 2},
        to: Operations.WriteFileChunk
      )
    end
  end

  describe "write_file!/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :write_file!, 3}, to: Operations.WriteFile)
    end
  end

  describe "write_file/3" do
    test "delegate to driver" do
      assert_delegate({SFTPClient, :write_file, 3}, to: Operations.WriteFile)
    end
  end
end
