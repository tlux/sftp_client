defmodule SFTPClient.DirEntry do
  defstruct [:filename, :path, :stat]

  @type t :: %__MODULE__{
          filename: String.t(),
          path: String.t(),
          stat: SFTPClient.SSHXferAttr.t()
        }
end
