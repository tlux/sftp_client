defmodule SFTPClient.Adapters.SSH do
  @callback close(conn_ref :: pid) :: :ok
end
