defmodule SFTPClient.OperationError do
  @moduledoc """
  An error that is raised when an operation failed.
  """

  defexception [:reason]

  @type t :: %__MODULE__{reason: term}

  def message(error) do
    "Operation failed: #{error.reason}"
  end
end
