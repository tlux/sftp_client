defmodule SFTPClient.Operations.Disconnect do
  use SFTPClient.Operation

  @spec disconnect(Conn.t()) :: :ok
  def disconnect(%Conn{} = conn) do
    :ok = sftp_adapter().stop_channel(conn.channel_pid)
    :ok = ssh_adapter().close(conn.conn_ref)
  end
end
