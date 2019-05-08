defmodule SFTPClient.Adapters.SSH do
  @moduledoc """
  A behavior that defines required callbacks for a low-level SSH adapter.
  """

  @callback close(conn_ref :: pid) :: :ok
end
