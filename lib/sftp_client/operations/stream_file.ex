defmodule SFTPClient.Operations.StreamFile do
  use SFTPClient.Operation

  alias SFTPClient.Stream, as: SFTPStream

  @spec stream_file(Conn.t(), String.t()) :: SFTPStream.t()
  def stream_file(%Conn{} = conn, path) do
    %SFTPStream{conn: conn, path: path}
  end

  @spec stream_file(Conn.t(), String.t(), non_neg_integer) :: SFTPStream.t()
  def stream_file(%Conn{} = conn, path, chunk_size) do
    %SFTPStream{conn: conn, path: path, chunk_size: chunk_size}
  end
end
