defmodule SFTPClient.Conn do
  @moduledoc """
  A struct containing connection-specific information.
  """

  alias SFTPClient.Config

  defstruct [:config, :channel_pid, :conn_ref]

  @type t :: %__MODULE__{
          config: Config.t(),
          channel_pid: pid,
          conn_ref: term
        }
end
