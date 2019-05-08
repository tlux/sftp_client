defmodule SFTPClient.Entry do
  @moduledoc """
  A struct that represents a directory entry on a remote server, containing the
  filename, full path and meta data.
  """

  defstruct [:filename, :path, :stat]

  @type t :: %__MODULE__{
          filename: String.t(),
          path: String.t(),
          stat: SFTPClient.SSHXferAttr.t()
        }
end
