defmodule SFTPClient.Operations.DownloadFile do
  use SFTPClient.Operation

  @spec download_file!(Conn.t(), String.t(), String.t()) :: :ok | no_return
  def download_file!(%Conn{} = conn, remote_path, local_path) do
    local_path = get_local_path(local_path, remote_path)
    source_stream = SFTPClient.stream_file(conn, remote_path)
    target_stream = File.stream!(local_path)

    source_stream
    |> Stream.into(target_stream)
    |> Stream.run()
  end

  defp get_local_path(local_path, remote_path) do
    if File.dir?(local_path) do
      Path.join(local_path, Path.basename(remote_path))
    else
      local_path
    end
  end
end
