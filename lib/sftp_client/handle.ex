defmodule SFTPClient.Handle do
  defstruct [:conn, :id]

  alias SFTPClient.Conn

  @type t :: %__MODULE__{conn: Conn.t(), id: term}
end
