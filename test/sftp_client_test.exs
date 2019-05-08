defmodule SFTPClientTest do
  use ExUnit.Case

  alias SFTPClient.Adapters.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Adapters.SSH.Mock, as: SSHMock
  alias SFTPClient.Operations

  describe "close_handle!/1" do
    test "delegate to Operations.CloseHandle"
  end

  describe "close_handle/1" do
    test "delegate to Operations.CloseHandle"
  end

  describe "connect!/1" do
    test "delegate to Operations.Connect"
  end

  describe "connect/1" do
    test "delegate to Operations.Connect"
  end

  describe "delete_dir!/2" do
    test "delegate to Operations.DeleteDir"
  end

  describe "delete_dir/2" do
    test "delegate to Operations.DeleteDir"
  end

  describe "delete_file!/2" do
    test "delegate to Operations.DeleteFile"
  end

  describe "delete_file/2" do
    test "delegate to Operations.DeleteFile"
  end

  describe "disconnect/1" do
    test "delegate to Operations.Disconnect"
  end

  describe "download_file!/3" do
    test "delegate to Operations.DownloadFile"
  end

  describe "download_file/3" do
    test "delegate to Operations.DownloadFile"
  end

  describe "file_info!/2" do
    test "delegate to Operations.FileInfo"
  end

  describe "file_info/2" do
    test "delegate to Operations.FileInfo"
  end

  describe "link_info!/2" do
    test "delegate to Operations.LinkInfo"
  end

  describe "link_info/2" do
    test "delegate to Operations.LinkInfo"
  end

  describe "list_dir!/2" do
    test "delegate to Operations.ListDir"
  end

  describe "list_dir/2" do
    test "delegate to Operations.ListDir"
  end

  describe "make_dir!/2" do
    test "delegate to Operations.MakeDir"
  end

  describe "make_dir/2" do
    test "delegate to Operations.MakeDir"
  end

  describe "make_symlink!/3" do
    test "delegate to Operations.MakeSymlink"
  end

  describe "make_symlink/3" do
    test "delegate to Operations.MakeSymlink"
  end
end
