defmodule SFTPClient.Handle do
  @moduledoc """
  A struct that contains a connection and handle ID that points to a file or
  directory on the remote server.
  """

  defstruct [:conn, :id]

  alias SFTPClient.Conn

  @type t :: %__MODULE__{conn: Conn.t(), id: term}
end
