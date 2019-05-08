defmodule SFTPClient do
  import SFTPClient.Driver, only: [run: 3]

  alias SFTPClient.Operations

  @typedoc """
  File access modes that can be used when opening files directly from the remote
  server.
  """
  @type access_mode :: :read | :write | :creat | :trunc | :append | :binary

  def close_handle!(handle) do
    run(Operations.CloseHandle, :close_handle!, [handle])
  end

  def close_handle(handle) do
    run(Operations.CloseHandle, :close_handle, [handle])
  end

  def connect!(config_or_opts) do
    run(Operations.Connect, :connect!, [config_or_opts])
  end

  def connect(config_or_opts) do
    run(Operations.Connect, :connect, [config_or_opts])
  end

  def delete_dir!(conn, path) do
    run(Operations.DeleteDir, :delete_dir!, [conn, path])
  end

  def delete_dir(conn, path) do
    run(Operations.DeleteDir, :delete_dir, [conn, path])
  end

  def delete_file!(conn, path) do
    run(Operations.DeleteFile, :delete_file!, [conn, path])
  end

  def delete_file(conn, path) do
    run(Operations.DeleteFile, :delete_file, [conn, path])
  end

  def disconnect(conn) do
    run(Operations.Disconnect, :disconnect, [conn])
  end

  def download_file!(conn, remote_path, local_path) do
    run(Operations.DownloadFile, :download_file!, [
      conn,
      remote_path,
      local_path
    ])
  end

  def download_file(conn, remote_path, local_path) do
    run(Operations.DownloadFile, :download_file, [conn, remote_path, local_path])
  end

  def file_info!(conn, path) do
    run(Operations.FileInfo, :file_info!, [conn, path])
  end

  def file_info(conn, path) do
    run(Operations.FileInfo, :file_info, [conn, path])
  end

  def link_info!(conn, path) do
    run(Operations.LinkInfo, :link_info!, [conn, path])
  end

  def link_info(conn, path) do
    run(Operations.LinkInfo, :link_info, [conn, path])
  end

  def list_dir!(conn, path) do
    run(Operations.ListDir, :list_dir!, [conn, path])
  end

  def list_dir(conn, path) do
    run(Operations.ListDir, :list_dir, [conn, path])
  end

  def make_dir!(conn, path) do
    run(Operations.MakeDir, :make_dir!, [conn, path])
  end

  def make_dir(conn, path) do
    run(Operations.MakeDir, :make_dir, [conn, path])
  end

  def make_symlink!(conn, symlink_path, target_path) do
    run(Operations.MakeSymlink, :make_symlink!, [
      conn,
      symlink_path,
      target_path
    ])
  end

  def make_symlink(conn, symlink_path, target_path) do
    run(Operations.MakeSymlink, :make_symlink, [conn, symlink_path, target_path])
  end

  def open_dir!(conn, path) do
    run(Operations.OpenDir, :open_dir!, [conn, path])
  end

  def open_dir(conn, path) do
    run(Operations.OpenDir, :open_dir, [conn, path])
  end

  def open_file!(conn, path, modes) do
    run(Operations.OpenFile, :open_file!, [conn, path, modes])
  end

  def open_file(conn, path, modes) do
    run(Operations.OpenFile, :open_file, [conn, path, modes])
  end

  def read_file_chunk!(handle, length) do
    run(Operations.ReadFileChunk, :read_file_chunk!, [handle, length])
  end

  def read_file_chunk(handle, length) do
    run(Operations.ReadFileChunk, :read_file_chunk, [handle, length])
  end

  def read_file!(conn, path) do
    run(Operations.ReadFile, :read_file!, [conn, path])
  end

  def read_file(conn, path) do
    run(Operations.ReadFile, :read_file, [conn, path])
  end

  def read_link!(conn, path) do
    run(Operations.ReadLink, :read_link!, [conn, path])
  end

  def read_link(conn, path) do
    run(Operations.ReadLink, :read_link, [conn, path])
  end

  def rename!(conn, old_name, new_name) do
    run(Operations.Rename, :rename!, [conn, old_name, new_name])
  end

  def rename(conn, old_name, new_name) do
    run(Operations.Rename, :rename, [conn, old_name, new_name])
  end

  def stream_file!(conn, path, chunk_size) do
    run(Operations.StreamFile, :stream_file!, [conn, path, chunk_size])
  end

  def stream_file!(conn, path) do
    run(Operations.StreamFile, :stream_file!, [conn, path])
  end

  def stream_file(conn, path, chunk_size) do
    run(Operations.StreamFile, :stream_file, [conn, path, chunk_size])
  end

  def stream_file(conn, path) do
    run(Operations.StreamFile, :stream_file, [conn, path])
  end

  def write_file_chunk!(handle, data) do
    run(Operations.WriteFileChunk, :write_file_chunk!, [handle, data])
  end

  def write_file_chunk(handle, data) do
    run(Operations.WriteFileChunk, :write_file_chunk, [handle, data])
  end

  def write_file!(conn, path, data) do
    run(Operations.WriteFile, :write_file!, [conn, path, data])
  end

  def write_file(conn, path, data) do
    run(Operations.WriteFile, :write_file, [conn, path, data])
  end
end
