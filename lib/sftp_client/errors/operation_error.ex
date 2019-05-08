defmodule SFTPClient.OperationError do
  @moduledoc """
  An error that is raised when an operation failed.
  """

  defexception [:reason]

  def message(error) do
    "Operation failed: #{error.reason}"
  end
end
