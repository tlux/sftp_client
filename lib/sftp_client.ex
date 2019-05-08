defmodule SFTPClient do
  import SFTPClient.Driver, only: [run: 3]

  alias SFTPClient.Operations

  @typedoc """
  File access modes that can be used when opening files directly from the remote
  server.
  """
  @type access_mode :: :read | :write | :creat | :trunc | :append | :binary

  @doc delegate_to: {Operations.CloseHandle, :close_handle!, 1}
  def close_handle!(handle) do
    run(Operations.CloseHandle, :close_handle!, [handle])
  end

  @doc delegate_to: {Operations.CloseHandle, :close_handle, 1}
  def close_handle(handle) do
    run(Operations.CloseHandle, :close_handle, [handle])
  end

  @doc delegate_to: {Operations.Connect, :connect!, 1}
  def connect!(config_or_opts) do
    run(Operations.Connect, :connect!, [config_or_opts])
  end

  @doc delegate_to: {Operations.Connect, :connect, 1}
  def connect(config_or_opts) do
    run(Operations.Connect, :connect, [config_or_opts])
  end

  @doc delegate_to: {Operations.DeleteDir, :delete_dir!, 2}
  def delete_dir!(conn, path) do
    run(Operations.DeleteDir, :delete_dir!, [conn, path])
  end

  @doc delegate_to: {Operations.DeleteDir, :delete_dir, 2}
  def delete_dir(conn, path) do
    run(Operations.DeleteDir, :delete_dir, [conn, path])
  end

  @doc delegate_to: {Operations.DeleteFile, :delete_file!, 2}
  def delete_file!(conn, path) do
    run(Operations.DeleteFile, :delete_file!, [conn, path])
  end

  @doc delegate_to: {Operations.DeleteFile, :delete_file, 2}
  def delete_file(conn, path) do
    run(Operations.DeleteFile, :delete_file, [conn, path])
  end

  @doc delegate_to: {Operations.Disconnect, :disconnect, 1}
  def disconnect(conn) do
    run(Operations.Disconnect, :disconnect, [conn])
  end

  @doc delegate_to: {Operations.DownloadFile, :download_file!, 3}
  def download_file!(conn, remote_path, local_path) do
    run(Operations.DownloadFile, :download_file!, [
      conn,
      remote_path,
      local_path
    ])
  end

  @doc delegate_to: {Operations.DownloadFile, :download_file, 3}
  def download_file(conn, remote_path, local_path) do
    run(Operations.DownloadFile, :download_file, [conn, remote_path, local_path])
  end

  @doc delegate_to: {Operations.FileInfo, :file_info!, 2}
  def file_info!(conn, path) do
    run(Operations.FileInfo, :file_info!, [conn, path])
  end

  @doc delegate_to: {Operations.FileInfo, :file_info, 2}
  def file_info(conn, path) do
    run(Operations.FileInfo, :file_info, [conn, path])
  end

  @doc delegate_to: {Operations.LinkInfo, :link_info!, 2}
  def link_info!(conn, path) do
    run(Operations.LinkInfo, :link_info!, [conn, path])
  end

  @doc delegate_to: {Operations.LinkInfo, :link_info, 2}
  def link_info(conn, path) do
    run(Operations.LinkInfo, :link_info, [conn, path])
  end

  @doc delegate_to: {Operations.ListDir, :list_dir!, 2}
  def list_dir!(conn, path) do
    run(Operations.ListDir, :list_dir!, [conn, path])
  end

  @doc delegate_to: {Operations.ListDir, :list_dir, 2}
  def list_dir(conn, path) do
    run(Operations.ListDir, :list_dir, [conn, path])
  end

  @doc delegate_to: {Operations.MakeDir, :make_dir!, 2}
  def make_dir!(conn, path) do
    run(Operations.MakeDir, :make_dir!, [conn, path])
  end

  @doc delegate_to: {Operations.MakeDir, :make_dir, 2}
  def make_dir(conn, path) do
    run(Operations.MakeDir, :make_dir, [conn, path])
  end

  @doc delegate_to: {Operations.MakeSymlink, :make_symlink!, 3}
  def make_symlink!(conn, symlink_path, target_path) do
    run(Operations.MakeSymlink, :make_symlink!, [
      conn,
      symlink_path,
      target_path
    ])
  end

  @doc delegate_to: {Operations.MakeSymlink, :make_symlink, 3}
  def make_symlink(conn, symlink_path, target_path) do
    run(Operations.MakeSymlink, :make_symlink, [conn, symlink_path, target_path])
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir!, 2}
  def open_dir!(conn, path) do
    run(Operations.OpenDir, :open_dir!, [conn, path])
  end

  @doc delegate_to: {Operations.OpenDir, :open_dir, 2}
  def open_dir(conn, path) do
    run(Operations.OpenDir, :open_dir, [conn, path])
  end

  @doc delegate_to: {Operations.OpenFile, :open_file!, 3}
  def open_file!(conn, path, modes) do
    run(Operations.OpenFile, :open_file!, [conn, path, modes])
  end

  @doc delegate_to: {Operations.OpenFile, :open_file, 3}
  def open_file(conn, path, modes) do
    run(Operations.OpenFile, :open_file, [conn, path, modes])
  end

  @doc delegate_to: {Operations.ReadFileChunk, :read_file_chunk!, 2}
  def read_file_chunk!(handle, length) do
    run(Operations.ReadFileChunk, :read_file_chunk!, [handle, length])
  end

  @doc delegate_to: {Operations.ReadFileChunk, :read_file_chunk, 2}
  def read_file_chunk(handle, length) do
    run(Operations.ReadFileChunk, :read_file_chunk, [handle, length])
  end

  @doc delegate_to: {Operations.ReadFile, :read_file!, 2}
  def read_file!(conn, path) do
    run(Operations.ReadFile, :read_file!, [conn, path])
  end

  @doc delegate_to: {Operations.ReadFile, :read_file, 2}
  def read_file(conn, path) do
    run(Operations.ReadFile, :read_file, [conn, path])
  end

  @doc delegate_to: {Operations.ReadLink, :read_link!, 2}
  def read_link!(conn, path) do
    run(Operations.ReadLink, :read_link!, [conn, path])
  end

  @doc delegate_to: {Operations.ReadLink, :read_link, 2}
  def read_link(conn, path) do
    run(Operations.ReadLink, :read_link, [conn, path])
  end

  @doc delegate_to: {Operations.Rename, :rename!, 3}
  def rename!(conn, old_name, new_name) do
    run(Operations.Rename, :rename!, [conn, old_name, new_name])
  end

  @doc delegate_to: {Operations.Rename, :rename, 3}
  def rename(conn, old_name, new_name) do
    run(Operations.Rename, :rename, [conn, old_name, new_name])
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file!, 3}
  def stream_file!(conn, path, chunk_size) do
    run(Operations.StreamFile, :stream_file!, [conn, path, chunk_size])
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file!, 2}
  def stream_file!(conn, path) do
    run(Operations.StreamFile, :stream_file!, [conn, path])
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file, 3}
  def stream_file(conn, path, chunk_size) do
    run(Operations.StreamFile, :stream_file, [conn, path, chunk_size])
  end

  @doc delegate_to: {Operations.StreamFile, :stream_file, 2}
  def stream_file(conn, path) do
    run(Operations.StreamFile, :stream_file, [conn, path])
  end

  @doc delegate_to: {Operations.WriteFileChunk, :write_file_chunk!, 2}
  def write_file_chunk!(handle, data) do
    run(Operations.WriteFileChunk, :write_file_chunk!, [handle, data])
  end

  @doc delegate_to: {Operations.WriteFileChunk, :write_file_chunk, 2}
  def write_file_chunk(handle, data) do
    run(Operations.WriteFileChunk, :write_file_chunk, [handle, data])
  end

  @doc delegate_to: {Operations.WriteFile, :write_file!, 3}
  def write_file!(conn, path, data) do
    run(Operations.WriteFile, :write_file!, [conn, path, data])
  end

  @doc delegate_to: {Operations.WriteFile, :write_file, 3}
  def write_file(conn, path, data) do
    run(Operations.WriteFile, :write_file, [conn, path, data])
  end
end
