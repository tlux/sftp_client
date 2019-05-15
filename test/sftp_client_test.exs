defmodule SFTPClientTest do
  use ExUnit.Case, async: false

  import Mox

  alias SFTPClient.Driver.Mock, as: MockDriver

  setup :verify_on_exit!

  setup do
    Application.put_env(:sftp_client, :driver, MockDriver)

    on_exit(fn ->
      Application.delete_env(:sftp_client, :driver)
    end)

    :ok
  end

  describe "close_handle!/1" do
    test "delegate to driver" do
      expect(MockDriver, :close_handle!, fn :handle_stub ->
        :result_stub
      end)

      assert SFTPClient.close_handle!(:handle_stub) == :result_stub
    end
  end

  describe "close_handle/1" do
    test "delegate to driver" do
      expect(MockDriver, :close_handle, fn :handle_stub ->
        :result_stub
      end)

      assert SFTPClient.close_handle(:handle_stub) == :result_stub
    end
  end

  describe "connect!/1" do
    test "delegate to driver" do
      expect(MockDriver, :connect!, fn :config_or_opts_stub ->
        :result_stub
      end)

      assert SFTPClient.connect!(:config_or_opts_stub) == :result_stub
    end
  end

  describe "connect!/2" do
    test "delegate to driver" do
      expect(MockDriver, :connect!, fn :config_or_opts_stub, :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.connect!(:config_or_opts_stub, :fun_stub) ==
               :result_stub
    end
  end

  describe "connect/1" do
    test "delegate to driver" do
      expect(MockDriver, :connect, fn :config_or_opts_stub ->
        :result_stub
      end)

      assert SFTPClient.connect(:config_or_opts_stub) == :result_stub
    end
  end

  describe "connect/2" do
    test "delegate to driver" do
      expect(MockDriver, :connect, fn :config_or_opts_stub, :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.connect(:config_or_opts_stub, :fun_stub) == :result_stub
    end
  end

  describe "delete_dir!/2" do
    test "delegate to driver" do
      expect(MockDriver, :delete_dir!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.delete_dir!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "delete_dir/2" do
    test "delegate to driver" do
      expect(MockDriver, :delete_dir, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.delete_dir(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "delete_file!/2" do
    test "delegate to driver" do
      expect(MockDriver, :delete_file!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.delete_file!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "delete_file/2" do
    test "delegate to driver" do
      expect(MockDriver, :delete_file, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.delete_file(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "disconnect/1" do
    test "delegate to driver" do
      expect(MockDriver, :disconnect, fn :conn_stub ->
        :result_stub
      end)

      assert SFTPClient.disconnect(:conn_stub) == :result_stub
    end
  end

  describe "download_file!/3" do
    test "delegate to driver" do
      expect(MockDriver, :download_file!, fn :conn_stub,
                                             :remote_path_stub,
                                             :local_path_stub ->
        :result_stub
      end)

      assert SFTPClient.download_file!(
               :conn_stub,
               :remote_path_stub,
               :local_path_stub
             ) == :result_stub
    end
  end

  describe "download_file/3" do
    test "delegate to driver" do
      expect(MockDriver, :download_file, fn :conn_stub,
                                            :remote_path_stub,
                                            :local_path_stub ->
        :result_stub
      end)

      assert SFTPClient.download_file(
               :conn_stub,
               :remote_path_stub,
               :local_path_stub
             ) == :result_stub
    end
  end

  describe "file_info!/2" do
    test "delegate to driver" do
      expect(MockDriver, :file_info!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.file_info!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "file_info/2" do
    test "delegate to driver" do
      expect(MockDriver, :file_info, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.file_info(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "link_info!/2" do
    test "delegate to driver" do
      expect(MockDriver, :link_info!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.link_info!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "link_info/2" do
    test "delegate to driver" do
      expect(MockDriver, :link_info, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.link_info(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "list_dir!/2" do
    test "delegate to driver" do
      expect(MockDriver, :list_dir!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.list_dir!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "list_dir/2" do
    test "delegate to driver" do
      expect(MockDriver, :list_dir, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.list_dir(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "make_dir!/2" do
    test "delegate to driver" do
      expect(MockDriver, :make_dir!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.make_dir!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "make_dir/2" do
    test "delegate to driver" do
      expect(MockDriver, :make_dir, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.make_dir(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "make_link!/3" do
    test "delegate to driver" do
      expect(MockDriver, :make_link!, fn :conn_stub,
                                         :symlink_path_stub,
                                         :target_path_stub ->
        :result_stub
      end)

      assert SFTPClient.make_link!(
               :conn_stub,
               :symlink_path_stub,
               :target_path_stub
             ) == :result_stub
    end
  end

  describe "make_link/3" do
    test "delegate to driver" do
      expect(MockDriver, :make_link, fn :conn_stub,
                                        :symlink_path_stub,
                                        :target_path_stub ->
        :result_stub
      end)

      assert SFTPClient.make_link(
               :conn_stub,
               :symlink_path_stub,
               :target_path_stub
             ) == :result_stub
    end
  end

  describe "open_dir!/2" do
    test "delegate to driver" do
      expect(MockDriver, :open_dir!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.open_dir!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "open_dir!/3" do
    test "delegate to driver" do
      expect(MockDriver, :open_dir!, fn :conn_stub, :path_stub, :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.open_dir!(:conn_stub, :path_stub, :fun_stub) ==
               :result_stub
    end
  end

  describe "open_dir/2" do
    test "delegate to driver" do
      expect(MockDriver, :open_dir, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.open_dir(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "open_dir/3" do
    test "delegate to driver" do
      expect(MockDriver, :open_dir, fn :conn_stub, :path_stub, :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.open_dir(:conn_stub, :path_stub, :fun_stub) ==
               :result_stub
    end
  end

  describe "open_file!/3" do
    test "delegate to driver" do
      expect(MockDriver, :open_file!, fn :conn_stub, :path_stub, :modes_stub ->
        :result_stub
      end)

      assert SFTPClient.open_file!(:conn_stub, :path_stub, :modes_stub) ==
               :result_stub
    end
  end

  describe "open_file!/4" do
    test "delegate to driver" do
      expect(MockDriver, :open_file!, fn :conn_stub,
                                         :path_stub,
                                         :modes_stub,
                                         :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.open_file!(
               :conn_stub,
               :path_stub,
               :modes_stub,
               :fun_stub
             ) == :result_stub
    end
  end

  describe "open_file/3" do
    test "delegate to driver" do
      expect(MockDriver, :open_file, fn :conn_stub, :path_stub, :modes_stub ->
        :result_stub
      end)

      assert SFTPClient.open_file(:conn_stub, :path_stub, :modes_stub) ==
               :result_stub
    end
  end

  describe "open_file/4" do
    test "delegate to driver" do
      expect(MockDriver, :open_file!, fn :conn_stub,
                                         :path_stub,
                                         :modes_stub,
                                         :fun_stub ->
        :result_stub
      end)

      assert SFTPClient.open_file!(
               :conn_stub,
               :path_stub,
               :modes_stub,
               :fun_stub
             ) == :result_stub
    end
  end

  describe "read_file_chunk!/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_file_chunk!, fn :conn_stub, :length_stub ->
        :result_stub
      end)

      assert SFTPClient.read_file_chunk!(:conn_stub, :length_stub) ==
               :result_stub
    end
  end

  describe "read_file_chunk/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_file_chunk, fn :conn_stub, :length_stub ->
        :result_stub
      end)

      assert SFTPClient.read_file_chunk(:conn_stub, :length_stub) ==
               :result_stub
    end
  end

  describe "read_file!/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_file!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.read_file!(:conn_stub, :path_stub) ==
               :result_stub
    end
  end

  describe "read_file/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_file, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.read_file(:conn_stub, :path_stub) ==
               :result_stub
    end
  end

  describe "read_link!/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_link!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.read_link!(:conn_stub, :path_stub) ==
               :result_stub
    end
  end

  describe "read_link/2" do
    test "delegate to driver" do
      expect(MockDriver, :read_link, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.read_link(:conn_stub, :path_stub) ==
               :result_stub
    end
  end

  describe "rename!/3" do
    test "delegate to driver" do
      expect(MockDriver, :rename!, fn :conn_stub,
                                      :old_path_stub,
                                      :new_path_stub ->
        :result_stub
      end)

      assert SFTPClient.rename!(:conn_stub, :old_path_stub, :new_path_stub) ==
               :result_stub
    end
  end

  describe "rename/3" do
    test "delegate to driver" do
      expect(MockDriver, :rename, fn :conn_stub,
                                     :old_path_stub,
                                     :new_path_stub ->
        :result_stub
      end)

      assert SFTPClient.rename(:conn_stub, :old_path_stub, :new_path_stub) ==
               :result_stub
    end
  end

  describe "stream_file!/2" do
    test "delegate to driver" do
      expect(MockDriver, :stream_file!, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.stream_file!(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "stream_file/2" do
    test "delegate to driver" do
      expect(MockDriver, :stream_file, fn :conn_stub, :path_stub ->
        :result_stub
      end)

      assert SFTPClient.stream_file(:conn_stub, :path_stub) == :result_stub
    end
  end

  describe "stream_file!/3" do
    test "delegate to driver" do
      expect(MockDriver, :stream_file!, fn :conn_stub,
                                           :path_stub,
                                           :chunk_size_stub ->
        :result_stub
      end)

      assert SFTPClient.stream_file!(:conn_stub, :path_stub, :chunk_size_stub) ==
               :result_stub
    end
  end

  describe "stream_file/3" do
    test "delegate to driver" do
      expect(MockDriver, :stream_file, fn :conn_stub,
                                          :path_stub,
                                          :chunk_size_stub ->
        :result_stub
      end)

      assert SFTPClient.stream_file(:conn_stub, :path_stub, :chunk_size_stub) ==
               :result_stub
    end
  end

  describe "upload_file!/3" do
    test "delegate to driver" do
      expect(MockDriver, :upload_file!, fn :conn_stub,
                                           :local_path_stub,
                                           :remote_path_stub ->
        :result_stub
      end)

      assert SFTPClient.upload_file!(
               :conn_stub,
               :local_path_stub,
               :remote_path_stub
             ) == :result_stub
    end
  end

  describe "upload_file/3" do
    test "delegate to driver" do
      expect(MockDriver, :upload_file, fn :conn_stub,
                                          :local_path_stub,
                                          :remote_path_stub ->
        :result_stub
      end)

      assert SFTPClient.upload_file(
               :conn_stub,
               :local_path_stub,
               :remote_path_stub
             ) == :result_stub
    end
  end

  describe "write_file_chunk!/2" do
    test "delegate to driver" do
      expect(MockDriver, :write_file_chunk!, fn :handle_stub, :binary_stub ->
        :result_stub
      end)

      assert SFTPClient.write_file_chunk!(:handle_stub, :binary_stub) ==
               :result_stub
    end
  end

  describe "write_file_chunk/2" do
    test "delegate to driver" do
      expect(MockDriver, :write_file_chunk, fn :handle_stub, :binary_stub ->
        :result_stub
      end)

      assert SFTPClient.write_file_chunk(:handle_stub, :binary_stub) ==
               :result_stub
    end
  end

  describe "write_file!/3" do
    test "delegate to driver" do
      expect(MockDriver, :write_file!, fn :conn_stub,
                                          :path_stub,
                                          :binary_stub ->
        :result_stub
      end)

      assert SFTPClient.write_file!(:conn_stub, :path_stub, :binary_stub) ==
               :result_stub
    end
  end

  describe "write_file/3" do
    test "delegate to driver" do
      expect(MockDriver, :write_file, fn :conn_stub, :path_stub, :binary_stub ->
        :result_stub
      end)

      assert SFTPClient.write_file(:conn_stub, :path_stub, :binary_stub) ==
               :result_stub
    end
  end
end
