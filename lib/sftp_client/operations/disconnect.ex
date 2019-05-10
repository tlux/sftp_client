defmodule SFTPClient.Operations.Disconnect do
  @moduledoc """
  A module containing operations to disconnect from an SSH/SFTP server.
  """

  import SFTPClient.OperationUtil

  alias SFTPClient.Conn

  @doc """
  Stops an SFTP channel and closes the SSH connection.
  """
  @spec disconnect(Conn.t()) :: :ok
  def disconnect(%Conn{} = conn) do
    :ok = sftp_adapter().stop_channel(conn.channel_pid)
    :ok = ssh_adapter().close(conn.conn_ref)
  end
end
