defmodule SFTPClient.Operations.DownloadFile do
  use SFTPClient.Operation

  def download_file!(%Conn{} = conn, remote_path, local_path) do
    source_stream = SFTPClient.stream_file(conn, remote_path)
    target_stream = File.stream!(local_path)

    source_stream
    |> Stream.into(target_stream)
    |> Stream.run()
  end
end
